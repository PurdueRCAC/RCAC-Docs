---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/editors.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('editors.*') call sites and core/plugins/editors/
---

# Editors events

Events in the `editors` group. A plugin in `core/plugins/editors/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `editors.onDisplay` { #editors-ondisplay }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors_ckeditor` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor/ckeditor.php)
- `plg_editors_ckeditor5` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor5/ckeditor5.php)
- `plg_editors_codemirror` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/codemirror/codemirror.php)
- `plg_editors_none` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/none/none.php)
- `plg_editors_pagedown` — [`onDisplay($name, $content, $width, $height, $columns, $rows, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/pagedown/pagedown.php)
- `plg_editors_tinymce` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/tinymce/tinymce.php)
- `plg_editors_wikitoolbar` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/wikitoolbar/wikitoolbar.php)
- `plg_editors_wikiwyg` — [`onDisplay($name, $content, $width, $height, $col, $row, $buttons = true, $id = null, $asset = null, $author = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/wikiwyg/wikiwyg.php)

## `editors.onGetContent` { #editors-ongetcontent }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors_ckeditor` — [`onGetContent($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor/ckeditor.php)
- `plg_editors_ckeditor5` — [`onGetContent($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor5/ckeditor5.php)
- `plg_editors_codemirror` — [`onGetContent($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/codemirror/codemirror.php)
- `plg_editors_none` — [`onGetContent($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/none/none.php)
- `plg_editors_pagedown` — [`onGetContent()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/pagedown/pagedown.php)
- `plg_editors_tinymce` — [`onGetContent($editor)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/tinymce/tinymce.php)

## `editors.onGetInsertMethod` { #editors-ongetinsertmethod }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors_ckeditor` — [`onGetInsertMethod($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor/ckeditor.php)
- `plg_editors_ckeditor5` — [`onGetInsertMethod($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor5/ckeditor5.php)
- `plg_editors_codemirror` — [`onGetInsertMethod()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/codemirror/codemirror.php)
- `plg_editors_none` — [`onGetInsertMethod($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/none/none.php)
- `plg_editors_tinymce` — [`onGetInsertMethod($name)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/tinymce/tinymce.php)

## `editors.onInit` { #editors-oninit }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors_ckeditor` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor/ckeditor.php)
- `plg_editors_ckeditor5` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor5/ckeditor5.php)
- `plg_editors_codemirror` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/codemirror/codemirror.php)
- `plg_editors_none` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/none/none.php)
- `plg_editors_pagedown` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/pagedown/pagedown.php)
- `plg_editors_tinymce` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/tinymce/tinymce.php)
- `plg_editors_wikitoolbar` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/wikitoolbar/wikitoolbar.php)
- `plg_editors_wikiwyg` — [`onInit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/wikiwyg/wikiwyg.php)

## `editors.onSave` { #editors-onsave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors_ckeditor` — [`onSave()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor/ckeditor.php)
- `plg_editors_ckeditor5` — [`onSave()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor5/ckeditor5.php)
- `plg_editors_codemirror` — [`onSave($id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/codemirror/codemirror.php)
- `plg_editors_none` — [`onSave()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/none/none.php)
- `plg_editors_pagedown` — [`onSave()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/pagedown/pagedown.php)
- `plg_editors_tinymce` — [`onSave($editor)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/tinymce/tinymce.php)

## `editors.onSetContent` { #editors-onsetcontent }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_editors_ckeditor` — [`onSetContent($id, $html)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor/ckeditor.php)
- `plg_editors_ckeditor5` — [`onSetContent($id, $html)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/ckeditor5/ckeditor5.php)
- `plg_editors_codemirror` — [`onSetContent($id, $content)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/codemirror/codemirror.php)
- `plg_editors_none` — [`onSetContent($id, $html)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/none/none.php)
- `plg_editors_pagedown` — [`onSetContent()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/pagedown/pagedown.php)
- `plg_editors_tinymce` — [`onSetContent($editor, $html)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/editors/tinymce/tinymce.php)
