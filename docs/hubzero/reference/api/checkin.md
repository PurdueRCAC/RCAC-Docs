---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/checkin.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_checkin/api/controllers/
---

# Checkin API

Endpoints under `/api/checkin`, from the `com_checkin` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `DELETE` | [`/checkin/checkin`](#delete-checkin-checkin) | Checkin entries on a table |
| `GET` | [`/checkin/list`](#get-checkin-list) | Display a list of entries |

## DELETE /checkin/checkin { #delete-checkin-checkin }

Checkin entries on a table

API version 1.0, task `checkin` in [`checkinv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_checkin/api/controllers/checkinv1_0.php#L74).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `table` | string\|array | yes | — | Table(s) to checkin |

## GET /checkin/list { #get-checkin-list }

Display a list of entries

API version 1.0, task `list` in [`checkinv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_checkin/api/controllers/checkinv1_0.php#L24).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 25 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |
| `sort` | string | no | created | Field to sort results by. |
| `sort_Dir` | string | no | desc | Direction to sort results by. |
