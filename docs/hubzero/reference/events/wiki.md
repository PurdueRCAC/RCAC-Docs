---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/wiki.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('wiki.*') call sites and core/plugins/wiki/
---

# Wiki events

Events in the `wiki` group. A plugin in `core/plugins/wiki/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `wiki.onAfterDisplayContent` { #wiki-onafterdisplaycontent }

Fired from:

- [`core/components/com_wiki/site/controllers/pages.php:279`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/site/controllers/pages.php#L279) with `[&$this->page, &$revision, $this->config]`

No plugin in the source tree listens for this event.

## `wiki.onAfterDisplayTitle` { #wiki-onafterdisplaytitle }

Fired from:

- [`core/components/com_wiki/site/controllers/pages.php:273`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/site/controllers/pages.php#L273) with `[$this->page, &$revision, $this->config]`

No plugin in the source tree listens for this event.

## `wiki.onBeforeDisplayContent` { #wiki-onbeforedisplaycontent }

Fired from:

- [`core/components/com_wiki/site/controllers/pages.php:276`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/site/controllers/pages.php#L276) with `[&$this->page, &$revision, $this->config]`

No plugin in the source tree listens for this event.

## `wiki.onDisplayEditor` { #wiki-ondisplayeditor }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_wiki_editortoolbar` — [`onDisplayEditor($name, $id, $content, $cls='wiki-toolbar-content', $col=10, $row=35)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/editortoolbar/editortoolbar.php)
- `plg_wiki_editorwykiwyg` — [`onDisplayEditor($name, $id, $content, $cls='wiki-toolbar-content', $col=10, $row=35)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/editorwykiwyg/editorwykiwyg.php)

## `wiki.onGetWikiParser` { #wiki-ongetwikiparser }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_wiki_parserdefault` — [`onGetWikiParser($config, $getnew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/parserdefault/parserdefault.php)
- `plg_wiki_parsermarkdown` — [`onGetWikiParser($config, $getnew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/parsermarkdown/parsermarkdown.php)

## `wiki.onInitEditor` { #wiki-oniniteditor }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_wiki_editortoolbar` — [`onInitEditor()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/editortoolbar/editortoolbar.php)
- `plg_wiki_editorwykiwyg` — [`onInitEditor()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/editorwykiwyg/editorwykiwyg.php)

## `wiki.onWikiAfterBeforeComment` { #wiki-onwikiafterbeforecomment }

Fired from:

- [`core/components/com_wiki/admin/controllers/comments.php:254`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/comments.php#L254) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wiki.onWikiAfterDelete` { #wiki-onwikiafterdelete }

Fired from:

- [`core/components/com_wiki/admin/controllers/pages.php:365`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/pages.php#L365) with `[$id]`

No plugin in the source tree listens for this event.

## `wiki.onWikiAfterDeleteComment` { #wiki-onwikiafterdeletecomment }

Fired from:

- [`core/components/com_wiki/admin/controllers/comments.php:321`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/comments.php#L321) with `[$id]`

No plugin in the source tree listens for this event.

## `wiki.onWikiAfterDeleteVersion` { #wiki-onwikiafterdeleteversion }

Fired from:

- [`core/components/com_wiki/admin/controllers/versions.php:354`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/versions.php#L354) with `[$id]`

No plugin in the source tree listens for this event.

## `wiki.onWikiAfterSave` { #wiki-onwikiaftersave }

Fired from:

- [`core/components/com_wiki/admin/controllers/pages.php:276`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/pages.php#L276) with `[&$page, $isNew]`
- [`core/components/com_wiki/site/controllers/history.php:485`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/site/controllers/history.php#L485) with `[&$this->page, false]`
- [`core/components/com_wiki/site/controllers/pages.php:727`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/site/controllers/pages.php#L727) with `[&$this->page, $isNew]`

No plugin in the source tree listens for this event.

## `wiki.onWikiAfterSaveComment` { #wiki-onwikiaftersavecomment }

Fired from:

- [`core/components/com_wiki/admin/controllers/comments.php:270`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/comments.php#L270) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wiki.onWikiAfterSaveVersion` { #wiki-onwikiaftersaveversion }

Fired from:

- [`core/components/com_wiki/admin/controllers/versions.php:246`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/versions.php#L246) with `[&$version, $isNew]`

No plugin in the source tree listens for this event.

## `wiki.onWikiBeforeSave` { #wiki-onwikibeforesave }

Fired from:

- [`core/components/com_wiki/admin/controllers/pages.php:252`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/pages.php#L252) with `[&$page, $isNew]`
- [`core/components/com_wiki/site/controllers/pages.php:621`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/site/controllers/pages.php#L621) with `[&$this->page, $isNew]`

No plugin in the source tree listens for this event.

## `wiki.onWikiBeforeSaveVersion` { #wiki-onwikibeforesaveversion }

Fired from:

- [`core/components/com_wiki/admin/controllers/versions.php:211`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wiki/admin/controllers/versions.php#L211) with `[&$version, $isNew]`

No plugin in the source tree listens for this event.

## `wiki.onWikiParseText` { #wiki-onwikiparsetext }

Fired from:

- [`core/plugins/content/formatwiki/formatwiki.php:121`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/content/formatwiki/formatwiki.php#L121) with `[$content, $params, $params['fullparse'], true]`

Listeners:

- `plg_wiki_parserdefault` — [`onWikiParseText($text, $config, $fullparse=true, $getnew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/parserdefault/parserdefault.php)
- `plg_wiki_parsermarkdown` — [`onWikiParseText($text, $config, $fullparse=true, $getnew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/wiki/parsermarkdown/parsermarkdown.php)
