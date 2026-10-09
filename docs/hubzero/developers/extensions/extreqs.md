---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/07-extensions/01-extreqs.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/240/webdevs/extensions/extreqs
  source-id: '3467'
  imported: '2026-09-09'
  source-state: unpublished
---

# Requirements

What an extension has to have before a hub will load it. Getting the code
onto a hub is a separate question, covered in
[Deploying extensions](deployext.md).

Nothing on this page is negotiable and none of it is checked for you. There
is no validator, no install step that inspects the package and complains.
Every requirement here fails at runtime instead, and most of them fail
quietly: a directory in the wrong place is a class that does not exist, a
missing row is an extension the hub cannot see, an unimported facade is a
fatal on one branch. Get the shape right first and the rest of the work is
ordinary PHP.

## The platform

Hubzero 2.4 requires **PHP 8.2 or later**
([`Hubzero\System\Requirements`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/System/Requirements.php)
holds the minimum and the list of required PHP extensions) and MariaDB or
MySQL. Write extensions against that, not against the PHP 5.4 constraint
that most shipped `composer.json` files still carry — those constraints are
stale, and nothing enforces them.

## Naming

The name is not decoration. It determines the directory, the entry file, the
manifest, the language files, the class namespace and the `#__extensions`
row, and all of them have to agree.

| Kind | Directory | Element name |
|---|---|---|
| Component | `components/com_bookings` | `com_bookings` |
| Module | `modules/mod_bookings` | `mod_bookings` |
| Plugin | `plugins/bookings/notify` | `notify`, with `folder = 'bookings'` |
| Template | `templates/partner` | `partner` |

Use lowercase and, where you need a separator, an underscore. A plugin's
package directory is conventionally `plg_{group}_{name}`, but what is
installed is `plugins/{group}/{name}` — the group is where the package
lands, not a directory inside it.

!!! tip
    Prefer a single word with no separator at all. The migration
    runner's `-e` option validates against `^com_[[:alnum:]]+$`,
    `^mod_[[:alnum:]]+$`, `^tpl_[[:alnum:]]+$` or `^plg_[[:alnum:]]+_[[:alnum:]]+$`,
    so `com_instrument_bookings` cannot be migrated by name at all. `com_bookings`
    can.

## The layout

Each kind has its own chapter on structure —
[components](../components/structure.md),
[modules](../modules/structure.md), [plugins](../plugins/structure.md),
[templates](../templates/structure.md) — but the shape is the same
everywhere: an entry point, an XML manifest named after the extension, a
`composer.json`, language files under `language/{tag}/`, and a `migrations/`
directory.

A component is the one with more than one face. Laid out for `com_bookings`,
the instrument-booking component the [component chapters](../components/index.md)
build:

```
com_bookings/
    admin/          the administrator interface
        bookings.php
        controllers/  views/  language/en-GB/
    api/            the REST controllers
    site/           what hub visitors see
        bookings.php
        router.php  controllers/  views/  language/en-GB/
    config/config.xml
    migrations/
    models/
    composer.json
    bookings.xml
```

### The entry point

`Hubzero\Component\Loader` looks, in order, for a
`Components\Bookings\Site\Bootstrap` class, then for
`site/bookings.php`, then for a React application under `site/assets/react/`,
and only then falls back to its default dispatcher. Write the second form:
every component in the tree uses it, and it is four lines that hand off to the
controller:

```php
<?php
/**
 * @package    hubzero-cms
 * @copyright  Copyright (c) 2005-2020 The Regents of the University of California.
 * @license    http://opensource.org/licenses/MIT MIT
 */

namespace Components\Blog\Site;

require_once dirname(__DIR__) . DS . 'models' . DS . 'archive.php';

$controllerName = \Request::getCmd('controller', \Request::getCmd('view', 'entries'));
if (!file_exists(__DIR__ . DS . 'controllers' . DS . $controllerName . '.php'))
{
	$controllerName = 'entries';
}
require_once __DIR__ . DS . 'controllers' . DS . $controllerName . '.php';
$controllerName = __NAMESPACE__ . '\\Controllers\\' . ucfirst(strtolower($controllerName));

// Instantiate controller
```

A module's entry point is `mod_{name}.php`; `Hubzero\Module\Loader` `include`s
the file. A plugin's entry point is `{name}.php`, holding a class whose public
methods are named for the events it answers — the method name *is* the
registration, so a misspelled event name is a method that is simply never
called.

### The XML manifest

Every extension carries an XML manifest named after it — `bookings.xml` — and
the manifest is not listed in its own `<files>` block. The CMS reads the
display name, the description and the parameter form from it, and caches it
in the extension row's `manifest_cache` column. **Refresh Cache** in the
[Extension Manager](../../managers/extensions/extension-manager.md) re-reads
it after an edit.

The manifest is metadata, not an installer script. Nothing in it creates a
table, a row or a menu entry; an extension with no manifest at all still
runs.

