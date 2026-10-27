---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/blog.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('blog.*') call sites and core/plugins/blog/
---

# Blog events

Events in the `blog` group. A plugin in `core/plugins/blog/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `blog.onBlogView` { #blog-onblogview }

Fired from:

- [`core/components/com_blog/site/controllers/entries.php:172`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_blog/site/controllers/entries.php#L172) with `[$row]`
- [`core/plugins/groups/blog/blog.php:618`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/blog/blog.php#L618) with `[$row]`
- [`core/plugins/members/blog/blog.php:470`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/blog/blog.php#L470) with `[$row]`

Listeners:

- `plg_blog_opengraph` — [`onBlogView($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/blog/opengraph/opengraph.php)
- `plg_blog_twitter` — [`onBlogView($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/blog/twitter/twitter.php)
