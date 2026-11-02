---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/developers/01-getting-started/03-databaseaccess.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 348f0057c2
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/240/webdevs/index/databaseaccess
  source-id: '3425'
---

# Direct database access

How to reach a hub's database from the command line, and the one convention
that will confuse you if nobody tells you about it: the `#__` table prefix.

You will want a `mysql` prompt sooner than you expect — to see what a
migration actually did, or what a form saved. Read this before you write a
query into an extension, because the prefix rule is not optional and the
mistake it prevents does not show up until someone installs your work on a
hub configured differently from yours.

## The credentials

A hub keeps its database credentials in `app/config/database.php`, which
returns a plain PHP array:

```php
return array(
	'dbtype'   => 'mysql',
	'host'     => 'localhost',
	'user'     => 'hubuser',
	'password' => '…',
	'db'       => 'hubdatabase',
	'dbprefix' => 'jos_',
	'port'     => '',
);
```

The file is written by the installer and is not in the repository. Read it
over [SSH](fileaccess.md#reaching-the-server); it is only readable by the
web server user and root.

```bash
mysql -u hubuser -p hubdatabase
```

!!! warning
    A hub account does not carry shell access. A system
    administrator has to grant SSH separately.

## The table prefix

Every Hubzero table name in the database carries a prefix — `jos_` on a
default install, whatever `dbprefix` says on yours. Code never writes that
prefix. It writes `#__`, and the driver substitutes the configured value as
the statement goes out:

```php
		return $connectors;
	}

	/**
	 * Replaces a string placeholder with the string held in the class variable
	 *
	 * @param   string  $sql     The SQL statement to prepare
	 * @param   string  $prefix  The common table prefix
	 * @return  string
	 * @since   2.0.0
	 */
	public function replacePrefix($sql, $prefix = '#__')
	{
		// As we replace strings of different lengths, subsequent prefix positions will become invalid.
		// Thus, we track that differential here to account for the shifting locations
```

So `#__users` in a query is `jos_users` in the database, and a query with a
literal `jos_` in it is a bug: it breaks on any hub whose prefix differs.
It will not break on yours, which is the problem — the failure arrives on
somebody else's hub as `Table 'theirdb.jos_booking_instruments' doesn't
exist`, naming a prefix they have never used. Copying a working statement
out of a `mysql` prompt and into a model is how it happens; put the `#__`
back on the way in.
The same placeholder is the default table name a model derives for itself —
`#__{namespace}_{plural model name}` — so a `Post` model in the `blog`
namespace reads and writes `#__blog_posts` without being told to.

Translate in your head when you move between a `mysql` prompt and the code:
`SELECT * FROM jos_users` at the prompt is `#__users` in a query.

## Dumping and loading

Muse wraps the two operations you actually need, using the hub's own
credentials so you do not have to find them:

```bash
php core/bin/muse database dump
php core/bin/muse database load <file>
```

`dump` writes to your home directory. See the
[muse database reference](../../reference/muse.md#muse-database).

## From code

Do not open your own connection. The hub's driver is `App::get('db')`, and
above it sit a query builder and an ORM that bind every value they are
given:

```php
$rows = Post::all()
	->whereEquals('state', 1)
	->order('created', 'desc')
	->rows();
```

The [Database](../database.md) book covers all three layers: the
[query builder](../database.md#query-builder), the
[ORM](../database.md#orm), and
[migrations](../database.md#migrations) for schema changes. Schema
changes belong in a migration, not in a `mysql` prompt — a change made by
hand is a change the next hub to run the migrations will not have.
