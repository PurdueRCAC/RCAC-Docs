````markdown
---
tags:
  - Box Research Lab Folder
  - Rclone
authors:
  - christ35
  - tratkus
search:
  boost: 2
draft: false
---

# Downloading Box Directories with Rclone

[Rclone](https://rclone.org/) is a command-line tool useful for transferring files between
cloud storage services and a local filesystem. You can use it to copy a directory
from Purdue Box directly to storage on an RCAC cluster without first downloading the
directory to your personal computer.

This page uses a remote named `purdue-box`. If you choose a different name while
configuring Rclone, substitute that name in the commands below.

!!! warning "Check data-handling requirements first"
    Before using Rclone with sensitive or restricted data, confirm that Rclone and
    the destination RCAC filesystem are approved for the data. See the
    [Box Research Lab Folder FAQ](faqs.md#can-i-integrate-3rd-party-apps-with-my-box-folder)
    and contact [RCAC](mailto:rcac-help@purdue.edu) if you are unsure.

## Start an RCAC remote desktop session

Perform the configuration and transfer from a graphical desktop session on the RCAC
cluster where you want to store the downloaded data. Use either ThinLinc or the
Desktop application in the cluster's Open OnDemand Gateway. Any community cluster
can be used if the data will be stored in Depot.

| Cluster | ThinLinc instructions | Open OnDemand desktop instructions |
| --- | --- | --- |
| Bell | [ThinLinc](../bell/accounts.md#thinlinc) | [Compute Node Desktop](../bell/gateway/interactive/desktop.md) |
| Gautschi | [ThinLinc](../gautschi/accounts.md#thinlinc) | [Compute Node Desktop](../gautschi/gateway/interactive_apps.md#compute-node-desktop) |
| Gilbreth | [ThinLinc](../gilbreth/accounts.md#thinlinc) | [Compute Node Desktop](../gilbreth/gateway/interactive/desktop.md) |
| Negishi | [ThinLinc](../negishi/accounts.md#thinlinc) | [Compute Node Desktop](../negishi/gateway/interactive/desktop.md) |

Open both a terminal and a web browser inside the remote desktop. The browser must run
in the same RCAC desktop environment as Rclone so that Box can return the OAuth
authorization to Rclone through `localhost`.

## Load Rclone

In the remote desktop's terminal, check whether Rclone is available on the cluster and
then load it:

```bash
module spider rclone
module load rclone
rclone version
```

The [Rclone software catalog entry](../../software/apps_md/rclone.md) lists the
clusters on which the Rclone module is currently available.

## Configure a Purdue Box remote

Rclone uses OAuth to connect to Box. In the remote desktop's terminal, create the remote
with all required configuration choices specified on the command line:

```bash
rclone config create purdue-box box box_sub_type=user config_is_local=true
```

Rclone opens the browser in the RCAC remote desktop. Sign in to Purdue Box, complete
multifactor authentication if prompted, and authorize Rclone. After Box reports that
authorization succeeded, return to the terminal. Rclone saves the `purdue-box` remote
without asking the full interactive configuration questionnaire.

If the browser does not open automatically, copy the authorization URL displayed in the
terminal and open it in the browser inside the same RCAC remote desktop session.

!!! danger "Protect the configuration file"
    The Rclone configuration contains credentials that grant access to your Box
    account. Do not share it, attach it to a support ticket, commit it to a repository,
    or store it in a group-readable project directory.

    Do not use copies of the same Box configuration simultaneously on multiple
    machines. Box refresh tokens are single-use, and reusing a copied configuration
    can invalidate the remote.

## Find the directory in Box

List the top-level directories visible to your Purdue Box account:

```bash
rclone lsd purdue-box:
```

List the contents of a directory by adding its path after the colon:

```bash
rclone lsf "purdue-box:My Lab Folder"
rclone lsf "purdue-box:My Lab Folder/Project Data"
```

Quote paths that contain spaces. If a shared folder does not appear, first confirm at
[purdue.box.com](https://purdue.box.com/) that your account can open it.

## Download a directory

Choose a destination with enough space and with protections appropriate for the data.
For example, preview a download to your cluster scratch directory:

```bash
rclone copy \
    "purdue-box:My Lab Folder/Project Data" \
    "${CLUSTER_SCRATCH}/Project Data" \
    --create-empty-src-dirs \
    --dry-run \
    --progress
```

Review the preview, then remove `--dry-run` to start the transfer:

```bash
rclone copy \
    "purdue-box:My Lab Folder/Project Data" \
    "${CLUSTER_SCRATCH}/Project Data" \
    --create-empty-src-dirs \
    --progress
```

Rclone copies the *contents* of the source directory into the destination directory.
It creates the destination if necessary, skips files that already match, and does not
delete unrelated files already at the destination. If a transfer is interrupted, run
the same command again; Rclone checks the files already present and continues copying
what is missing or different.

!!! danger "Use `sync` only when deletion is intended"
    `rclone sync` makes the destination match the source and can delete files from the
    destination. Use `rclone copy` for downloads unless you specifically need mirror
    behavior. Always use `--dry-run` before a `sync` operation.

## Troubleshooting

### The Box login has expired

Reconnect the remote and repeat the browser authorization process:

```bash
rclone config reconnect purdue-box:
```

A Box token can expire, and reusing the same configuration on multiple machines can
also produce an `Invalid refresh token` error.

### The transfer is slow or temporarily fails

Box rate limits or disruptions to Purdue's research network may interrupt long
transfers. Rclone normally retries transient failures automatically. If the command
exits before completion, wait a few minutes and run the same e.g. `rclone copy`
command again.

### Get additional help

- [Purdue IT: What is Rclone and how does it work with Purdue Box?](https://service.purdue.edu/TDClient/32/Purdue/KB/Article/240/What-is-Rclone-and-how-does-it-work-with-Purdue-Box)
- [Rclone Box documentation](https://rclone.org/box/)
- [Rclone command documentation](https://rclone.org/commands/)
- [Contact RCAC](mailto:rcac-help@purdue.edu)

[Back to Box Research Lab Folder](index.md)
````

