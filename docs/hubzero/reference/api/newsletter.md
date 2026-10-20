---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/newsletter.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_newsletter/api/controllers/
---

# Newsletter API

Endpoints under `/api/newsletter`, from the `com_newsletter` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/newsletters/archive`](#get-newsletters-archive) | Return data for past newsletters |
| `GET` | [`/newsletters/current`](#get-newsletters-current) | Return data for the current newsletter |
| `GET` | [`/newsletters/list`](#get-newsletters-list) | Return data for newsletters |

## GET /newsletters/archive { #get-newsletters-archive }

Return data for past newsletters

API version 1.0, task `archive` in [`newslettersv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/api/controllers/newslettersv1_0.php#L88).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 5 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |

## GET /newsletters/current { #get-newsletters-current }

Return data for the current newsletter

API version 1.0, task `current` in [`newslettersv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/api/controllers/newslettersv1_0.php#L25).

## GET /newsletters/list { #get-newsletters-list }

Return data for newsletters

API version 1.0, task `list` in [`newslettersv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/api/controllers/newslettersv1_0.php#L49).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 5 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |
