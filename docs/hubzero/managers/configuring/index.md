---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/managers/05-configuring/README.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: rewritten
  reviewed-against: 2.4-main @ 35f103b1b3
  reviewed: '2026-09-10'
  screenshots: none
  source: https://help.hubzero.org/documentation/240/managers/configuring
---

# Configuring

Almost everything about a hub is set from the administrator interface. This
section covers the four places settings live: the global configuration that
applies to the whole site, the options attached to each component, the
parameters on each module instance, and the parameters on each plugin.

## This section, and the one it is confused with

This section is about **values**. What is the hub called, which address does
its mail come from, how long does a session last, what does the registration
form ask for, how many items does a module list.

[Extensions](../extensions/index.md) is about **which extensions exist
and where they sit**: creating a module and putting it in a template position,
enabling and disabling a plugin, choosing the site's template, adding a hub's
own code from a git repository.

The two meet on the same screens. The Module Manager both creates a module and
holds its parameters; the Plug-in Manager both enables a plugin and holds its
parameters. Where that happens, the chapter here covers the parameters and the
chapter there covers everything else, and each links to the other rather than
repeating it.

## Where settings live

| Setting | Where you edit it |
|---|---|
| Site-wide settings — site name, mail, sessions, caching, SEO, permissions | **Site > Global Configuration**. See [Global configuration](hub.md). |
| One component's options | The **Options** button in that component's toolbar. See [Components](components.md). |
| One module instance's parameters | **Extensions > Module Manager**, then the module. See [Modules](modules.md). |
| One plugin's parameters | **Extensions > Plug-in Manager**, then the plugin. See [Plugins](plugins.md). |
| Which fields a new member must fill in | **Users > Members > Registration**. See [Registration](registration.md). |
| How people sign in | **Extensions > Plug-in Manager**, filtered to the `authentication` type. See [Authentication](authentication.md) and [External authenticators](extauth.md). |

## Which of these you will actually open

Most hubs settle the global configuration once, during installation, and come
back to it perhaps twice a year — to take the site down for maintenance, to
change the address mail goes out under, or to hand a new group of staff
administrator access.

Component options are the ones you open regularly, because that is where a
component's behaviour lives. Registration and the authentication plugins
matter to any hub that opens itself to people outside the group that built
it. Module and plugin parameters you open when something on a page shows the
wrong thing.

!!! warning
    Global configuration is the only screen in this section that
    can take the hub off the air. [Global
    configuration](hub.md#what-is-safe-to-change-and-what-is-not) says which
    settings do that before it describes any of them.

## In this section

- [Global configuration](hub.md)
- [Registration](registration.md)
- [Components](components.md)
- [Modules](modules.md)
- [Plugins](plugins.md)
- [Authentication](authentication.md)
- [External authenticators](extauth.md)

Every parameter that any component or plugin manifest declares is listed in
the generated [configuration reference](../../reference/configuration/index.md).
These chapters explain the screens; the reference is the exhaustive list.
