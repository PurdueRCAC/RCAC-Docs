---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/blog.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/blog/*/*.xml
---

# Blog plugins

Parameters of every plugin in the `blog` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Blog - (metadata) Open Graph (`plg_blog_opengraph`) { #blog-metadata-open-graph-plg-blog-opengraph }

Add metadata for Open Graph to the document

This plugin has no parameters.

## Blog - (metadata) Twitter (`plg_blog_twitter`) { #blog-metadata-twitter-plg-blog-twitter }

Add metadata for Twitter to the document

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `twitter_username` | Twitter Username | text | — | Provide the Twitter username that content should be associated with. |
