---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/system.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_system/api/controllers/
---

# System API

Endpoints under `/api/system`, from the `com_system` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/system/getSessionLifetime`](#get-system-getsessionlifetime) | Grabs the session lifetime, in minutes |
| `GET` | [`/system/info`](#get-system-info) | Display system information |
| `POST` | [`/system/media/tracking`](#post-system-media-tracking) | Records media tracking info |

## GET /system/getSessionLifetime { #get-system-getsessionlifetime }

Grabs the session lifetime, in minutes

API version 1.0, task `getSessionLifetime` in [`systemv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_system/api/controllers/systemv1_0.php#L170).

## GET /system/info { #get-system-info }

Display system information

API version 1.0, task `info` in [`systemv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_system/api/controllers/systemv1_0.php#L26).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `values` | string | no | all | Amount of data to return |

## POST /system/media/tracking { #post-system-media-tracking }

Records media tracking info

API version 1.0, task `tracking` in [`mediav1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_system/api/controllers/mediav1_0.php#L26).
