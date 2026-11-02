---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/events.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_events/api/controllers/
---

# Events API

Endpoints under `/api/events`, from the `com_events` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/calendar/list`](#get-calendar-list) | List active events |
| `GET` | [`/events/{id}`](#get-events-id) | Get user profile info |

## GET /calendar/list { #get-calendar-list }

List active events

API version 1.0, task `list` in [`eventsv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_events/api/controllers/eventsv1_0.php#L19).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 25 | Number of result to return. |
| `start` | integer | no | 0 | Number of where to start returning results. |

## GET /events/{id} { #get-events-id }

Get user profile info

API version 1.0, task `read` in [`eventsv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_events/api/controllers/eventsv1_0.php#L66).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | integer | yes | — | Event identifier |
