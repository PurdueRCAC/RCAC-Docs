# Research 05 — Tier 4 capstone: HyperShell server + TimescaleDB on Geddes, relay on login00

Scope: R10 (capstone), R12 (command and key conventions), R15 (accuracy). Read 2026-11-22.
Site citations are repo-relative `file:line` in RCAC-Docs. HyperShell citations are paths in the
HyperShell repository (develop branch, version `2.9.0a8` in `pyproject.toml`), or public URLs.
Anything marked **LIVE** cannot be settled from files and goes to the plan's validation envelope.

---

## 1. Geddes page style and Rancher terminology on this site

### 1.1 Step style

- **Structure.** Front matter is `tags: [Geddes]`, `authors:`, `search: boost: 2`
  (`docs/userguides/geddes/examples/database.md:1-9`). One H1, then H2 per phase ("Deploy a
  postgis Database", "Expose the Database to external clients", `database.md:11,13,46`).
- **Steps** are a numbered list of UI actions with **bold** UI labels. The long "Fill out the form"
  step nests `*` bullets per form tab and `+` sub-bullets per field (`database.md:15-42`).
- **Click paths** are written as prose with bold labels: "Select your **Project** from the top
  right dropdown", "Using the far left menu, select **Workload**", "Click **Create** at the top
  right" (`database.md:15-17`); menu nesting uses `>`: "**Service Discovery** > **Services**"
  (`database.md:50`), "**Storage > Secrets**" (`storage.md:143`).
- **Wait-and-check paragraph** after deploying: "does not have minimum availability" is expected;
  more than 5 minutes means a problem; check **View Logs** (`database.md:44`, `webserver.md:40-42`).
- **Screenshots** appear only on the web server page, as `![Geddes Web Server N](/assets/images/userguides/geddes/Geddes-web-server-N.png)`
  indented under the step (`webserver.md:16-56`). Their alt text is a filename-like label, not
  descriptive; R14 requires meaningful alt text, so the capstone must not copy that pattern. The
  troubleshooting page has better alt text ("Launching a persistent Pod via the Geddes UI",
  `troubleshooting.md:46`). The database page has no screenshots.
- **Admonitions** are rare: `!!! note` on storage backups (`storage.md:17-18`) and kubeconfig
  (`access.md:31-32`); "IMPORTANT:" is written inline in a bullet (`database.md:59`).
- **kubectl** blocks appear only as optional verification (`database.md:67-75`) or as an
  alternative path (`storage.md:166-188`). That fits the non-goal (no heavy YAML).

### 1.2 Exact Rancher terms used on the site

| Concept | Term(s) on the site | Where |
|---|---|---|
| Create a workload | **Workload** > **Create**; choose **Deployment Type**, "here we will select and use **Deployment**" | `database.md:16-18`, `workloads.md:15-22` |
| Deployment types offered | Deployment, CronJob, DaemonSet, Job, StatefulSet (cards on "Deployment: Create") | screenshot `Geddes-web-server-3.png` (`webserver.md:21`) |
| Form fields | **Namespace**, **Name**, **Container Image**, **Environment Variables** > **Add Variable** (**Variable Name**, **Value**) | `database.md:20-25` |
| Form tabs (left side) | General, Health Check, Labels & Annotations, Networking, Node Scheduling, Pod Scheduling, Resources, Scaling and Upgrade Policy, Security Context, Storage | screenshot `Geddes-web-server-4.png` (`webserver.md:26`) |
| Container selector, container kind | a **Container** dropdown showing `container-0`; radio **Init Container** / **Standard Container**; **Container Name**, **Pull Policy**, **Pull Secrets**, **Ports** > **Add Port** | screenshot `Geddes-web-server-4.png` |
| Command override | **Command** field ("specifying the sleep command via the Geddes UI") | `troubleshooting.md:44-46`, screenshot `pod-debugging-1.png` |
| Pod security | **Security Context** > **Pod Filesystem Group** (fsGroup) | `troubleshooting.md:50-61`, screenshot `pod-debugging-2.png` |
| Resources | **Resources** tab; **CPU Reservation** `2000`, **CPU Limit** `2000` | `database.md:34-37` |
| Pod label | **Labels & Annotations** > **Add Label** under **Pod Labels** (Key/Value) | `database.md:38-41` |
| Shell in a pod | vertical ellipsis > "Execute Shell" | `troubleshooting.md:21` |
| Logs | workload name > pod ellipsis > **View Logs** | `database.md:44`, `webserver.md:40` |

**Adding a second container to the same pod:** no page on the site does this. The screenshot shows
the **Container** dropdown (`container-0`) that, in Rancher's dashboard, carries the add-container
entry; the exact label is not documented here. **LIVE** (manual UI check).

### 1.3 Secrets

- The database guide stores the DB password as a **plain environment variable**
  (`POSTGRES_PASSWORD = <some password>`, `database.md:23-25`). Not a Secret.
- Secrets are created in the UI only in two places: **Storage > Secrets** > **Create** >
  **Opaque**, namespace, name, "Under the data tab click **add**", Key/value pairs, **Create**
  (`storage.md:141-152`); and **Storage** > **Secrets** > **Create** > **Registry**
  (`registry.md:72-85`).
- Env-from-secret appears only in kubectl YAML (`secretKeyRef`, `storage.md`-adjacent migration
  page `migration/geddes-to-geddes2-pvc-and-ingress.md:192-197`, created with
  `kubectl create secret generic ... --from-literal=ROOT_PASSWORD=...` at `:157`). How to reference
  a Secret key from the Rancher **Environment Variables** form, and how to mount a Secret as a
  volume (needed for TLS files), is **not on the site**. **LIVE** (manual UI check).
- Recommendation: the capstone should improve on the database guide and store the DB password,
  the HyperShell key, and the TLS certificate/key in Opaque Secrets, using the site's own Opaque
  click path (`storage.md:143-152`).

### 1.4 Persistent volume claims

- Storage classes, quoted exactly (`storage.md:24-27`): `geddes-standard-singlenode`,
  `geddes-standard-multinode`, `geddes-performance-singlenode`, `geddes-performance-multinode`.
  "Performance classes should be used for workloads with high I/O requirements (databases,
  AI/ML)" (`storage.md:22`). "The default storage class is "geddes-standard-singlenode""
  (`storage.md:36`).
- UI path inside the workload form: **Storage** tab > **Add Volume** > **Create Persistent Volume
  Claim**, **Name**, **Single-Node Read/Write**, **Storage Class**, **Capacity** in GiB, **Mount
  Point**, **Sub Path** (`database.md:26-33`; same in `storage.md:33-39`).
- The database guide mounts `/var/lib/postgresql/data` with **Sub Path** `data` (`database.md:32-33`).
  See 2.3 for why that matters for the PostgreSQL major chosen.
- No backup on Geddes storage: "RCAC currently provides no backup of Geddes storage"
  (`storage.md:18`); DB dump via `kubectl exec` is documented (`storage.md:74-84`).
- Geddes2 note: before deploying a PVC on Geddes2 "you must update the `storageClassName` to match
  an available storage class on Geddes2" (`migration/geddes-to-geddes2-pvc-and-ingress.md:100`),
  which implies class names may differ there. **LIVE.**

### 1.5 Services and network exposure

- ServiceTypes defined (`services.md:23-27`): **ClusterIP** "only reachable from within the
  cluster"; **NodePort** `<NodeIP>:<NodePort>`; **LoadBalancer**.
- The database guide exposes a TCP service with a **LoadBalancer**: "automatically assign an IP
  address on a private Purdue network ... A DNS name will automatically be configured for your
  service as `<servicename>.<namespace>.geddes.rcac.purdue.edu`" (`database.md:48`). UI:
  **Service Discovery** > **Services** > **Create** > **Load Balancer**; **Listening Port** and
  **Target Port**; **Selectors** tab matching the pod label (yellow bar turns green,
  `database.md:50-59`); **Labels & Annotations** > **Add Annotation**
  `metallb.universe.tf/address-pool` = `geddes-private-pool` (Purdue private range) or
  `geddes-public-pool` (public range) (`database.md:60-63`). Check the IP by hovering the port
  link, or `kubectl -n <namespace> get services`; check DNS with `host` (`database.md:65-75`).
- Ingress (nginx on Geddes, Traefik/Gateway API on Geddes2) is HTTP(S) only (`services.md:31-37`,
  `migration/geddes-to-geddes2-pvc-and-ingress.md:427-468`). The HyperShell queue is a raw TCP
  protocol with its own TLS, so **Ingress/HTTPRoute cannot carry it; a LoadBalancer Service is
  required.**
- **What a client on a cluster login node uses:** the DNS name
  `<servicename>.<namespace>.geddes.rcac.purdue.edu` (`database.md:48,55`). Nothing on the site
  says whether cluster login or compute nodes can reach `geddes-private-pool` addresses. With the
  relay design (section 4) only login00 needs to reach Geddes; compute nodes need only login00.
  **LIVE:** from login00, resolve the name and open TCP to ports 50001 and 5432.

### 1.6 Registry and image cache

- Docker Hub cache, Geddes 1: `geddes-registry.rcac.purdue.edu/docker-hub-cache/`
  (`registry.md:21`); non-official images keep the repo path
  (`.../docker-hub-cache/jupyter/tensorflow-notebook:latest`, `registry.md:23`); official images use
  `library` (`.../docker-hub-cache/library/mongo:latest`, `registry.md:25`). Also
  `workloads.md:21`, `database.md:22`, `webserver.md:25`, `troubleshooting.md:37`.
  Reason: Docker Hub pull limits (`registry.md:19`, `troubleshooting.md:63-71`).
- Geddes 2 registry is `geddes2-registry.rcac.purdue.edu` with OIDC and a CLI secret
  (`registry2.md:15-35`). **No Docker Hub cache path is documented for Geddes2.**
- **No cache for GHCR (or quay.io) is documented anywhere on the site** (grep of `docs/`).
- Private images: create a Harbor project, `docker tag`/`docker push` (`registry.md:27-52`), and a
  robot-account **Registry** secret for private projects (`registry.md:54-85`).

### 1.7 Geddes vs Geddes2 (open question)

The user guide's examples are Geddes (RKE1) era; the migration section moves users to Geddes2
(RKE2) with Traefik and possibly different storage classes and registry. The Rancher URL on the
site is `geddes.rcac.purdue.edu` (`access.md:21`). **LIVE / plan gate:** which cluster new
deployments should target, and whether `docker-hub-cache`, `geddes-private-pool`, and the
`geddes-standard-*` class names apply there. The capstone should follow whatever the database
guide is updated to; until then, mirror `database.md` exactly and say it is the Geddes guide.

---

## 2. Images

### 2.1 HyperShell image

- **What the repo builds:** `Dockerfile` — `FROM python:3.14-slim` (line 1), installs `libpq5`
  (13-17), creates user/group `hypershell` uid/gid 1001 with no home (19-20), `mkdir -p
  /var/lib/hypershell /var/log/hypershell` as root, no chown (22), env
  `HYPERSHELL_LOGGING_LEVEL=TRACE`, `HYPERSHELL_LOGGING_STYLE=SYSTEM`, `UV_PROJECT_ENVIRONMENT=/opt/hypershell`
  (24-31), `uv sync --frozen --all-packages` (35), `USER hypershell` (37),
  **`ENTRYPOINT ["/opt/hypershell/bin/hs", "server"]`**, **`CMD ["--forever"]`** (38-39).
- **Postgres/Timescale drivers are in the image:** `uv sync` installs the default `dev` group,
  which carries `psycopg` and `uuid-utils` (`pyproject.toml` `[dependency-groups] dev`; the
  Dockerfile comment at line 12 says libpq5 is for "the pure-python psycopg used by the dev group").
  The `timescale` provider needs the `postgres` and `uuid7` extras' packages
  (`docs/_include/database.rst:188-189`); both are present this way. **LIVE:** confirm in the pod.
- **Where it publishes:** `.github/workflows/docker.yml` pushes to `ghcr.io/hypershell/hypershell`
  (lines 31-33) on every published GitHub release, multi-arch amd64/arm64, signed with cosign.
  Tags (lines 197-201): `{{version}}`, `{{major}}.{{minor}}`, `{{major}}`, `sha-<short>`;
  `latest`, major and major.minor are suppressed for PEP 440 pre-releases (comment, lines 187-191).
  `docs/install.rst:253-263` documents `docker pull ghcr.io/hypershell/hypershell:latest`
  ("versionadded 2.9.0", `install.rst:281-282`).
- **Verified on the web (2026-11-22):** the GHCR package page
  <https://github.com/hypershell/hypershell/pkgs/container/hypershell> is public (133 downloads)
  and lists **`2.9.0a8`** and `sha-2ffb5cc` (9 days old) plus untagged digests. **There is no
  `latest` tag and no `2.9.0` tag yet**, since every image so far is a pre-release. Docker Hub
  `hypershell/hypershell` returns 404 (no Docker Hub image).
- **Consequences for the page:** pin `ghcr.io/hypershell/hypershell:2.9.0` (it will exist once
  2.9.0 is released; until then `2.9.0a8` is the only tag that can be tested). Do not write
  `:latest`.
- **Pulling on Geddes:** the site documents no GHCR cache. Options, in order of preference:
  (1) pull `ghcr.io/hypershell/hypershell:2.9.0` directly (public; GHCR has no Docker Hub-style
  anonymous limit problem; **LIVE:** Geddes nodes can egress to ghcr.io); (2) copy it into the
  user's own Harbor project with `docker pull/tag/push` (`registry.md:34-52`); (3) ask RCAC to add a
  GHCR proxy-cache project to Harbor (a staff decision, not something the page can promise).
