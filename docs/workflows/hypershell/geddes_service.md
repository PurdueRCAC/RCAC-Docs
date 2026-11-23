---
title: "Tier 4: A Persistent Service on Geddes"
tags:
  - Workflows
  - HyperShell
  - Geddes
authors:
  - glentner
search:
  boost: 2
---

# Tier 4: A Persistent Service on Geddes

In [tier 3](pipelines.md), the server, the database and the helper script that schedules client jobs
all live on one login node of one cluster, and the campaign lasts as long as you keep them running.
Tier 4 is the same kind of campaign made permanent and spread over more than one cluster. The server
and its database run as a service on [Geddes](../../userguides/geddes/index.md), RCAC's
composable platform for persistent services, where they keep running whether or not anyone is
logged in. On each cluster, one small process, a HyperShell **relay**, connects to that server and
starts client jobs as the work needs them.

Tier 4 has two pages. This one deploys the server and its database on Geddes, through the Rancher
web interface. [Autoscaling Clients Across Clusters](autoscaling.md) runs the relays on
Gautschi and Negishi and submits the work.

## Who this is for

Labs that run a long campaign or a standing service: work that arrives every day for months, that
several people submit to, or that should use more than one cluster.

## Move on when

This is the top tier. If your work does not need a standing service, the lower tiers are simpler to
run; see [the tiers](index.md#the-tiers).

## Minimum version

HyperShell 2.9.0, for the relay, zones, autoscaling across relay sites and the published container
image. Task groups date from 2.8.0. The server's container image and the HyperShell module on the
clusters must be the same version: clients and servers of different versions do not talk to each
other. Check the module with `hs --version`; see [HyperShell versions](index.md#hypershell-versions).

## The example: a nightly survey

An astronomy group runs a time-domain survey. Every night, a telescope images the same set of
fields, and every morning the night's images are processed to find what changed. Each night has
three phases:

| Phase | Tasks | Needs | Group, for the night of 2026-11-23 | Zone |
|---|---|---|---|---|
| Calibrate | One per field: remove the instrument's signature from the images | A few CPU cores | `202611230` | `cpu` |
| Detect | One per field: find every source in the calibrated images | A GPU | `202611231` | `gpu` |
| Catalog | One: merge the night's detections into a catalog | A few CPU cores | `202611232` | `cpu` |

Detection needs calibrated images, and the catalog needs every field's detections, so the
[task groups](pipelines.md#task-groups-when-a-task-may-run) put the phases in order, as in tier 3.
A standing server keeps one order for all the work it will ever hold, so each night's groups must
come after the night before's: the group is the night's date followed by the phase number, 0, 1 or
2. The [zones](pipelines.md#zones-where-a-task-may-run) send each phase to the hardware it needs.
The survey runs every night for months, so its server and database run as a service, and
calibration, which any cluster can do, runs on whichever cluster has room.

## How the pieces fit

| Piece | Where it runs | What it does |
|---|---|---|
| TimescaleDB | Geddes, in the service's pod | The database: every task of every night, its command, where it ran and how it ended. TimescaleDB is PostgreSQL with extensions for data that grows with time. |
| Server | Geddes, in the same pod | Holds the queue, hands tasks to the relays, and plans how many clients each zone needs at each cluster |
| Relay | `login00` of each cluster | Connects to the server, takes the tasks for the zones it serves, and starts clients in Slurm jobs as the server's plan asks |
| Clients | Compute nodes, in Slurm jobs | Connect to their cluster's relay and run the tasks |
| `hs submit`, `hs list` | `login00` of Gautschi | Write tasks to the database and read their outcomes |

The pod's two containers share one network address, so the server reaches the database at
`localhost`. Only the `login00` nodes connect to Geddes: the relays to the server, and `hs submit`
and `hs list` to the database. Compute nodes connect only to the relay on their own cluster's
`login00`.

## Before you begin

You need access to Geddes and a namespace in your group's Rancher project; see
[Geddes access](../../userguides/geddes/access.md). This page builds on the
[Geddes database guide](../../userguides/geddes/examples/database.md), which deploys a PostgreSQL
database through the same Rancher forms; read it first if Rancher is new to you. Throughout this page
and the next, replace `<your-namespace>` with your namespace on Geddes.

The service's network name is `hypershell.<your-namespace>.geddes.rcac.purdue.edu`: Geddes names
a Load Balancer service `<servicename>.<namespace>.geddes.rcac.purdue.edu`, and this page names the
service `hypershell`.

### Make the credentials on login00

The service needs three secrets: the key that relays prove themselves with, the database password,
and a TLS certificate for the server. Make them once, on Gautschi's `login00`, where the relay of the
next page will run. Log in to it:

```bash
ssh login00.gautschi.rcac.purdue.edu
```

Make a directory for the survey's HyperShell files in your home directory, which is backed up and
never purged:

```bash
mkdir -p $HOME/survey/hypershell $HOME/survey/geddes
cd $HOME/survey
```

Make the key and the database password, each a long random string in a file, and make each file
readable only by you:

```bash
openssl rand -hex 32 > hypershell/upstream.key
openssl rand -hex 24 > hypershell/db.password
chmod 600 hypershell/upstream.key hypershell/db.password
```

The server encrypts its connections with TLS. Make it a certificate for the service's network name,
valid for 825 days. The certificate's private key, `tls.key`, is secret too:

```bash
name=hypershell.<your-namespace>.geddes.rcac.purdue.edu
openssl req -x509 -newkey rsa:3072 -nodes -days 825 -subj "/CN=$name" -addext "subjectAltName=DNS:$name" -keyout geddes/tls.key -out geddes/tls.crt
chmod 600 geddes/tls.key
openssl x509 -in geddes/tls.crt -noout -fingerprint -sha256
```

The last command prints the certificate's fingerprint: `sha256 Fingerprint=` followed by 32 pairs
of hexadecimal digits separated by colons. Each relay checks the server's certificate against it, so
note it for the next page. A HyperShell server makes its own certificate when it has none, but in a pod it would
make a new one each time the pod starts, and every relay would then refuse it. A certificate kept in
a Secret stays the same. It expires after 825 days; see
[Operate and maintain](#operate-and-maintain).

## Store the credentials as Secrets

Kubernetes keeps credentials in **Secrets**. The pod reads them from there, so no password or key is
written into the pod's settings, where anyone who can view the workload would see it. Create three
Opaque Secrets in the Rancher web interface. Print each value on `login00` with `cat` (for example,
`cat hypershell/upstream.key`) and copy it into the form.

1. Using the far left menu, select **Storage** > **Secrets**
2. Click **Create** at the top right
3. Select **Opaque** and fill out the form
    * Select your **Namespace**
    * Set **Name** to `hypershell-auth`
    * Under the data tab, fill in **Key** `auth` and, as its value, the contents of `hypershell/upstream.key`
    * Click **Create** at the bottom right
4. Repeat steps 2 and 3 for the database password: **Name** `hypershell-db`, **Key** `password`,
   and the contents of `hypershell/db.password` as its value
5. Repeat steps 2 and 3 for the certificate: **Name** `hypershell-tls`. Under the data tab, click
   **add** to make a second key field. Fill in **Key** `tls.crt` with the whole contents of
   `geddes/tls.crt`, and **Key** `tls.key` with the whole contents of `geddes/tls.key`, each including
   its `-----BEGIN` and `-----END` lines

**How the credentials are stored.** The queue key, the database password and the server's
certificate and private key live in these three Secrets in your namespace, and on `login00` in files
that only you can read. In the pod, the key and the password reach the containers as environment
variables taken from the Secrets, and the certificate files are mounted from their Secret as files.
None of them appears in the workload's form, in a command line, or in this guide's examples.

## Deploy the pod

One Deployment runs one pod with two containers: TimescaleDB first, then the HyperShell server.

1. Select your **Project** from the top right dropdown
2. Using the far left menu, select **Workload**
3. Click **Create** at the top right
4. Select **Deployment**
5. Fill out the form
    * Select your **Namespace**
    * Set **Name** to `hypershell`
    * Set up the first container, the database
        + Set **Container Name** to `timescaledb`
        + Set **Container Image** to the TimescaleDB image, through the Geddes Docker Hub cache:
          `geddes-registry.rcac.purdue.edu/docker-hub-cache/timescale/timescaledb:2.32.1-pg17`
        + Under the **Environment Variables** section, select **Add Variable**, set its **Type**
          to **Secret key**, its **Variable Name** to `POSTGRES_PASSWORD`, its **Secret** to
          `hypershell-db` and its **Key** to `password`
        + Select **Add Variable** again for a plain key and value: `POSTGRES_DB = hypershell`,
          the name of the database to create
    * Create a persistent volume for the database
        + Select the **Storage** tab from within the current form on the left hand side
        + Select **Add Volume** and choose **Create Persistent Volume Claim**
        + Set **Name** to `hypershell-db`
        + Select **Single-Node Read/Write**
        + Set **Storage Class** to `geddes-performance-singlenode`, the class for databases, and
          **Capacity** to `20` GiB
        + Set **Mount Point** to the database's data directory, `/var/lib/postgresql/data`
        + Set **Sub Path** to `data`
    * Set the database's CPU limits
        + Select the **Resources** tab on the left within the current form
        + Fill in `2000` for both **CPU Reservation** and **CPU Limit**: two cores
    * Add the second container, the server
        + Select **Add Container**, next to `timescaledb` at the top of the form
        + Set **Container Name** to `server`
        + Set **Container Image** to `ghcr.io/hypershell/hypershell:2.9.0`, HyperShell's published
          image; see [The images](#the-images)
        + Under **Command**, leave **Command** empty and set **Arguments** to
          `--autoscaling=dynamic --initdb`
        + Under **Ports**, select **Add Port** and fill in **Private Container Port** `50001`,
          protocol **TCP**
        + Under **Environment Variables**, add the variables in the table below
        + Select the **Storage** tab, select **Add Volume** and choose **Secret**. Set **Secret** to
          `hypershell-tls` and **Mount Point** to `/tls`. The certificate's two keys become the
          files `/tls/tls.crt` and `/tls/tls.key`
        + On the **Resources** tab, fill in `1000` for both **CPU Reservation** and **CPU Limit**:
          one core
    * Set up the pod label
        + Select **Labels & Annotations** on the left side of the current form
        + Select **Add Label** under the **Pod Labels** section
        + Fill in **Key** `hypershell` and **Value** `survey`. The service in the next section finds
          the pod by this label
    * Set the upgrade policy
        + Select **Scaling and Upgrade Policy** on the left side of the current form
        + Select **Recreate**. The database's volume can be attached to one pod at a time, so an
          upgrade must stop the old pod before it starts the new one
    * Select **Create** to launch the pod

The server container's environment variables:

| Variable Name | Type | Value |
|---|---|---|
| `HYPERSHELL_SERVER_AUTH` | Secret key | Secret `hypershell-auth`, Key `auth` |
| `HYPERSHELL_SERVER_BIND` | Key/Value | `0.0.0.0` |
| `HYPERSHELL_SERVER_TLS_CERT` | Key/Value | `/tls/tls.crt` |
| `HYPERSHELL_SERVER_TLS_KEY` | Key/Value | `/tls/tls.key` |
| `HYPERSHELL_DATABASE_PROVIDER` | Key/Value | `timescale` |
| `HYPERSHELL_DATABASE_HOST` | Key/Value | `localhost` |
| `HYPERSHELL_DATABASE_PORT` | Key/Value | `5432` |
| `HYPERSHELL_DATABASE_DATABASE` | Key/Value | `hypershell` |
| `HYPERSHELL_DATABASE_USER` | Key/Value | `postgres` |
| `HYPERSHELL_DATABASE_PASSWORD` | Secret key | Secret `hypershell-db`, Key `password` |
| `HYPERSHELL_AUTOSCALE_DISTRIBUTION` | Key/Value | `spread` |
| `HYPERSHELL_LOGGING_LEVEL` | Key/Value | `INFO` |

Every HyperShell setting can come from an environment variable named `HYPERSHELL_` followed by the
setting's section and name, so the server needs no configuration file:

| Setting | What it does |
|---|---|
| `server.auth` | The queue key. Every relay must present the same key. |
| `server.bind` | Listen on every address of the pod, so that the service can reach it, not only on `localhost`. The server listens on port 50001. |
| `server.tls.cert`, `server.tls.key` | The certificate and private key from the `hypershell-tls` Secret. |
| `database.*` | The TimescaleDB database in the other container. The password is the one TimescaleDB was given in `POSTGRES_PASSWORD`, from the same Secret. |
| `autoscale.distribution` | How a zone's clients are shared out between clusters: `spread` gives each new client to the cluster that runs the fewest. [Autoscaling Clients Across Clusters](autoscaling.md#spread-or-fill) explains the choice. |
| `logging.level` | `INFO` logs each task and each change of plan; the image's default, `TRACE`, logs every message. |

The arguments run the server's own command, `hs server`, which the image starts:

| Argument | What it does |
|---|---|
| `--autoscaling=dynamic` | Plan each zone's clients over the relays that serve it, growing a zone by up to one client a minute while its tasks are waiting, and publish the plan for the relays. The server starts no clients itself, and it runs until it is stopped. |
| `--initdb` | Create the database's tables when the server starts, and on an upgrade bring them up to date. It changes nothing in a database that is already up to date, so it is safe on every start. |

Wait a few minutes while the volume is created and the images are pulled. As in the database guide,
the "does not have minimum availability" message is expected at first, and more than 5 minutes
usually means a problem. The server may restart once or twice while the database starts, which is
expected. To check, click the workload's name, then the menu at the right of the pod, select **View
Logs**, and choose each container in turn. The `timescaledb` log ends with
`database system is ready to accept connections`. The `server` log shows `Scheduler will run
forever`, `Empty database - waiting for initial tasks`, `Server listening on 0.0.0.0:50001` and
`Autoscale start (policy: dynamic, distribution: spread)`. When all goes well the Deployment shows
an Active status.

**How the data persists.** Everything the survey records, every task and its outcome, is in the
database, and the database's files are on the persistent volume claim `hypershell-db`. When the pod
is deleted, restarted or upgraded, Kubernetes starts a new pod that mounts the same volume, and the
new server finds every earlier task there. A task that was running when the pod stopped is set to run
again. The server container keeps nothing of its own: its key, password and certificate come from
the Secrets each time it starts. Geddes storage is replicated but not backed up; see
[Operate and maintain](#operate-and-maintain) for a backup.

### The images

| Container | Image | Notes |
|---|---|---|
| `timescaledb` | `timescale/timescaledb:2.32.1-pg17`, pulled through `geddes-registry.rcac.purdue.edu/docker-hub-cache/` | TimescaleDB's own image, which takes the official PostgreSQL image's variables, such as `POSTGRES_PASSWORD` and `POSTGRES_DB`. Use a tag without `-oss`: HyperShell uses features of the full TimescaleDB. The tag names its PostgreSQL version, 17, whose data directory is the mount point above. |
| `server` | `ghcr.io/hypershell/hypershell:2.9.0` | HyperShell's image, published on the GitHub Container Registry for each release. There is no `latest` tag: name the version that matches `hs --version` of the module on the clusters. |

The Docker Hub cache is the [Geddes registry's way around Docker Hub's pull limits](../../userguides/geddes/registry.md#using-the-geddes-registry-docker-hub-cache);
it serves Docker Hub images only. HyperShell's image is not on Docker Hub, so Geddes pulls it from
`ghcr.io` directly. If your Geddes project cannot reach `ghcr.io`, copy the image into a project of
your own in the Geddes registry, as the [registry guide](../../userguides/geddes/registry.md)
describes, and name that copy instead.

## Expose the server

The relays and `hs submit` on the clusters' `login00` nodes must reach the pod from outside Geddes.
Use a **Load Balancer** service on the private Purdue network, as the database guide does, with two
ports: the server's queue and the database.

1. Using the far left menu, navigate to **Service Discovery** > **Services**
2. Select **Create** at the top right
3. Select **Load Balancer**
4. Fill out the form
    * Select the **Namespace** where you deployed the pod
    * Set **Name** to `hypershell`. The service's network name will be
      `hypershell.<your-namespace>.geddes.rcac.purdue.edu`
    * Fill in a port named `queue` with **Listening Port** and **Target Port** `50001`
    * Select **Add Port** and fill in a port named `database` with **Listening Port** and
      **Target Port** `5432`
    * Select the **Selectors** tab within the current form
        + Fill in **Key** `hypershell` and **Value** `survey`, the pod label
        + The yellow bar turns green when the selector matches the pod. If you don't see a green bar
          with a matching pod, the service will not work
    * Select the **Labels & Annotations** tab within the current form
        + Select **Add Annotation**
        + Fill in **Key** `metallb.universe.tf/address-pool` and **Value** `geddes-private-pool`
    * Select **Create**

**What network exposure the server needs.** One Load Balancer service with an address on the
private Purdue network, reachable from campus networks, the cluster `login00` nodes among them,
and not from the internet. It opens two TCP ports: 50001, the server's queue, which the relays
connect to, and 5432, the database, which `hs submit`, `hs list` and the other commands that read
the record connect to. An Ingress cannot carry either: Geddes Ingresses carry web traffic, and these
are not. Do not use the public address pool. The queue is guarded by the key and encrypted with TLS,
and the database by its password; nothing else should be able to reach either. Compute nodes need
no route to Geddes.

## Check the service from login00

On Gautschi's `login00`, check that the service's name resolves to an address:

```bash
host hypershell.<your-namespace>.geddes.rcac.purdue.edu
```

Then point HyperShell at the database. Save this as `hypershell/database.toml` in the survey
directory:

```toml title="hypershell/database.toml"
--8<-- "docs/snippets/workflows/survey/database.toml"
```

Every command that reads or writes the survey's tasks runs with two variables set, as in tier 3:
`HYPERSHELL_SITE` names the survey's HyperShell directory, and `HYPERSHELL_CONFIG_FILE` names the one
configuration file to read. Count the tasks in the database:

```bash
module load hypershell
cd $HOME/survey
export HYPERSHELL_SITE="$PWD/hypershell"
export HYPERSHELL_CONFIG_FILE="$HYPERSHELL_SITE/database.toml"
hs list --count
```

It prints `0`: the database is reachable, the password works, and it holds no tasks yet. If it
cannot connect instead, check the service's selector and annotation, and that the pod is running.
The queue's port is checked when the first relay connects. The service is ready for the relays;
[Autoscaling Clients Across Clusters](autoscaling.md) starts them.

## Operate and maintain

**Logs.** The server's log, under **View Logs** for the `server` container, records each relay as it
connects, each change in the plan, and each task. For commands inside the pod, use **Execute Shell**
from the same menu: in the image, HyperShell is at `/opt/hypershell/bin/hs`.

**Back up the database.** RCAC keeps no backup of Geddes storage, so take your own, as the
[Geddes storage guide](../../userguides/geddes/storage.md#backing-up-a-database-from-a-container)
describes. From a workstation or front end with `kubectl` access to Geddes, write a dump of the
database to a file:

```bash
kubectl -n <your-namespace> get pods
kubectl -n <your-namespace> exec <pod> -c timescaledb -- pg_dump -U postgres -Fc hypershell > survey.dump
```

**Upgrade HyperShell.** When a new version of the module reaches the clusters, upgrade the service
to the same version. Back up the database, drain the relays (see
[Keep the relays running](autoscaling.md#keep-the-relays-running)), and in Rancher edit the
workload's `server` container to name the new image tag. The upgrade policy stops the old pod before
the new one starts, and `--initdb` brings the database's tables up to date. Then start the relays
with the new module.

**Change the key or the certificate.** Make a new key or certificate on `login00` as in
[Make the credentials on login00](#make-the-credentials-on-login00), drain the relays, edit the
Secret in Rancher (**Storage** > **Secrets**), and redeploy the workload so that the server reads
it. Then put the new key in `hypershell/upstream.key`, or the new fingerprint in `relay.toml`, on each
cluster's `login00`, and start the relays again. The certificate made above lasts 825 days.

**Troubleshooting.** The [Geddes troubleshooting page](../../userguides/geddes/troubleshooting.md)
covers pods that do not start and images that cannot be pulled.

HyperShell also offers an MCP server for AI assistants; running it beside this service is outside the
scope of this guide.

??? note "The two containers as a Kubernetes manifest"

    For readers who use `kubectl`, these are the pod's two container entries as the steps above
    create them. They are not a complete manifest: the volume, the Secrets, the label and the
    service are created in Rancher as above.

    ```yaml
    containers:
      - name: timescaledb
        image: geddes-registry.rcac.purdue.edu/docker-hub-cache/timescale/timescaledb:2.32.1-pg17
        env:
          - name: POSTGRES_PASSWORD
            valueFrom: {secretKeyRef: {name: hypershell-db, key: password}}
          - name: POSTGRES_DB
            value: hypershell
        volumeMounts:
          - {name: hypershell-db, mountPath: /var/lib/postgresql/data, subPath: data}
      - name: server
        image: ghcr.io/hypershell/hypershell:2.9.0
        args: ["--autoscaling=dynamic", "--initdb"]
        ports:
          - containerPort: 50001
        env:
          - name: HYPERSHELL_SERVER_AUTH
            valueFrom: {secretKeyRef: {name: hypershell-auth, key: auth}}
          - name: HYPERSHELL_DATABASE_PASSWORD
            valueFrom: {secretKeyRef: {name: hypershell-db, key: password}}
          # ... and the Key/Value variables of the table above
        volumeMounts:
          - {name: hypershell-tls, mountPath: /tls, readOnly: true}
    ```

For everything the server can do, see the
[`hs server` reference](https://hypershell.readthedocs.io/cli/server.html) in HyperShell's
documentation.

[Back to HyperShell User Guide](index.md){ .md-button }
