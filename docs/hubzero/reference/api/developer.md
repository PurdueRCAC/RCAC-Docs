---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/developer.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_developer/api/controllers/
---

# Developer API

Endpoints under `/api/developer`, from the `com_developer` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | [`/developer/oauth/token`](#post-developer-oauth-token) | Handle a request for an OAuth2.0 Access Token and send the response to the client |

## POST /developer/oauth/token { #post-developer-oauth-token }

Handle a request for an OAuth2.0 Access Token and send the response to the client

API version 1.0, task `token` in [`oauthv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_developer/api/controllers/oauthv1_0.php#L19).