- **Gotchas to design around (all LIVE):**
  - `hs` is not on `PATH` in the image (no PATH entry for `/opt/hypershell/bin`; the Apptainer
    definition links `/bin/hs`, the Dockerfile does not). So in **Execute Shell** the command is
    `/opt/hypershell/bin/hs list`, and the Rancher **Command** field should be left empty and only
    arguments set (entrypoint stays `hs server`).
  - User 1001 has no writable home and `/var/lib/hypershell` is root-owned, so the default site
    directory and the auto-generated TLS certificate (written under the user site lib,
    `docs/security.rst:289-300`) cannot be created; `src/hypershell/core/platform.py` swallows the
    `PermissionError`. Provide the TLS cert/key from a Secret (2.1 → 3.3). If the server still
    needs a writable site, set `HYPERSHELL_SITE` to a writable path (e.g. an emptyDir); verify.
  - The HyperShell docs' own Kubernetes example (`docs/security.rst:762-940`) uses
    `image: hypershell/hypershell:latest` (not published) and `args: ["hs", "server", "--bind", "0.0.0.0"]`
    (line 830), which with the image's entrypoint would run `hs server hs server ...`. Do not copy
    it; worth an upstream docs fix.

### 2.2 TimescaleDB image

- Official image `timescale/timescaledb`; Docker Hub tag API (2026-11-22) shows `latest-pg18`,
  **`2.32.1-pg18`**, **`2.32.1-pg17`** (and `-oss` variants), updated 2026-11-19. There is no
  plain `latest`; Timescale advises pinning a version.
- HyperShell needs TimescaleDB ≥ 2.22.0, full features ≥ 2.25.0; supports PG 16, 17, 18; the
  Community (non-`-oss`) image is what gives columnstore and policy
  (`docs/_include/database.rst:340-360`). Use the non-`-oss` tag.
- The image builds `FROM postgres:${PG_VERSION}-alpine` and adds `docker-entrypoint-initdb.d`
  scripts (timescale/timescaledb-docker `Dockerfile`), so it takes the official postgres
  variables: `POSTGRES_PASSWORD` (required), `POSTGRES_USER` (default `postgres`), `POSTGRES_DB`
  (default = user) (docker-library postgres docs). Its init scripts create the extension in the
  default database and preload the library; HyperShell's `hs initdb` also creates the extension
  if missing (`database.rst:215-220`).
- Through the Geddes cache (non-official image keeps its repo path, `registry.md:23`):
  `geddes-registry.rcac.purdue.edu/docker-hub-cache/timescale/timescaledb:2.32.1-pg17`.

### 2.3 Data directory and the PostgreSQL-major choice

- PostgreSQL ≤ 17 images: `PGDATA=/var/lib/postgresql/data`; mount the volume there.
- PostgreSQL 18 images changed `PGDATA` to `/var/lib/postgresql/18/docker` and the declared
  `VOLUME` to `/var/lib/postgresql`; mounting at `/var/lib/postgresql/data` fails on 18
  (docker-library postgres docs and upstream reports).
- **Recommendation:** use `2.32.1-pg17` so the Storage steps are word-for-word the database
  guide's (**Mount Point** `/var/lib/postgresql/data`, **Sub Path** `data`, `database.md:32-33`).
  Alternative: `2.32.1-pg18` with **Mount Point** `/var/lib/postgresql` and no Sub Path. Either
  way, **LIVE**: confirm data survives deleting the pod.
- Side finding (out of scope): `database.md:22` uses `postgis/postgis:latest`; if that tag has
  moved to PG 18 the site's own mount step may now fail. Flag for the Geddes guide owners.

---

## 3. HyperShell server in the pod

### 3.1 What the server container needs (2.9.0)

| Need | Setting | Source |
|---|---|---|
| Listen on the pod network | `HYPERSHELL_SERVER_BIND=0.0.0.0` (default `localhost`) | `docs/_include/server_help.rst:10-14`; `config_param_ref.rst` `[server] .bind` |
| Port | 50001 default (`-p`) | `server_help.rst:16-20` |
| Queue key | `HYPERSHELL_SERVER_AUTH` from a Secret; ≥16 chars from `[A-Za-z0-9._+/=-]`; placeholder refused; no key on a command line | `docs/security.rst:177-192` |
| Database | `HYPERSHELL_DATABASE_PROVIDER=timescale`, `HYPERSHELL_DATABASE_HOST=localhost`, `HYPERSHELL_DATABASE_PORT=5432`, `HYPERSHELL_DATABASE_DATABASE=hypershell`, `HYPERSHELL_DATABASE_USER=postgres`, `HYPERSHELL_DATABASE_PASSWORD` from the same Secret key as `POSTGRES_PASSWORD` | names derived by the rule in `docs/_include/config_intro.rst:103-107` from keys in `config_param_ref.rst` `[database]` (`.provider .host .port .database .user .password`); `user` and `password` must be given together |
| TLS (on by default) | `HYPERSHELL_SERVER_TLS_CERT=/tls/tls.crt`, `HYPERSHELL_SERVER_TLS_KEY=/tls/tls.key` from a Secret mounted as files | `docs/security.rst:316-341`; `tls_cli_options.rst` |
| Autoscaling with relay sites | argument `--autoscaling` (or `--autoscaling=dynamic`); implies forever; conflicts with FILE, `--restart`, `--no-db`, `--no-confirm` | `server_help.rst:165-183`; `src/hypershell/server.py` `check_autoscaling` sets forever mode |
| Initialize DB | argument `--initdb` (idempotent; with `timescale` makes `task` a hypertable) | `server_help.rst:126-135`; `database.rst:207-261` |
| Policy and spread | `HYPERSHELL_AUTOSCALE_POLICY`, `HYPERSHELL_AUTOSCALE_DISTRIBUTION` (`spread`/`fill`), `HYPERSHELL_AUTOSCALE_SITES` | `config_param_ref.rst` `[autoscale]` (`.policy`, `.distribution`, `.sites`) |

