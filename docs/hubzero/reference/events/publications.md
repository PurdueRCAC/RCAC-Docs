---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/publications.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('publications.*') call sites and core/plugins/publications/
---

# Publications events

Events in the `publications` group. A plugin in `core/plugins/publications/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `publications.onAfterSave` { #publications-onaftersave }

Fired from:

- [`core/plugins/projects/publications/publications.php:856`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php#L856) with `$pub`

No plugin in the source tree listens for this event.

## `publications.onBeforeSave` { #publications-onbeforesave }

Fired from:

- [`core/plugins/projects/publications/publications.php:791`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php#L791) with `$pub`

No plugin in the source tree listens for this event.

## `publications.onPublication` { #publications-onpublication }

Fired from:

- [`core/components/com_publications/site/controllers/publications.php:655`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/site/controllers/publications.php#L655) with `[ $this->model, $this->_option, array($tab), 'all', $this->model->versionAlias, $extended]`

Listeners:

- `plg_publications_citations` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/citations/citations.php)
- `plg_publications_dublincore` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/dublincore/dublincore.php)
- `plg_publications_forks` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/forks/forks.php)
- `plg_publications_googlescholar` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/googlescholar/googlescholar.php)
- `plg_publications_jsonld` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/jsonld/jsonld.php)
- `plg_publications_opengraph` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/opengraph/opengraph.php)
- `plg_publications_questions` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/questions/questions.php)
- `plg_publications_reviews` — [`onPublication($model, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/reviews/reviews.php)
- `plg_publications_share` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/share/share.php)
- `plg_publications_supportingdocs` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true, $authorized = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/supportingdocs/supportingdocs.php)
- `plg_publications_usage` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/usage/usage.php)
- `plg_publications_versions` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true, $authorized = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/versions/versions.php)
- `plg_publications_wishlist` — [`onPublication($publication, $option, $areas, $rtrn='all', $version = 'default', $extended = true)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/wishlist/wishlist.php)

## `publications.onPublicationAreas` { #publications-onpublicationareas }

Fired from:

- [`core/components/com_publications/site/controllers/publications.php:648`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/site/controllers/publications.php#L648) with `[ $this->model, $this->model->versionAlias, $extended]`

No plugin in the source tree listens for this event.

## `publications.onPublicationExtended` { #publications-onpublicationextended }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_publications_forks` — [`onPublicationExtended($publication, $option, $miniview=0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/forks/forks.php)

## `publications.onPublicationRateItem` { #publications-onpublicationrateitem }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_publications_reviews` — [`onPublicationRateItem($option)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/reviews/reviews.php)

## `publications.onPublicationSub` { #publications-onpublicationsub }

Fired from:

- [`core/components/com_publications/site/views/view/tmpl/default.php:200`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/site/views/view/tmpl/default.php#L200) with `[$this->publication, $this->option, 1]`

Listeners:

- `plg_publications_forks` — [`onPublicationSub($publication, $option, $miniview=0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/forks/forks.php)
- `plg_publications_groups` — [`onPublicationSub($publication, $option, $miniview=0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/groups/groups.php)
- `plg_publications_recommendations` — [`onPublicationSub($publication, $option, $miniview=0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/recommendations/recommendations.php)
- `plg_publications_related` — [`onPublicationSub($publication, $option, $miniview=0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/related/related.php)
- `plg_publications_watch` — [`onPublicationSub($publication, $option, $miniview=0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/watch/watch.php)

## `publications.onPublicationsList` { #publications-onpublicationslist }

Fired from:

- [`core/components/com_publications/site/views/browse/tmpl/item.php:51`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/site/views/browse/tmpl/item.php#L51) with `[$this->line]`

No plugin in the source tree listens for this event.

## `publications.onWatch` { #publications-onwatch }

Fired from:

- [`core/components/com_publications/site/controllers/curation.php:966`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/site/controllers/curation.php#L966) with `[$pub]`

Listeners:

- `plg_publications_watch` — [`onWatch($publication, $activity = 'newversion')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/publications/watch/watch.php)
