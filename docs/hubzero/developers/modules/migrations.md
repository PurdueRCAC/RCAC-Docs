---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/08-modules/01-migrations.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 91d03d0a23
  reviewed: '2026-09-10'
  source: https://help.hubzero.org/documentation/240/webdevs/modules/migrations
---

# Migrations

A module has to be registered in the `#__extensions` table before the CMS will
list it or let an administrator create an instance of it. That registration is
done by a migration: a small PHP class in the module's `migrations` directory
that the [`muse migration`](../muse.md) command runs.

Write it first. A module is the one extension kind that cannot be published at
all without its row — a component with no row still serves its own pages, a
plugin at least fails at a known event, but an unregistered module simply is
not in the Module Manager's list of things you can create.
[How an extension is found](../extensions/index.md#how-an-extension-is-found)
sets the four kinds side by side.

## Where migrations live

```
app/modules/mod_upcoming_bookings/
    migrations/
        Migration20260101000000ModUpcomingBookings.php
```

The class name carries the timestamp and the extension, and the file is named
after the class. Migrations are run in timestamp order across every extension
on the hub, so a module that depends on a component's tables should carry a
later timestamp than the migration that creates them.

!!! note
    See [Migrations](../database.md#migrations) for naming
    conventions, the `muse` commands, and the helpers available on `$this->db`.

## The registration migration

Most modules need exactly one migration, and it is four lines long:

```php
<?php
/**
 * @package    hubzero-cms
 * @copyright  Copyright (c) 2005-2020 The Regents of the University of California.
 * @license    http://opensource.org/licenses/MIT MIT
 */

use Hubzero\Content\Migration\Base;

/**
 * Migration script for installing mygroups module
 **/
class Migration20190109000000ModMyGroups extends Base
{
	/**
	 * Up
	 **/
	public function up()
	{
		$this->addModuleEntry('mod_mygroups');
	}

	/**
	 * Down
	 **/
	public function down()
	{
		$this->deleteModuleEntry('mod_mygroups');
	}
}
```

`mod_upcoming_bookings` is the same file with its own name in it:

```php
class Migration20260101000000ModUpcomingBookings extends Base
{
	public function up()
	{
		$this->addModuleEntry('mod_upcoming_bookings');
	}

	public function down()
	{
		$this->deleteModuleEntry('mod_upcoming_bookings');
	}
}
```

That is the whole of it, because the module owns no tables. It reads
`#__bookings_reservations`, which `com_bookings`'s own migration creates — so
give the module a timestamp later than the component's, and declare the
dependency in `composer.json` as well. See [Packaging](packaging.md).

`addModuleEntry()` and `deleteModuleEntry()` are macros resolved by
[`Hubzero\Content\Migration\Base`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Content/Migration/Base.php)
from the `Macros` directory beside it. Their signatures are:

| Macro | Signature |
|---|---|
| `addModuleEntry` | `($element, $enabled = 1, $params = '', $client = 0)` |
| `deleteModuleEntry` | `($element, $client = null)` |
| `enableModule` | `($element)` |
| `disableModule` | `($element)` |
| `installModule` | `($module, $position, $always = true, $params = '', $client = 0, $menus = 0)` |
| `saveParams` | `($element, $params)` |
| `getParams` | `($element, $returnRaw = false)` |

`$element` is the full directory name, including the `mod_` prefix. `$client`
is `0` for a site module and `1` for an administrator module, and must agree
with `client="site"` or `client="administrator"` in the XML manifest, or the
module will never appear in the client you built it for.

!!! note
    `addModuleEntry` checks for an existing row first, so re-running a
    migration does not create a duplicate registration.

## Creating an instance from a migration

Registering a module does not place it anywhere. If your module is meant to
appear as soon as it is installed, `installModule()` writes a published
`#__modules` instance assigned to a position, and a `#__modules_menu` row for
each menu id in `$menus` — the default of `0` meaning all of them.

One migration in the tree does this, and it is worth reading whole because it
gets both hard parts right:

```php
	public function up()
	{
		$this->deletePluginEntry('content', 'collect');
		$this->deletePluginEntry('resources', 'collect');
		$this->deletePluginEntry('wiki', 'collect');

		$this->addModuleEntry('mod_collect', 1, '', 0);

		$query = "SELECT COUNT(*) FROM `#__modules` WHERE `module`='mod_collect'";
		$this->db->setQuery($query);
		if (!$this->db->loadResult())
		{
			$position = 'endpage';
			$found = false;

			$query  = "SELECT COUNT(*) FROM `#__modules` WHERE `client_id`=0 AND `position`=";
			$this->db->setQuery($query . $this->db->quote($position));
			if ($this->db->loadResult())
			{
				$found = true;
			}

			if (!$found)
			{
				$position = 'footer';
				$this->db->setQuery($query . $this->db->quote($position));
				if ($this->db->loadResult())
				{
					$found = true;
				}
			}

			if ($found)
			{
				$this->installModule('collect', $position);
			}
		}
	}
```

`addModuleEntry()` first, `installModule()` second, and the position is not
guessed: the migration looks for a position other site modules are already
using — `endpage`, then `footer` — and places the instance only if it finds
one. A position no template renders would have left `mod_collect` published
and invisible.

!!! warning
    `installModule()` writes `#__modules` and `#__modules_menu` and
    nothing else. It does **not** register the extension, despite the name. On
    its own it leaves a published instance whose module has no `#__extensions`
    row, and `Loader::all()` joins the two and requires `e.enabled = 1`, so the
    instance renders nothing and shows no error. Call `addModuleEntry()` first,
    as `mod_collect` does.

!!! warning
    `installModule()` takes the name *without* the `mod_` prefix
    and adds it itself — `$module = 'mod_' . strtolower($module)`. Every other
    module macro takes the prefixed name. Pass the prefixed name here and the
    `#__modules` row records `mod_mod_upcoming_bookings`, which resolves to no
    directory and renders nothing.

`$always` does not mean what the name suggests either. It does not control the
menu assignment: `$menus` does that, in every case. `$always = false` makes the
macro skip the insert when a `#__modules` instance of that module already
exists, so a re-run does not add a second copy. `$always = true`, the default,
inserts every time.

Most modules should not use `installModule()` at all. Placing a block is the
hub's decision — not every hub wants `mod_upcoming_bookings`, and those that
do will not agree on which column — so register it with `addModuleEntry()` and
let an administrator place it. Reach for `installModule()` only when the
module is useless anywhere else, and then find the position the way
`mod_collect` does rather than naming one and hoping. See
[Loading](loading.md#positions-belong-to-the-template).

## Tables and schema

Most modules need none. A module that renders somebody else's records — the
booking module reads `#__bookings_reservations` and writes nothing — has
nothing to create, and a module that finds itself wanting a table of its own
is usually a component in disguise.

Where a module really does own data, it creates the tables in the same
migration, using the raw query helpers described in the
[database migrations](../database.md#migrations) chapter:

```php
public function up()
{
    if (!$this->db->tableExists('#__example_items'))
    {
        $this->db->query("CREATE TABLE `#__example_items` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `title` varchar(255) NOT NULL DEFAULT '',
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    }

    $this->addModuleEntry('mod_example');
}
```

Write the matching `down()` so the change can be rolled back. Dropping a table
in `down()` throws away data, so most core modules only reverse the extension
registration and leave the schema alone.

## Running them

```bash
muse migration          # dry run: report what would change
muse migration -f       # apply
muse migration -f -i    # apply, including migrations dated before the last run
```

Until the migration has been applied, `Hubzero\Module\Loader::all()` will not
return the module — its query joins `#__modules` to `#__extensions` and
requires `e.enabled = 1` — so an unregistered module renders nothing even if
every file is in place.

What that looks like: **New** in the Module Manager does not list
`mod_upcoming_bookings` at all. There is no error and no log line; the module
is simply not among the things you can create. If it is missing from that
list, the migration has not run.