Same pod means one network namespace, so `localhost:5432` reaches the TimescaleDB container.

### 3.2 `hs initdb`

Run it with no shell at all: give the server container the arguments `--autoscaling --initdb`
(Rancher **Command** section, arguments only; entrypoint `hs server` stays). `--initdb` "create[s]
the tables if they don't already exist, upgrade[s] existing ones in place, and with the
`timescale` provider check[s] the server and give[s] the `task` table its hypertable shape"
(`server_help.rst:129-133`), and re-running it always arrives at the same state
(`database.rst:244-246`). Alternatives: `hs initdb` from login00 against the exposed port 5432, or
**Execute Shell** in the server container (`/opt/hypershell/bin/hs initdb`). **LIVE:** confirm
`--autoscaling` and `--initdb` combine, and whether the Rancher form has a separate arguments
field (the site shows only **Command**, `troubleshooting.md:44-46`).

Start order: the server may start before PostgreSQL accepts connections and exit; Kubernetes
restarts it. Say so in the wait-and-check paragraph ("one or two restarts of the server container
are expected"). **LIVE.**

### 3.3 TLS certificate

The auto-generated certificate (`security.rst:289-307`) cannot be written in the image (2.1) and
would change on every new pod, breaking relays that pin it. So: generate a self-signed cert once on
login00 with `openssl req -x509 ...` with the Service DNS name as SAN, store `tls.crt`/`tls.key` in
an Opaque Secret, mount it at `/tls`, and pin its fingerprint at each relay
(`relay.upstream.tls.fingerprint`, `config_param_ref.rst` `[relay] [upstream] [tls]`; pinning mode
`security.rst:360-364`). `relay.upstream.tls` documents `enabled`, `cert`, `cafile`, `fingerprint`
only (no `servername`), so fingerprint pinning is the simplest verified mode. **LIVE:** confirm the
fingerprint format HyperShell accepts (`SHA256:AB:CD:...`) against `openssl x509 -fingerprint -sha256`
output. Geddes2 also offers cert-manager Certificates via `certinext-acme-issuer`, with staff
approval (`migration/geddes2-tls-certificate.md:56-104`); too heavy for the MVP, a "going further" note at most.

### 3.4 Database reachability from login00

`hs submit`, `hs list`, `hs info`, `hs wait`, and `hs update` read and write the **database**, not
the server queue: `hs submit --queue` works only against a server running `--no-db`, and zones are
"recorded in the database, so `--zone` cannot be used with `--queue`"
(`docs/_include/submit_help.rst:40-52,137-139`). So the Load Balancer Service exposes **two ports:
50001 (queue, for relays) and 5432 (PostgreSQL, for `hs submit`/`hs list` on login00)**. That
matches the database guide, which already exposes 5432 on the private pool (`database.md:46-63`).
Login00 then sets `HYPERSHELL_DATABASE_*` with `HOST=<servicename>.<namespace>.geddes.rcac.purdue.edu`
and the password through `password_eval` or `password_env` (`config_intro.rst:82,137-140`).

---

## 4. `hs relay` and the multi-cluster decision

### 4.1 What the relay does in 2.9.0

- Upstream it is an ordinary client (one identity per zone); at the site it runs its own server
  and launches site clients; results go back upstream (`docs/_include/relay_desc.rst:1-12,40-55`).
  New in 2.9.0 (`docs/cli/relay.rst:6-7`).
- **Upstream key:** `relay.upstream.auth`, or `auth_env`/`auth_eval`, "never from the command
  line" (`relay_desc.rst:12-13`; `security.rst:563-571`). Env form `HYPERSHELL_RELAY_UPSTREAM_AUTH`
  (`security.rst:247-249`). Site clients get a per-run key in `HYPERSHELL_SERVER_AUTH`, never the
  upstream key (`relay_desc.rst:14-30`).
- **Connection:** `-H/--upstream-host`, `-p/--upstream-port` (default 50001); TLS on unless
  `--no-tls` (`docs/_include/relay_help.rst:4-18`).
- **How it launches clients:** `--launcher CMD` is a command prefix; each client runs as
  `CMD [ARGS...] hyper-shell client ...`; `{zone}` is substituted; the launcher must pass the
  environment through (`relay_help.rst:36-52`); launcher and args are `shlex`-split
  (`src/hypershell/relay/site.py`). Site clients dial back to the relay at its bind address or host
  name, or `--advertise` (`relay_help.rst:42-44,54-72`); relay-local port default 50002
  (`relay_help.rst:74-78`).
- **The launcher must block for the client's lifetime.** The relay counts running clients as its
  child processes still alive (`launched_now`: `proc.poll() is None`, `src/hypershell/relay/site.py`)
  and relaunches one that exits. So `srun` (blocking; from a login node it makes its own
  allocation) works; `sbatch` returns at once and would look like an exited client, so it would be
  relaunched in a loop. **Use `srun`, never `sbatch`, as the relay launcher.** `srun` exports the
  environment by default, which is how the key reaches the client (`security.rst:203-207`).
- **Autoscaling:** with `hs server --autoscaling` upstream, the server plans each zone's clients
  across all relay sites (within each relay's advertised `min`/`init`/`max`) and publishes the
  plan; each relay launches with its own launcher (`docs/cli/relay.rst:40-83`;
  `server_help.rst:165-179`). `autoscale.distribution = spread | fill` and `autoscale.sites` order
  sites (`config_param_ref.rst` `[autoscale]`). Clients leave by `relay.timeout` idle seconds; the
  relay never kills a client to scale down (`relay.rst:80-83`).
- Restart-safe: a new relay at the same site supersedes the old, which hands back unstarted tasks
  and exits (`relay.rst:85-101`); lost upstream connection is not a failure (`relay_desc.rst:77-91`).
- Per-zone launchers: `[relay.zone.NAME]` tables with `launcher`, `launcher_args`, `size`, `min`,
  `max`, `init` (`config_param_ref.rst` `[relay] .zone`; `relay.rst:44-55`).

### 4.2 Network consequence

Only the relay host talks to Geddes. Compute nodes talk only to the relay on login00 (port 50002).
So the capstone needs login00 → Geddes LB (50001, 5432) and compute node → login00:50002.
**LIVE** both. The relay advertises its host name by default; check that Gautschi compute nodes
resolve and reach it, else set `relay.advertise`.

### 4.3 Second cluster: options

**(a) A second relay on the second cluster's own login node** (both relays upstream to the same
Geddes server, distinct `relay.site`, zones routing tasks). Evidence for: designed for exactly
this (sites, per-zone bounds, distribution across sites, `relay.rst:40-83`); each site's clients
stay on their own cluster's network and module tree; no cross-cluster ssh or scheduler access.
Login hostnames: the site documents per-node names `loginNN.<cluster>.rcac.purdue.edu` for
Gautschi and Negishi (`docs/blog/posts/vscode.md:74-76`, `docs/lifesciences/guides/vscode.md:192`,
`docs/workshops/hpc_exchange/crash-course.md:45`) and a `login00.negishi` prompt
(`docs/blog/posts/slurm_fairshare.md:111`); nothing for Gilbreth beyond `gilbreth.rcac.purdue.edu`.
The site's own advice for persistent login-node processes is to pin one specific login node: "pick
the same one and stick to it so you don't orphan your code server" (`docs/blog/posts/vscode.md:88`).
Against: the second relay runs on the second cluster's login node, not on login00 (see the
R10 wording note below).

