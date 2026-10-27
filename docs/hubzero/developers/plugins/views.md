---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/10-plugins/05-views.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 91d03d0a23
  reviewed: '2026-09-10'
  source: https://help.hubzero.org/documentation/240/webdevs/plugins/views
---

# Views

Most plugins return data, not markup, and never build a view. Reach for one
when the text you are producing is longer than the logic that produces it: a
plugin that adds a tab to a group page, a panel to a member profile, or — like
`plg_bookings_notify` — the body of an email. The reason is not tidiness. A
layout in a file can be overridden by a template or a super group; a string
built inside the class cannot.

## Where layouts live

```
app/plugins/bookings/notify/
    views/
        email/tmpl/message.php
```

```
core/plugins/groups/forum/
    views/
        sections/tmpl/display.php
        categories/tmpl/display.php
        categories/tmpl/edit.php
        threads/tmpl/display.php
```

Under `views` there is one directory per view *name*, and inside it a `tmpl`
directory holding one file per *layout*. Both names are yours to choose;
`default` is the layout used when none is given. The `tmpl` directory is not
optional for a plugin view — `Hubzero\Plugin\View` searches
`{plugin}/views/{name}/tmpl` and the template override path, and nowhere else.

## Creating a view

`$this->view($layout, $name)` on the plugin returns a
[`Hubzero\Plugin\View`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Plugin/View.php)
configured for this plugin. Note the argument order: **layout first, name
second**. So `plg_bookings_notify` reaches `views/email/tmpl/message.php` with

```php
$body = $this->view('message', 'email')
	->set('reservation', $reservation)
	->loadTemplate();
```

and `plgGroupsForum` renders `views/sections/tmpl/display.php` with

```php
$this->view = $this->view('display', 'sections');
```

Either argument may be omitted. `$this->view()` gives the `default` layout of
a view named after the plugin itself, so a plugin called `notify` with a single
screen can keep it at `views/notify/tmpl/default.php`.

Constructing the view class directly works too, and is what the helper does
underneath:

```php
$view = new \Hubzero\Plugin\View(array(
	'folder'  => 'bookings',
	'element' => 'notify',
	'name'    => 'email',
	'layout'  => 'message'
));
```

`folder` is the plugin group, `element` is the plugin, `name` is the view
directory, and `layout` is the file inside `tmpl`.

## Passing data and rendering

`set()` assigns a variable and returns the view, so calls chain, and
`loadTemplate()` renders the layout and returns the markup as a string:

```php
		return $this->view
			->set('recvEmailOptionID', $recvEmailOptionID)
			->set('recvEmailOptionValue', $recvEmailOptionValue)
			->set('option', $this->option)
			->set('group', $this->group)
			->set('filters', $filters)
			->set('config', $this->params)
			->set('forum', $this->forum)
			->set('sections', $sections)
			->set('categories', $categories)
			->set('edit', $edit)
			->loadTemplate();
```

Return that string from your event handler. Use `loadTemplate()`, not
`display()`: `display()` echoes, which puts the output wherever the buffer
happens to be rather than in the response the component asked for.

Assigning to properties works as well as `set()` — `$view->group = $group;` —
and reads the same in the layout.

!!! note
    `loadTemplate()` takes one optional argument, and it is not a
    boolean. It is a suffix: `loadTemplate('html')` renders
    `{layout}_html.php`, which is how a plugin ships a plain-text and an HTML
    version of the same mail. Several core plugins call `loadTemplate(false)`,
    which reads as "not HTML" and in fact means exactly the same as
    `loadTemplate()`. Do not copy it.

## Writing a layout

```php
<?php
// No direct access
defined('_HZEXEC_') or die();
?>
<?php
$who = User::getInstance($this->reservation->get('created_by'));
echo Lang::txt('PLG_BOOKINGS_NOTIFY_BOOKED_BY', $who->get('name'));
?>

<?php echo $this->reservation->instrument->get('title'); ?>
<?php echo $this->reservation->get('starts'); ?>
```

Inside the layout, `$this` is the view. Every variable you `set()` is a
property. `$this->escape()` is available and should be used for anything that
came from the database or the request and is going into HTML; the plain-text
mail body above is the case where it is wrong to use it. Layouts run in the
global namespace, so `Lang`, `Route`, `User`, and the rest need no imports.

!!! warning
    A layout that is not found does not fail where you expect.
    `loadTemplate()` first retries with `default.php` in the same directory, so a
    mistyped layout name renders the default layout instead — silently, and with
    the data you set for a different screen. Only if there is no `default.php`
    either does it throw `InvalidLayoutException` with a 404. Layout names are
    also lower-cased before the lookup, so `views/email/tmpl/Message.php` is not
    found on a case-sensitive filesystem.

## Template overrides

`Hubzero\Plugin\View` adds a fallback search path so a template can replace
any layout:

```
{template}/html/plg_{group}_{element}/{view name}/{layout}.php
```

For the forum's sections view under the `kimera` template that is
`core/templates/kimera/html/plg_groups_forum/sections/display.php`. Note there
is no `tmpl` directory in the override path.

The override path is searched **before** the plugin's own file, which is what
makes it an override — the search paths are a stack and the override is pushed
on last. See [Overrides](../templates/overrides.md).

## Sub-views

`view()` exists on the view class too, with the same layout-first argument
order, so a layout can render a partial without repeating the folder and
element:

```php
<?php
$this->view('_entry')
     ->set('entry', $entry)
     ->display();
?>
```

That looks for `views/{current view name}/tmpl/_entry.php`. Pass a second
argument to reach a different view directory. Use `display()` here, because
you do want the output echoed into the enclosing layout; use `loadTemplate()`
if you need the string.

## Helpers

Calling an undefined method on a plugin view makes it look for a helper: first
a file `helpers/{method}.php` under the plugin directory, then a class named
`Plugins\{Group}\{Element}\Helpers\{Method}`, falling back to the older
`Plugin{Group}{Element}Helper{Method}`. If the class is invokable it is bound
to the view and called. This is how plugins share a formatting routine between
several layouts without a global function.

The namespaced form is the one to write. The `Plugin…Helper…` form is
inherited naming kept for the plugins that still use it, and a new helper
should not add to them.

!!! note
    A plugin does not have to use views at all. Returning a small
    string of markup from an event handler is legitimate for a one-line
    response, and `plg_content_*` plugins that rewrite article text never build
    a view.
