---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/api/news.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_news/api/controllers/
---

# News API

Endpoints under `/api/news`, from the `com_news` API controllers. Authenticate with an OAuth bearer token or a session cookie; see the developers book for the API basics.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | [`/news/list`](#get-news-list) | Displays a list of articles |

## GET /news/list { #get-news-list }

Displays a list of articles

API version 1.0, task `list` in [`articlesv1_0.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_news/api/controllers/articlesv1_0.php#L23).

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `limit` | integer | no | 25 | Number of result to return. |
| `section` | string | no | news | A section to filter on. |
| `category` | string | no | latest | A category to filter on. |
