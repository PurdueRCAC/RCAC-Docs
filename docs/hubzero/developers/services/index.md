---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/04-services/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
  source: https://help.hubzero.org/documentation/240/webdevs/services
---

# Services

The framework registers a small set of long-lived objects in the application
container at boot: a cache store, a filesystem, a session, an event
dispatcher. Extensions reach them through facades rather than constructing
them, so that a hub can swap the implementation without touching extension
code.

That indirection is the point, and it is also the thing that surprises
people. A service can be configured into a do-nothing version, and the
do-nothing version accepts every call and answers plausibly rather than
raising. Nothing in this section fails loudly.

| Service | What it silently does nothing about |
|---|---|
| [Cache](cache.md) | With caching off, and in the administrator application always, the store is `None`: every `put()` succeeds and every `get()` misses |
| [Session](session.md) | `get()` and `has()` return the default when no session is active, rather than raising |
| [Events](events.md) | An event nothing listens to returns an empty array, which is what a disabled plugin also returns |
| [Filesystem](filesystem.md) | The `None` adapter exists for tests; `write()` returning `false` is the only signal a write failed |
| [Server](server.md) | `serve()` returns `false` rather than throwing, and checks nothing about permissions |

So test the return value, and do not build anything that depends on a
service having remembered something.

## How a service gets there

Each service is registered by a service provider under `core/bootstrap/`,
one directory per client (`Site`, `Administrator`, `Api`, `Cli`). The
provider binds a closure to a key on the container; the closure runs the
first time something asks for that key, and its result is cached for the
rest of the request.

```php
	public function register()
	{
		$this->app['cache'] = function($app)
		{
			return new Manager($app);
		};

		$this->app['cache.store'] = function($app)
		{
			$handler = !$app['config']->get('caching') ? 'none' : $app['config']->get('cache_handler');

			if ($app->isAdmin())
			{
				$handler = 'none';
			}

			return $app['cache']->storage($handler);
		};
	}
```

Because the closure reads `$app['config']`, the service you get back depends
on the hub's configuration. The cache store above is a real file cache on a
hub with caching turned on and a do-nothing `None` store on one without.
The [service providers](../foundation/providers.md) chapter covers the
registration mechanism itself; the chapters here cover what each service
does once you have it.

## Reaching a service

Two ways, and they return the same object:

```php
$filesystem = App::get('filesystem');

// or, through the facade
Filesystem::exists($path);
```

Prefer the facade. It is shorter, and a test can put a double in the
container under the same key and the facade will pick it up.

!!! note
    The facades are aliased in the **root** namespace. Almost every
    file you write is namespaced, and there an unqualified `Filesystem` means
    `Your\Namespace\Filesystem`, which does not exist — a fatal error the
    moment the line runs. Import each facade you use (`use Filesystem;`) or
    write it fully qualified (`\Filesystem::exists(...)`). See
    [facades](../foundation/facades.md).

Not every client registers every service. `Cache`, `Session`, `Module`,
`Pathway`, `Notify`, `Document` and `Html` are site and administrator only;
`App`, `Config`, `Request`, `Response`, `Event`, `Route`, `User`, `Lang`,
`Log`, `Date`, `Plugin` and `Filesystem` exist everywhere. Each client's
list is its own `aliases.php`.

## In this section

- [Cache](cache.md) — the cache store, its drivers, and the group
    convention that makes `Cache::clean()` selective.
- [Filesystem](filesystem.md) — reading, writing, and listing files
    through an adapter, and the macros that extend it.
- [Session](session.md) — per-visitor storage, namespaces, and the form
    token that guards every write.
- [Events](events.md) — the dispatcher, how a plugin group becomes a
    listener, and what `Event::trigger()` gives back.
- [Server](server.md) — serving a file off disk as a download.

Configuration, requests, responses, language, dates and users are covered in
[the basics](../basics/index.md).
