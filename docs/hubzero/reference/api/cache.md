---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/cache.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_cache/api/controllers/
---

# Cache API

Endpoints under `/api/cache`, from the `com_cache` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `DELETE` | [`/cache/clean`](#delete-cache-clean) | Clean one or more cache groups |
| `GET` | [`/cache/list`](#get-cache-list) | Display a list of entries |
| `DELETE` | [`/cache/purge`](#delete-cache-purge) | Purge expired data |

## DELETE /cache/clean { #delete-cache-clean }

Clean one or more cache groups

API version 1.0, task `clean` in [`cachev1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cache/api/controllers/cachev1_0.php#L81).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `group` | string\|array | yes | — | Cache groups to clean |

## GET /cache/list { #get-cache-list }

Display a list of entries

API version 1.0, task `list` in [`cachev1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cache/api/controllers/cachev1_0.php#L24).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `clientId` | integer | yes | 0 | Client to manage cache data for |
| `limit` | integer | no | 25 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |
| `sort` | string | no | created | Field to sort results by. |
| `sort_Dir` | string | no | desc | Direction to sort results by. |

## DELETE /cache/purge { #delete-cache-purge }

Purge expired data

API version 1.0, task `purge` in [`cachev1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cache/api/controllers/cachev1_0.php#L117).
