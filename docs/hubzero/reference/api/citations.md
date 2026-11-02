---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/citations.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_citations/api/controllers/
---

# Citations API

Endpoints under `/api/citations`, from the `com_citations` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/citations/list` (v1.0)](#get-citations-list-v1-0) | Display a list of citations |
| `GET` | [`/citations/list` (v1.1)](#get-citations-list-v1-1) | Display a list of citations |

## GET /citations/list (v1.0) { #get-citations-list-v1-0 }

Display a list of citations

API version 1.0, task `list` in [`entriesv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_citations/api/controllers/entriesv1_0.php#L23).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 25 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |
| `search` | string | no | — | A word or phrase to search for. |
| `sort` | string | no | created | Field to sort results by. |
| `sort_Dir` | string | no | desc | Direction to sort results by. |

## GET /citations/list (v1.1) { #get-citations-list-v1-1 }

Display a list of citations

API version 1.1, task `list` in [`entriesv1_1.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_citations/api/controllers/entriesv1_1.php#L24).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 25 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |
| `search` | string | no | — | A word or phrase to search for. |
| `sort` | string | no | created | Field to sort results by. |
| `sort_Dir` | string | no | desc | Direction to sort results by. |
