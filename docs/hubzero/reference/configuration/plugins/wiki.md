---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/wiki.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/wiki/*/*.xml
---

# Wiki plugins

Parameters of every plugin in the `wiki` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Wiki - Editor Toolbar (`plg_wiki_editortoolbar`) { #wiki-editor-toolbar-plg-wiki-editortoolbar }

Creates a textarea with an editing toolbar for wiki syntax shortcuts

This plugin has no parameters.

## Wiki - Editor Wykiwyg (`plg_wiki_editorwykiwyg`) { #wiki-editor-wykiwyg-plg-wiki-editorwykiwyg }

Creates a wysiwyg textarea with an editing toolbar for wiki syntax shortcuts

This plugin has no parameters.

## Wiki - Default Parser (`plg_wiki_parserdefault`) { #wiki-default-parser-plg-wiki-parserdefault }

Loads a wiki parser and performs any called actions on text passed to it

This plugin has no parameters.

## Wiki - Markdown Parser (`plg_wiki_parsermarkdown`) { #wiki-markdown-parser-plg-wiki-parsermarkdown }

Loads a Markdown parser and performs any called actions on text passed to it

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `style` | Style | list | `Markdown` | Choose the flavor of Markdown to use. Options: `Markdown`, `GithubMarkdown` Github Markdown, `MarkdownExtra` Markdown Extra. |