```xml
<?xml version="1.0" encoding="utf-8"?>
<extension version="2.5" type="plugin" group="system">
	<name>plg_system_debug</name>
	<creationDate>December 2012</creationDate>
	<author>HUBzero</author>
	<authorUrl>hubzero.org</authorUrl>
	<authorEmail>support@hubzero.org</authorEmail>
	<copyright>Copyright (c) 2005-2020 The Regents of the University of California.</copyright>
	<license>http://opensource.org/licenses/MIT MIT</license>
	<version>2.5.0</version>
	<description>PLG_DEBUG_XML_DESCRIPTION</description>
	<files>
		<filename plugin="debug">debug.php</filename>
		<filename>index.html</filename>
	</files>
	<languages>
		<language tag="en-GB">en-GB.plg_system_debug.ini</language>
```

| Element | Meaning |
|---|---|
| `type` | `component`, `module`, `plugin` or `template`. Required. |
| `group` | The plugin group. Plugins only, and required for them. |
| `client` | `site` or `administrator`. Modules and templates. |
| `version` | The manifest format version, not the extension's. |
| `<name>` | Shown in the administrator's lists. A language key or a readable string. |
| `<description>` | A language key, resolved from the `.sys.ini` file. |
| `<files>` | What to install. `<folder>` for a whole directory; the `plugin=` or `module=` attribute on a `<filename>` marks the entry point. |
| `<languages>` | Translation files. |
| `<config>` | The parameter form. See [Parameters](parameters.md). |
| `<positions>` | Template positions. Templates only. |

!!! note
    The `<files>` list matters only to a packager that copies files
    one at a time. Nothing in this release installs an extension that way — the
    code arrives as a whole directory, by `git` or by hand — so a `<files>`
    block that has drifted from what is on disk breaks nothing. Do not read it
    as a description of the extension.

### The Composer manifest

```json
{
	"name": "myorg/com_bookings",
	"description": "Instrument booking component for the Hubzero CMS",
	"type": "hubzero-component",
	"keywords": ["hubzero"],
	"license": "MIT",
	"require": {
		"php": "^8.2"
	}
}
```

The recognised types are `hubzero-component`, `hubzero-module`,
`hubzero-plugin` and `hubzero-template`. A plugin must also declare where it
installs, because its group cannot be recovered from a name like
`plg_bookings_notify`:

```json
	"extra": {
		"install-directory": "/plugins/bookings/notify/"
	}
```

### Language files

One directory per language tag, one file named for the tag and the
extension:

```
language/en-GB/en-GB.mod_bookings.ini
language/en-GB/en-GB.mod_bookings.sys.ini
```

A component has one set per client, and the administrator's set is not the
site's. See [Languages](languages.md).

### The migration

The row in `#__extensions` is what makes an extension exist as far as the
platform is concerned, and a
[migration](../database.md#migrations) is how an extension creates it —
the only way, because this release has no package installer to do it for you.
The migration also creates the extension's tables and drops them again on the
way down.

```php
use Hubzero\Content\Migration\Base;

defined('_HZEXEC_') or die();

class Migration20260901000000ComBookings extends Base
{
	public function up()
	{
		$this->addComponentEntry('bookings');
	}

	public function down()
	{
		$this->deleteComponentEntry('bookings');
	}
}
```

Write this file first, before the controllers. It is one call, it takes a
minute, and skipping it produces an extension that appears to work and is
absent from every administrative screen.

`addComponentEntry` is a *macro* — one of the helpers `Base` resolves out of
[`Hubzero\Content\Migration\Macros`](https://github.com/hubzero/hubzero-cms/tree/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Content/Migration/Macros).
There is one per kind — `addComponentEntry`, `addModuleEntry`,
`addPluginEntry`, `addTemplateEntry` — with a matching `delete...` for each,
and `enable...` / `disable...` alongside. Use them rather than writing the
`INSERT` yourself: they set the columns the loaders read, they create the
asset row that permissions hang off and the administrator menu entry, and
re-running them is safe. A hand-written `INSERT` is the older way and gets
those side effects wrong.

Note the argument order for a plugin: `addPluginEntry($folder, $element)` —
the group first, then the name. `addComponentEntry($name)` takes the name
first.

### `index.html` { #index-html }

Every directory carries an empty `index.html`, so that a misconfigured web
server cannot list it. Copy the ones already in the tree.

## The entry guard

Any file that produces output — a view template, an entry point, anything
outside a class — opens with:

```php
defined('_HZEXEC_') or die();
```

`_HZEXEC_` is defined by [`core/bootstrap/app.php`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/app.php)
and by nothing else, so the guard stops the file dead if it is requested
directly over HTTP. A file that only declares a namespaced class does not
need it. See [Constants](../foundation/constants.md).

## Facade imports

The platform's short names — `Route`, `Lang`, `User`, `Config`, `Request`,
`Component` — are aliases in the **root** namespace. An extension class is
namespaced, so an unqualified `Route::url()` inside it resolves to
`Components\Bookings\Site\Controllers\Route` and fatals when that line runs.
The file parses; nothing fails until the branch executes — which is why it
usually turns up on the error path, in front of a user.

Import every facade you use:

```php
namespace Components\Bookings\Site\Controllers;

use Hubzero\Component\SiteController;
use Request;
use Route;
use Lang;
```

`php docs/_tools/lint/missing-facade-imports.php` finds the ones you missed, and
runs on every push. See [Facades](../foundation/facades.md).

Which facades exist depends on the client. `Toolbar` and `Submenu` are
registered only for the administrator, `Pathway` only for the site, and the
API client has none of those, nor `Notify`, `Document` or `Html`. The `use`
statement is valid either way; the class is not there.
