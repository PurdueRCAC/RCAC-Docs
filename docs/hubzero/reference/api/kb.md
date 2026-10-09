---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/kb.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_kb/api/controllers/
---

# Kb API

Endpoints under `/api/kb`, from the `com_kb` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/kb/list`](#get-kb-list) | Get a list of Knowledge Base Articles |

## GET /kb/list { #get-kb-list }

Get a list of Knowledge Base Articles

API version 1.0, task `list` in [`entriesv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_kb/api/controllers/entriesv1_0.php#L24).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 25 | Number of result to return. |
| `limitstart` | integer | no | 0 | Number of where to start returning results. |
