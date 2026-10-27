---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/09-components/04-helpers.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
  source: https://help.hubzero.org/documentation/240/webdevs/components/helpers
---

# Helpers

A helper is a class that holds work several controllers or views need but that
belongs to none of them: building a `<select>` from a list of instruments,
resolving what the current user is allowed to do, formatting something for
display. Helpers keep that code in one place.

Reach for one when the same few lines have appeared in a second file. Do not
reach for one when the work belongs to a record — whether a reservation
overlaps another is the `Reservation` model's business, not a helper's, and a
helper that takes a model and asks questions about it is a method that got
lost. See [Models](models.md).

## Where they go

A component may have helpers in two places:

| Directory | Namespace | Scope |
|---|---|---|
| `com_bookings/helpers/` | `Components\Bookings\Helpers` | shared by every client |
| `com_bookings/admin/helpers/` | `Components\Bookings\Admin\Helpers` | administrator only |
| `com_bookings/site/helpers/` | `Components\Bookings\Site\Helpers` | site only |

Put a helper at the top level when more than one client uses it, and inside a
client when it is bound to that client's interface — an administrator toolbar
or form control has no business in the site's namespace.

Both are autoloaded by
[`Hubzero\Base\ClassLoader`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Base/ClassLoader.php),
so `Components\Kb\Admin\Helpers\Permissions` is found at
`core/components/com_kb/admin/helpers/permissions.php` with no `require`. Some
shipped components still `require_once` their helpers from the entry point;
that is left over from before the class loader and is not needed in new code.

Get the namespace segment wrong and the class is simply not found:
`Components\Bookings\Helpers\Slots` declared in
`com_bookings/site/helpers/slots.php` never loads, because the loader looks
under `com_bookings/helpers/`. The error is `Class ... not found` at the first
call, with nothing to say the file exists a directory away.

## A static helper

The common shape is a class of static methods with no state. `com_kb`
resolves the current user's permissions this way, and both administrator views
call it to decide which toolbar buttons to draw:

```php
namespace Components\Kb\Admin\Helpers;

use Hubzero\Base\Obj;
use User;

/**
 * Knowledge Base permissions helper
 */
class Permissions
{
	/**
	 * Name of the component
	 *
	 * @var  string
	 */
	public static $extension = 'com_kb';

	/**
	 * Gets a list of the actions that can be performed.
	 *
	 * @param   string   $extension  The extension.
	 * @param   integer  $assetId    The asset ID.
	 * @return  object   Object
	 */
	public static function getActions($assetType='component', $assetId = 0)
	{
		$assetName  = self::$extension;
		if ($assetId)
		{
			$assetName .= '.' . $assetType;
			$assetName .= '.' . (int) $assetId;
		}

		$actions = array(
			'core.admin',
			'core.manage',
			'core.create',
			'core.edit',
			'core.edit.state',
			'core.delete'
		);

		$result = new Obj;

		foreach ($actions as $action)
		{
			$result->set($action, User::authorise($action, $assetName));
		}

		return $result;
	}
}
```

Used from a view:

```php
$canDo = Components\Kb\Admin\Helpers\Permissions::getActions('article');

if ($canDo->get('core.create'))
{
    Toolbar::addNew();
}
```

`com_bookings` wants the same thing under its own name —
`Components\Bookings\Admin\Helpers\Permissions::getActions('instrument')` —
reading the actions out of its own `config/access.xml`. See
[Configuration](configuration.md).

`com_kb`'s other helper, `Components\Kb\Admin\Helpers\Html`, is the same
pattern applied to markup: one static method that renders the category
`<select>` used by the edit form, so the list and the indentation rules are
written once.

!!! note
    A namespaced helper needs its own facade imports. `Permissions`
    imports `User` at the top of the file; without that, `User::authorise()`
    would resolve to `Components\Kb\Admin\Helpers\User` and fatal. See
    [Facades](../foundation/facades.md#importing-a-facade).

## A helper with state

Nothing requires a helper to be static. When a helper needs configuration or a
database handle, make it an ordinary object and extend `Hubzero\Base\Obj` so it
inherits `get()`, `set()`, and the error bag —
[`Components\Answers\Helpers\Economy`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/helpers/economy.php)
is built that way.

## View helpers

Views reach helpers by a second route. `Hubzero\View\View::__call()` turns an
unknown method call on a view into a helper lookup, which is how
`$this->css()`, `$this->js()`, `$this->img()`, and `$this->pagination()`
work. The built-in set lives in
`core/libraries/Hubzero/View/Helper`:

| Call | Does |
|---|---|
| `css()`, `js()`, `img()` | attach or locate an asset — see [Assets](assets.md) |
| `pagination()` | render a pager |
| `grid()` | administrator list-table controls |
| `editor()` | render the configured WYSIWYG editor |
| `truncate()` | shorten text on a word boundary |
| `highlight()` | wrap search terms in `<span class="highlight">` |
| `autolink()` | turn bare URLs into links |
| `obfuscate()` | encode an email address against scrapers |
| `clean()` | strip unsafe markup |
| `icon()`, `autocompleter()` | icons; the autocomplete widget |

[`Hubzero\Component\View`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Component/View.php)
extends that lookup to your component. Before falling back to the built-ins it
looks for `Components\{Name}\Helpers\{Method}`, and if it finds one that is
invokable it registers it. So a class
`Components\Bookings\Helpers\Slot` with a `__invoke()` method, extending
`Hubzero\View\Helper\AbstractHelper`, becomes `$this->slot($reservation)` in
every `com_bookings` view:

```php
namespace Components\Bookings\Helpers;

use Hubzero\View\Helper\AbstractHelper;

class Slot extends AbstractHelper
{
    public function __invoke($reservation)
    {
        return $this->getView()->escape(
            $reservation->starts . ' - ' . $reservation->ends
        );
    }
}
```

Note that the class name carries no client segment, so the file belongs in the
component's top-level `helpers/` directory, not the client's.

!!! note
    The helper must extend `AbstractHelper`, or at least implement
    `setView()`: the view calls `setView($this)` on the object before invoking
    it, and an invokable class missing that method is a fatal
    "call to undefined method", not a fallback. No component in the tree
    currently uses this hook — the static pattern above is what you will find in
    practice.
