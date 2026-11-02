---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/search.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('search.*') call sites and core/plugins/search/
---

# Search events

Events in the `search` group. A plugin in `core/plugins/search/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `search.onAddIndex` { #search-onaddindex }

Fired from:

- [`core/plugins/groups/search/search.php:42`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/search/search.php#L42) with `[$table, $ormGroup]`
- [`core/plugins/system/content/content.php:26`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/content/content.php#L26) with `[$table, $model]`

Listeners:

- `plg_search_solr` — [`onAddIndex($table, $model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/solr/solr.php)

## `search.onAddPermissionSet` { #search-onaddpermissionset }

Fired from:

- [`core/libraries/Hubzero/Search/Adapters/SolrQueryAdapter.php:436`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Search/Adapters/SolrQueryAdapter.php#L436)

No plugin in the source tree listens for this event.

## `search.onBeforeSearchRenderMembers` { #search-onbeforesearchrendermembers }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_search_members` — [`onBeforeSearchRenderMembers($res)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/members/members.php)

## `search.onExtensionAfterDelete` { #search-onextensionafterdelete }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_search_remote` — [`onExtensionAfterDelete($extension, Components\Plugins\Models\Plugin $model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/remote/remote.php)

## `search.onFormatResult` { #search-onformatresult }

Fired from:

- [`core/components/com_search/site/controllers/solr.php:356`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_search/site/controllers/solr.php#L356) with `[$result['hubtype'], &$result, $terms, $highlightOptions]`

No plugin in the source tree listens for this event.

## `search.onGetTypes` { #search-ongettypes }

Fired from:

- [`core/components/com_search/api/controllers/searchv1_0.php:268`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_search/api/controllers/searchv1_0.php#L268)

Listeners:

- `plg_search_blogs` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/blogs/blogs.php)
- `plg_search_citations` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/citations/citations.php)
- `plg_search_collections` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/collections/collections.php)
- `plg_search_content` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/content/content.php)
- `plg_search_courses` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/courses/courses.php)
- `plg_search_events` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/events/events.php)
- `plg_search_forum` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/forum/forum.php)
- `plg_search_groups` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/groups/groups.php)
- `plg_search_kb` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/kb/kb.php)
- `plg_search_members` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/members/members.php)
- `plg_search_projects` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/projects/projects.php)
- `plg_search_publications` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/publications/publications.php)
- `plg_search_questions` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/questions/questions.php)
- `plg_search_resources` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/resources/resources.php)
- `plg_search_tickets` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/tickets/tickets.php)
- `plg_search_wiki` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/wiki/wiki.php)
- `plg_search_wishlists` — [`onGetTypes($type = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/wishlists/wishlists.php)

## `search.onIndex` { #search-onindex }

Fired from:

- [`core/plugins/cron/search/search.php:171`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/search/search.php#L171) with `[$item->type, $item->type_id, true]`

Listeners:

- `plg_search_blogs` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/blogs/blogs.php)
- `plg_search_citations` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/citations/citations.php)
- `plg_search_collections` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/collections/collections.php)
- `plg_search_content` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/content/content.php)
- `plg_search_courses` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/courses/courses.php)
- `plg_search_events` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/events/events.php)
- `plg_search_forum` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/forum/forum.php)
- `plg_search_groups` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/groups/groups.php)
- `plg_search_kb` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/kb/kb.php)
- `plg_search_members` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/members/members.php)
- `plg_search_projects` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/projects/projects.php)
- `plg_search_publications` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/publications/publications.php)
- `plg_search_questions` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/questions/questions.php)
- `plg_search_resources` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/resources/resources.php)
- `plg_search_tickets` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/tickets/tickets.php)
- `plg_search_wiki` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/wiki/wiki.php)
- `plg_search_wishlists` — [`onIndex($type, $id, $run = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/wishlists/wishlists.php)

## `search.onRemoveIndex` { #search-onremoveindex }

Fired from:

- [`core/plugins/system/content/content.php:39`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/content/content.php#L39) with `[$table, $model]`

Listeners:

- `plg_search_solr` — [`onRemoveIndex($table, $model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/search/solr/solr.php)