**(b) ssh from Gautschi's login00 into the other cluster as the launcher.** Evidence against:
- Homes are separate on every cluster: "exclusive to Gautschi cluster front-end hosts and compute
  nodes ... no automatic copying or synchronization" (`docs/userguides/gautschi/faqs.md:31-32`;
  same for Negishi `negishi/faqs.md:42-44`, Gilbreth `gilbreth/faqs.md:59-60`, Scholar
  `scholar/faqs.md:25-26`). Keys would have to be installed on the target by hand; the site
  documents SSH keys only from a local machine (`main.py` `ssh_keys_snippet`) and clusters accept
  "either Purdue's MFA two-factor authentication or SSH keys" (`main.py` `accounts_md_snippet`).
- A plain `ssh` launcher does not carry the environment, so the site client never receives
  `HYPERSHELL_SERVER_AUTH`; only `hs cluster --ssh` has the stdin key hand-off
  (`security.rst:203-241`). The relay has no ssh mode (`relay_help.rst`).
- The remote clients would have to dial back across clusters to login00:50002, and would carry
  Gautschi's `PATH`/module environment.
Not viable without upstream changes. Reject.

**(c) Slurm multi-cluster (`srun -M <cluster>` from login00).** Slurm's `srun` supports
`-M/--clusters` when slurmdbd is shared (slurm.schedmd.com/srun.html). No RCAC page mentions
`-M`, `--clusters`, or federation (grep of `docs/`). Even if it worked, clients on the other
cluster would dial back across clusters to login00 and inherit Gautschi's environment. **LIVE**
(read-only: `sacctmgr show clusters` or `sinfo -M all` on login00). Mention at most as "if your
site federates Slurm".

### 4.4 Recommendation

- **Mechanism: (a).** Two relays, one per cluster, one Geddes server in `--autoscaling` mode. The
  same relay script and config shape serve both clusters; only `site`, `launcher_args` and zones
  differ.
- **Second cluster: Gilbreth**, as the GPU site. Zones then mean something: zone `cpu` served by
  the Gautschi relay (`-p cpu`, `docs/userguides/gautschi/run_jobs/queues.md:52-54`), zone `gpu`
  served by the Gilbreth relay (e.g. `-p a100-80gb --gres=gpu:1`,
  `docs/userguides/gilbreth/run_jobs/queues.md:26,93-95`). Task groups order the phases (CPU
  preprocessing → GPU inference → CPU reduction), so "zones and task groups working together"
  (R10) falls out naturally and links to the GPU multiplexing page (R11). Negishi is the fallback
  if the plan prefers a homogeneous "two sites serve one zone, `fill` prefers the cheaper one"
  story (Negishi `-p cpu`, `negishi/run_jobs/queues.md:37-39`); its GPU partition is 5 AMD MI210
  nodes (`:70-72`), so it is a poor GPU site.
- **R10 wording (plan gate):** R10 says the script "runs on login00 and schedules clients for one
  or more clusters". Under (a) the scheduling across clusters is done by the Geddes server's
  `--autoscaling` plan, and the login00 script runs the Gautschi relay; the multi-cluster step
  starts the same script on Gilbreth's login node. Ask the human whether that meets R10, or
  whether the second relay should be started from login00 over ssh (possible: install a key once,
  keep the upstream key in a 0600 file on the second cluster read by `auth_eval`; more moving parts).
- **R12 note:** the relay's upstream key is `relay.upstream.auth` (`auth_eval`/`auth_env`, or
  `HYPERSHELL_RELAY_UPSTREAM_AUTH`), a separate setting from `server.auth`. It honours R12's intent
  (never on a command line). PLAN should state this so review does not read R12 literally.
- **LIVE checks for the foreman:** (1) login00 resolves and reaches the LB name on 50001 and 5432;
  (2) Gautschi compute nodes reach login00:50002 (a short job with a TCP probe); (3) Gilbreth's
  pinned login host name resolves (`login00.gilbreth.rcac.purdue.edu`? unknown) and reaches the
  LB; (4) `srun` as relay launcher from a login node starts a client that registers;
  (5) `module load hypershell` gives 2.9.0 on both clusters, or the page's install fallback works.

---

## 5. Login-node policy

- RCAC's "Acceptable Front-End System Use" (<https://www.rcac.purdue.edu/policies/frontenduse>,
  read 2026-11-22; linked from `docs/userguides/gautschi/gateway/cluster_tools.md:18`): front ends
  are "available only for use in job preparation and submission, file editing and transfers";
  "Use of memory and CPU on these systems should be minimal"; "Any processes using significant
  processor time or memory on a front-end or login node ... will be terminated without warning
  automatically"; "Acceptable applications have to be explicitly whitelisted." It says nothing about
  long-running low-CPU daemons, and names no designated node.
- Site snippets: "No heavy compute on login nodes" (`docs/snippets/agentic-ai/gautschi/agents.d/policies.md:27`);
  Anvil: "do not run jobs on the login nodes" (`docs/userguides/anvil/policies.md:24`).
- **login00 is not described as special anywhere on the site** (grep: only a generic
  `login00.cluster.rcac.purdue.edu` example, `docs/workshops/hpc_exchange/week2/what-is-a-cluster.md:40-46`).
- A relay is light (a scheduler loop and one blocking `srun` per client), so it fits "job
  submission" in spirit, but it is long-running. **Flag for the foreman / RCAC staff:** confirm a
  persistent relay on login00 is acceptable (and whether it should be whitelisted), and how users
  should keep it alive (tmux/screen, or re-run after a login-node reboot; the relay is restart-safe,
  4.1). The page should say: one relay per user per cluster, low `upstream.bundlesize`, no tasks on
  the login node (`relay.launcher` must not be empty, since an empty launcher runs clients on the
  relay host, `relay_help.rst:39`).

---

## 6. What cannot be machine-validated, and a manual check procedure

Not machine-checkable here: every Rancher UI step and label, Secret-to-env and Secret-volume UI,
the add-container control, the arguments field, LB IP assignment and DNS, network reachability,
pod restart persistence, and whether login00 policy tolerates the relay.

Proposed procedure (foreman with a Geddes namespace, attended):
1. Follow the drafted page literally in Rancher, screenshotting each form tab used; record every
   label that differs from the draft.
2. Create Opaque Secrets `hypershell-db` (`password`), `hypershell-auth` (`auth`), `hypershell-tls`
   (`tls.crt`, `tls.key`); confirm both env-from-secret and secret-as-volume in the form.
