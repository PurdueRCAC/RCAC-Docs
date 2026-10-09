---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/user.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('user.*') call sites and core/plugins/user/
---

# User events

Events in the `user` group. A plugin in `core/plugins/user/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `user.onAfterDeleteGroup` { #user-onafterdeletegroup }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_user_ldap` — [`onAfterDeleteGroup($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)

## `user.onAfterDeletePassword` { #user-onafterdeletepassword }

Fired from:

- [`core/libraries/Hubzero/User/Password.php:371`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Password.php#L371) with `[$this]`

Listeners:

- `plg_user_ldap` — [`onAfterDeletePassword($user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)

## `user.onAfterDeleteProfile` { #user-onafterdeleteprofile }

Fired from:

- [`core/libraries/Hubzero/User/Profile.php:1055`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Profile.php#L1055) with `[$this]`

Listeners:

- `plg_user_constantcontact` — [`onAfterDeleteProfile($user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/constantcontact/constantcontact.php)
- `plg_user_ldap` — [`onAfterDeleteProfile($user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)

## `user.onAfterDeleteUser` { #user-onafterdeleteuser }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_user_d1` — [`onAfterDeleteUser($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/d1/d1.php)
- `plg_user_ldap` — [`onAfterDeleteUser($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)
- `plg_user_us` — [`onAfterDeleteUser($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/us/us.php)
- `plg_user_xusers` — [`onAfterDeleteUser($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onAfterStoreGroup` { #user-onafterstoregroup }

Fired from:

- [`core/components/com_groups/models/orm/group.php:585`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/group.php#L585) with `[$this]`
- [`core/components/com_groups/models/orm/group.php:673`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/group.php#L673) with `[$this]`
- [`core/libraries/Hubzero/User/Group.php:349`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group.php#L349) with `[$this]`
- [`core/libraries/Hubzero/User/Group.php:665`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group.php#L665) with `[$this]`
- [`core/libraries/Hubzero/User/Group.php:722`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group.php#L722) with `[$this]`
- [`core/libraries/Hubzero/User/Group/Membership.php:1140`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group/Membership.php#L1140) with `[$group]`

Listeners:

- `plg_user_ldap` — [`onAfterStoreGroup($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)

## `user.onAfterStorePassword` { #user-onafterstorepassword }

Fired from:

- [`core/libraries/Hubzero/User/Password.php:323`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Password.php#L323) with `[$this]`

Listeners:

- `plg_user_ldap` — [`onAfterStorePassword($user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)

## `user.onAfterStoreProfile` { #user-onafterstoreprofile }

Fired from:

- [`core/components/com_members/admin/controllers/hosts.php:66`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/hosts.php#L66) with `[$profile]`
- [`core/components/com_members/admin/controllers/hosts.php:114`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/hosts.php#L114) with `[$profile]`
- [`core/libraries/Hubzero/User/Profile.php:994`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Profile.php#L994) with `[$this]`

Listeners:

- `plg_user_constantcontact` — [`onAfterStoreProfile($user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/constantcontact/constantcontact.php)
- `plg_user_ldap` — [`onAfterStoreProfile($user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)

## `user.onAfterStoreUser` { #user-onafterstoreuser }

Fired from:

- [`core/plugins/members/account/account.php:597`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/account/account.php#L597) with `[$this->user->toArray(), false, null, $this->getError()]`

Listeners:

- `plg_user_ldap` — [`onAfterStoreUser($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)
- `plg_user_xusers` — [`onAfterStoreUser($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onBeforeStoreUser` { #user-onbeforestoreuser }

Fired from:

- [`core/plugins/members/account/account.php:535`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/account/account.php#L535) with `[$this->user->toArray(), false]`

No plugin in the source tree listens for this event.

## `user.onLoginUser` { #user-onloginuser }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_user_autoapprove` — [`onLoginUser($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/autoapprove/autoapprove.php)
- `plg_user_d1` — [`onLoginUser($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/d1/d1.php)
- `plg_user_us` — [`onLoginUser($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/us/us.php)
- `plg_user_xusers` — [`onLoginUser($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onLogoutUser` { #user-onlogoutuser }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_user_xusers` — [`onLogoutUser($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onUserAfterDelete` { #user-onuserafterdelete }

Fired from:

- [`core/components/com_members/admin/controllers/members.php:787`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/members.php#L787) with `[$data, true, $this->getError()]`
- [`core/components/com_members/models/member.php:518`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/models/member.php#L518) with `[$data, true, $this->getError()]`
- [`core/libraries/Hubzero/User/User.php:1021`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/User.php#L1021) with `[$data, true, $this->getError()]`

Listeners:

- `plg_user_d1` — [`onUserAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/d1/d1.php)
- `plg_user_geo` — [`onUserAfterDelete($user, $succes, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/geo/geo.php)
- `plg_user_hubzero` — [`onUserAfterDelete($user, $succes, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/hubzero/hubzero.php)
- `plg_user_ldap` — [`onUserAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)
- `plg_user_middleware` — [`onUserAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/middleware/middleware.php)
- `plg_user_us` — [`onUserAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/us/us.php)
- `plg_user_xusers` — [`onUserAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onUserAfterDeleteGroup` { #user-onuserafterdeletegroup }

Fired from:

- [`core/components/com_members/admin/controllers/accessgroups.php:309`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/accessgroups.php#L309) with `[$data, true, $this->getError()]`

No plugin in the source tree listens for this event.

## `user.onUserAfterSave` { #user-onuseraftersave }

Fired from:

- [`core/components/com_cart/lib/handlers/type/Access_Group_Membership_Type_Handler.php:61`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/lib/handlers/type/Access_Group_Membership_Type_Handler.php#L61) with `[$table->toArray(), false, true, null]`
- [`core/components/com_cart/site/controllers/test.php:197`](https://github.com/hubzero/hubzero-cms/tree/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/site/controllers) with `[$table->toArray(), false, true, null]`
- [`core/libraries/Hubzero/User/User.php:968`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/User.php#L968) with `[$data, $isNew, $result, $this->getError()]`

Listeners:

- `plg_user_autoapprove` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/autoapprove/autoapprove.php)
- `plg_user_domainrestriction` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/domainrestriction/domainrestriction.php)
- `plg_user_hubzero` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/hubzero/hubzero.php)
- `plg_user_ldap` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)
- `plg_user_middleware` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/middleware/middleware.php)
- `plg_user_xusers` — [`onUserAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onUserAfterSaveProfile` { #user-onuseraftersaveprofile }

Fired from:

- [`core/components/com_members/models/member.php:464`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/models/member.php#L464) with `[$user, $profile, $access]`

No plugin in the source tree listens for this event.

## `user.onUserAuthorisation` { #user-onuserauthorisation }

Fired from:

- [`core/libraries/Hubzero/Auth/Guard.php:282`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Auth/Guard.php#L282) with `[$response, $options]`

No plugin in the source tree listens for this event.

## `user.onUserAuthorisationFailure` { #user-onuserauthorisationfailure }

Fired from:

- [`core/libraries/Hubzero/Auth/Manager.php:76`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Auth/Manager.php#L76) with `[(array) $authorisation]`

No plugin in the source tree listens for this event.

## `user.onUserBeforeDelete` { #user-onuserbeforedelete }

Fired from:

- [`core/components/com_members/models/member.php:478`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/models/member.php#L478) with `[$data]`
- [`core/libraries/Hubzero/User/User.php:992`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/User.php#L992) with `[$data]`

No plugin in the source tree listens for this event.

## `user.onUserBeforeDeleteGroup` { #user-onuserbeforedeletegroup }

Fired from:

- [`core/components/com_members/admin/controllers/accessgroups.php:299`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/accessgroups.php#L299) with `[$data]`

No plugin in the source tree listens for this event.

## `user.onUserBeforeSave` { #user-onuserbeforesave }

Fired from:

- [`core/libraries/Hubzero/User/User.php:930`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/User.php#L930) with `[$oldUser->toArray(), $isNew, $data]`

Listeners:

- `plg_user_domainrestriction` — [`onUserBeforeSave($user, $isNew, $new)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/domainrestriction/domainrestriction.php)

## `user.onUserBeforeSaveProfile` { #user-onuserbeforesaveprofile }

Fired from:

- [`core/components/com_members/models/member.php:286`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/models/member.php#L286) with `[$user, $profile, $access]`

No plugin in the source tree listens for this event.

## `user.onUserDeidentify` { #user-onuserdeidentify }

Fired from:

- [`core/components/com_members/admin/controllers/members.php:1053`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/members.php#L1053) with `$id`

Listeners:

- `plg_user_hubzero` — [`onUserDeidentify($user_id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/hubzero/hubzero.php)
- `plg_user_ldap` — [`onUserDeidentify($user_id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/ldap/ldap.php)
- `plg_user_middleware` — [`onUserDeidentify($user_id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/middleware/middleware.php)

## `user.onUserLogin` { #user-onuserlogin }

Fired from:

- [`core/libraries/Hubzero/Auth/Manager.php:101`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Auth/Manager.php#L101) with `[(array) $response, $options]`
- [`core/libraries/Hubzero/User/User.php:551`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/User.php#L551) with `[$data]`

Listeners:

- `plg_user_autoapprove` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/autoapprove/autoapprove.php)
- `plg_user_d1` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/d1/d1.php)
- `plg_user_domainrestriction` — [`onUserLogin($user, $options)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/domainrestriction/domainrestriction.php)
- `plg_user_geo` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/geo/geo.php)
- `plg_user_hubzero` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/hubzero/hubzero.php)
- `plg_user_us` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/us/us.php)
- `plg_user_xusers` — [`onUserLogin($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onUserLoginFailure` { #user-onuserloginfailure }

Fired from:

- [`core/libraries/Hubzero/Auth/Manager.php:137`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Auth/Manager.php#L137) with `[(array) $response]`

Listeners:

- `plg_user_xusers` — [`onUserLoginFailure($response)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onUserLogout` { #user-onuserlogout }

Fired from:

- [`core/components/com_login/site/controllers/auth.php:906`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_login/site/controllers/auth.php#L906) with `[$parameters, $options]`
- [`core/components/com_users/site/controllers/auth.php:926`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_users/site/controllers/auth.php#L926) with `[$parameters, $options]`
- [`core/libraries/Hubzero/Auth/Manager.php:177`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Auth/Manager.php#L177) with `[$parameters, $options]`

Listeners:

- `plg_user_hubzero` — [`onUserLogout($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/hubzero/hubzero.php)
- `plg_user_xusers` — [`onUserLogout($user, $options = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php)

## `user.onUserLogoutFailure` { #user-onuserlogoutfailure }

Fired from:

- [`core/components/com_login/site/controllers/auth.php:919`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_login/site/controllers/auth.php#L919) with `[$parameters]`
- [`core/components/com_users/site/controllers/auth.php:939`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_users/site/controllers/auth.php#L939) with `[$parameters]`
- [`core/libraries/Hubzero/Auth/Manager.php:192`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Auth/Manager.php#L192) with `[$parameters]`

No plugin in the source tree listens for this event.
