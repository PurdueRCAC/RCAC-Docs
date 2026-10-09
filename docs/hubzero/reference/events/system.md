---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/system.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('system.*') call sites and core/plugins/system/
---

# System events

Events in the `system` group. A plugin in `core/plugins/system/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `system.onAfterDispatch` { #system-onafterdispatch }

Fired from:

- [`core/bootstrap/Administrator/Providers/ComponentServiceProvider.php:54`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Administrator/Providers/ComponentServiceProvider.php#L54)
- [`core/bootstrap/Site/Providers/ComponentServiceProvider.php:54`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Site/Providers/ComponentServiceProvider.php#L54)
- [`core/libraries/Hubzero/Api/ComponentServiceProvider.php:58`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Api/ComponentServiceProvider.php#L58)

Listeners:

- `plg_system_debug` — [`onAfterDispatch()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/debug/debug.php)
- `plg_system_highlight` — [`onAfterDispatch()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/highlight/highlight.php)
- `plg_system_languagefilter` — [`onAfterDispatch()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagefilter/languagefilter.php)
- `plg_system_mobile` — [`onAfterDispatch()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/mobile/mobile.php)

## `system.onAfterInitialise` { #system-onafterinitialise }

Fired from:

- [`core/libraries/Hubzero/Base/Application.php:516`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Base/Application.php#L516)

Listeners:

- `plg_system_cache` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/cache/cache.php)
- `plg_system_csp` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/csp/csp.php)
- `plg_system_hubzero` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/hubzero/hubzero.php)
- `plg_system_languagefilter` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagefilter/languagefilter.php)
- `plg_system_p3p` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/p3p/p3p.php)
- `plg_system_referrerpolicy` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/referrerpolicy/referrerpolicy.php)
- `plg_system_remember` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/remember/remember.php)
- `plg_system_supergroup` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/supergroup/supergroup.php)
- `plg_system_xfeed` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/xfeed/xfeed.php)

## `system.onAfterRender` { #system-onafterrender }

Fired from:

- [`core/bootstrap/Administrator/Providers/DocumentServiceProvider.php:128`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Administrator/Providers/DocumentServiceProvider.php#L128)
- [`core/bootstrap/Site/Providers/DocumentServiceProvider.php:152`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Site/Providers/DocumentServiceProvider.php#L152)

Listeners:

- `plg_system_cache` — [`onAfterRender()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/cache/cache.php)
- `plg_system_languagecode` — [`onAfterRender()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagecode/languagecode.php)
- `plg_system_sef` — [`onAfterRender()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/sef/sef.php)

## `system.onAfterRoute` { #system-onafterroute }

Fired from:

- [`core/bootstrap/Administrator/Providers/RouterServiceProvider.php:73`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Administrator/Providers/RouterServiceProvider.php#L73)
- [`core/bootstrap/Api/Providers/RouterServiceProvider.php:50`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Api/Providers/RouterServiceProvider.php#L50)
- [`core/bootstrap/Site/Providers/RouterServiceProvider.php:73`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Site/Providers/RouterServiceProvider.php#L73)

Listeners:

- `plg_system_authfactors` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/authfactors/authfactors.php)
- `plg_system_certificate` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/certificate/certificate.php)
- `plg_system_incomplete` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/incomplete/incomplete.php)
- `plg_system_jquery` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/jquery/jquery.php)
- `plg_system_memberhome` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/memberhome/memberhome.php)
- `plg_system_password` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/password/password.php)
- `plg_system_spamjail` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/spamjail/spamjail.php)
- `plg_system_unapproved` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/unapproved/unapproved.php)
- `plg_system_unconfirmed` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/unconfirmed/unconfirmed.php)
- `plg_system_userconsent` — [`onAfterRoute()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/userconsent/userconsent.php)

## `system.onBeforeRender` { #system-onbeforerender }

Fired from:

- [`core/bootstrap/Administrator/Providers/DocumentServiceProvider.php:124`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Administrator/Providers/DocumentServiceProvider.php#L124)
- [`core/bootstrap/Site/Providers/DocumentServiceProvider.php:148`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Site/Providers/DocumentServiceProvider.php#L148)

No plugin in the source tree listens for this event.

## `system.onBeforeRenderSuperGroupComponent` { #system-onbeforerendersupergroupcomponent }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_supergroup` — [`onBeforeRenderSuperGroupComponent()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/supergroup/supergroup.php)

## `system.onBeforeRoute` { #system-onbeforeroute }

Fired from:

- [`core/bootstrap/Administrator/Providers/RouterServiceProvider.php:66`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Administrator/Providers/RouterServiceProvider.php#L66)
- [`core/bootstrap/Api/Providers/RouterServiceProvider.php:43`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Api/Providers/RouterServiceProvider.php#L43)
- [`core/bootstrap/Site/Providers/RouterServiceProvider.php:66`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/bootstrap/Site/Providers/RouterServiceProvider.php#L66)

No plugin in the source tree listens for this event.

## `system.onCleanCache` { #system-oncleancache }

Fired from:

- [`core/components/com_templates/admin/controllers/styles.php:492`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_templates/admin/controllers/styles.php#L492) with `[$group, $client_id]`

Listeners:

- `plg_system_cache` — [`onCleanCache($group = null, $client_id = 0)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/cache/cache.php)

## `system.onContentDestroy` { #system-oncontentdestroy }

Fired from:

- [`core/libraries/Hubzero/Database/Relational.php:1631`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Database/Relational.php#L1631) with `[$this->getTableName(), $this]`

Listeners:

- `plg_system_content` — [`onContentDestroy($table, $model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/content/content.php)

## `system.onContentPrepareForm` { #system-oncontentprepareform }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_languagecode` — [`onContentPrepareForm($form, $data)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagecode/languagecode.php)

## `system.onContentSave` { #system-oncontentsave }

Fired from:

- [`core/components/com_groups/models/orm/applicant.php:124`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/applicant.php#L124) with `[$this->getTableName(), $this]`
- [`core/components/com_groups/models/orm/invitee.php:124`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/invitee.php#L124) with `[$this->getTableName(), $this]`
- [`core/components/com_groups/models/orm/manager.php:124`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/manager.php#L124) with `[$this->getTableName(), $this]`
- [`core/components/com_groups/models/orm/member.php:124`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/member.php#L124) with `[$this->getTableName(), $this]`
- [`core/components/com_modules/models/menu.php:71`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_modules/models/menu.php#L71) with `[$this->getTableName(), $this]`
- [`core/libraries/Hubzero/Database/Relational.php:1451`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Database/Relational.php#L1451) with `[$this->getTableName(), $this]`
- [`core/libraries/Hubzero/Database/Table.php:582`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Database/Table.php#L582) with `[$this->getTableName(), $this]`

Listeners:

- `plg_system_content` — [`onContentSave($table, $model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/content/content.php)

## `system.onUserAfterSave` { #system-onuseraftersave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_languagefilter` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagefilter/languagefilter.php)

## `system.onUserBeforeSave` { #system-onuserbeforesave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_languagefilter` — [`onUserBeforeSave($user, $isnew, $new)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagefilter/languagefilter.php)

## `system.onUserLogin` { #system-onuserlogin }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_languagefilter` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/languagefilter/languagefilter.php)

## `system.onUserLoginFailure` { #system-onuserloginfailure }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_hubzero` — [`onUserLoginFailure($response)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/hubzero/hubzero.php)
- `plg_system_log` — [`onUserLoginFailure($response)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/log/log.php)

## `system.onUserLogout` { #system-onuserlogout }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_system_logout` — [`onUserLogout($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/system/logout/logout.php)