3. Deploy the pod (TimescaleDB + HyperShell); check **View Logs** of both containers: TimescaleDB
   ready; server logs TLS on, database initialized as timescale, autoscaling on, listening 0.0.0.0:50001.
4. **Execute Shell** in the server container: `/opt/hypershell/bin/hs config get database.provider`
   and `.../hs list --count` (or equivalent) succeed.
5. Create the LB Service (ports 50001, 5432, private-pool annotation); `host <svc>.<ns>.geddes.rcac.purdue.edu`
   from login00; TCP probe both ports from login00.
6. On login00: `hs submit` a few tasks in two zones and two groups; start the relay script;
   confirm clients launch via `srun`, tasks finish, `hs list`/`hs info` show results and sites.
7. Delete the pod (not the PVC); after it returns, `hs list` still shows the earlier tasks.
8. Start the second relay on Gilbreth; confirm `gpu`-zone tasks run only there.
9. Record date, cluster, image tags, and results in the cycle's validation log.

---

## 7. Recommendations for PLAN

### 7.1 Capstone page outline (one page, or split deploy/relay if long)

H1 "Tier 4: A persistent service on Geddes"
- Who this is for / when to move here (R6), minimum version 2.9.0 (relay, zones, groups, `timescale`
  provider, published image) and an admonition that it builds on the [Geddes database guide](../../userguides/geddes/examples/database.md) (path to confirm).
- H2 Architecture: one pod (TimescaleDB + `hs server --autoscaling`), one Load Balancer Service
  (50001 queue, 5432 database), one relay per cluster on a pinned login node; only login00 talks to
  Geddes. A small diagram with real alt text (R14).
- H2 Before you begin: Geddes access (`access.md`), a namespace, a strong key (`openssl rand -base64 48`),
  a self-signed TLS cert/key and its fingerprint (generated on login00), images and the GHCR note.
- H2 Store credentials as Secrets (Opaque; site click path `storage.md:143-152`): DB password,
  queue key, TLS files. States R10 "how credentials are stored".
- H2 Deploy the pod (Rancher steps in the `database.md` style)
  - H3 Database container: image via docker-hub-cache, `POSTGRES_PASSWORD` and
    `HYPERSHELL_DATABASE_PASSWORD` from the same Secret key, `POSTGRES_DB=hypershell`, PVC on
    `geddes-performance-singlenode` (or standard), mount per 2.3, resources, pod label.
  - H3 HyperShell server container (second container): image, arguments `--autoscaling --initdb`,
    env table (3.1), TLS secret volume at `/tls`, port 50001.
  - H3 Scaling and Upgrade Policy: Recreate (RWO volume). **LIVE** label.
  - Wait-and-check paragraph. States R10 "how data persists".
- H2 Expose the server (Load Balancer, private pool, two ports, DNS name). States R10 "network
  exposure"; note public pool is not needed and not advised.
- H2 Configure login00 (`login00.gautschi.rcac.purdue.edu`): one config file for submit/list
  (database settings, password via `password_eval`) and relay (`[relay]`, `[relay.upstream]` with
  `auth_eval` and `[relay.upstream.tls] fingerprint`, zone tables with `srun` launchers).
- H2 Run the relay (the minimum viable autoscaling script): start/restart-safe wrapper, how to
  keep it alive, how to drain (SIGUSR1) or stop it, login-node etiquette (section 5).
- H2 Submit work with zones and task groups (scenario: e.g. astronomy imaging, CPU calibrate →
  GPU detect → CPU catalog), `hs submit --zone ... -g ...`, `hs list`/`hs info`/`hs wait`.
- H2 Add a second cluster (Gilbreth GPU site): same script on Gilbreth's login node, zone `gpu`,
  `autoscale.distribution` note; what changes, what stays.
- H2 Operate and maintain: back up with `kubectl exec ... pg_dump` (`storage.md:74-84`), upgrade
  (re-run with `--initdb`), rotate the key, troubleshooting (link `troubleshooting.md`).
- One-line note: an MCP-server container is out of scope (non-goal).

### 7.2 At most one short YAML reference

Optional, collapsed (`??? note "Equivalent manifest"`): only the pod's two `containers:` entries
(image, args, `env` with `secretKeyRef`, volume mounts), about 30 lines, for readers who prefer
kubectl, mirroring the site's kubectl-alternative pattern (`storage.md:166-188`). No Service,
PVC, or Secret YAML. If the plan wants zero YAML, drop it; the Rancher steps are the contract.

### 7.3 Open items for the plan gate

1. Geddes vs Geddes2 target (1.7).
2. Image source: direct GHCR pull vs Harbor copy; `2.9.0` tag exists only after release (2.1).
3. R10 wording vs two relays (4.4); Gilbreth vs Negishi.
4. Persistent relay on login00 vs front-end policy (5).
