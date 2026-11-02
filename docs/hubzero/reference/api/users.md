---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/users.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_users/api/controllers/
---

# Users API

Endpoints under `/api/users`, from the `com_users` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/api/v1.0/users/current_user/isAuthenticated`](#get-api-v1-0-users-current-user-isauthenticated) | Indicates whether current user is authenticated |

## GET /api/v1.0/users/current_user/isAuthenticated { #get-api-v1-0-users-current-user-isauthenticated }

Indicates whether current user is authenticated

API version 1.0, task `isAuthenticated` in [`currentuserv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_users/api/controllers/currentuserv1_0.php#L15).
