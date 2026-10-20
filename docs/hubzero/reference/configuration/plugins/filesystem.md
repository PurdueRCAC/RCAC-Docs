---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/filesystem.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/filesystem/*/*.xml
---

# Filesystem plugins

Parameters of every plugin in the `filesystem` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Filesystem - AWS S3 (`plg_filesystem_awss3`) { #filesystem-aws-s3-plg-filesystem-awss3 }

AWS S3 connectivity plugin

### User credentials

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `app_id` | Access Key ID | text | — | Access Key ID |
| `app_secret` | Secret Access Key | text | — | Secret Access Key |
| `region` | Endpoint Region (see http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region) | text | — | Region code of the S3 bucket |
| `bucket` | Bucket Name | text | — | Name of bucket to connect the project to |
| `directory` | Directory to connect | text | — | Directory to lock the file connector to |

## Filesystem - Dropbox (`plg_filesystem_dropbox`) { #filesystem-dropbox-plg-filesystem-dropbox }

Dropbox connectivity plugin

### Credentials

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `app_key` | App key | text | — | The Dropbox API app key to use for connections to Dropbox |
| `app_secret` | App secret | text | — | The Dropbox API app secret to use for connections to Dropbox |

## Filesystem - Github (`plg_filesystem_github`) { #filesystem-github-plg-filesystem-github }

GitHub connectivity plugin

### Credentials { #credentials-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `app_key` | Client ID | text | — | The GitHub API Client ID to use for connections to GitHub |
| `app_secret` | Client Secret | text | — | The GitHub API Client Secret to use for connections to GitHub |

### User credentials { #user-credentials-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `repository` | Repository | text | — | Repository to connect to |

## Filesystem - Google Drive (`plg_filesystem_googledrive`) { #filesystem-google-drive-plg-filesystem-googledrive }

Google Drive connectivity plugin

### Credentials { #credentials-3 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `app_id` | Client ID | text | — | The Google API OAuth client ID to use for connections to Google Drive |
| `app_secret` | Client Secret | text | — | The Google API OAuth client secret to use for connections to Google Drive |

## Filesystem - Local (`plg_filesystem_local`) { #filesystem-local-plg-filesystem-local }

Local filesystem connectivity plugin

This plugin has no parameters.
