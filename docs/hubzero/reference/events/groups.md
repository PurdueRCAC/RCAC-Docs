---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/groups.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('groups.*') call sites and core/plugins/groups/
---

# Groups events

Events in the `groups` group. A plugin in `core/plugins/groups/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `groups.onAfterStoreGroup` { #groups-onafterstoregroup }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_groups_projects` — [`onAfterStoreGroup($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/projects.php)

## `groups.onBeforeGroup` { #groups-onbeforegroup }

Fired from:

- [`core/components/com_groups/helpers/view.php:116`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/helpers/view.php#L116) with `[ $group, $authorized ]`

Listeners:

- `plg_groups_announcements` — [`onBeforeGroup($group, $authorized)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)

## `groups.onGroup` { #groups-ongroup }

Fired from:

- [`core/components/com_groups/helpers/view.php:155`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/helpers/view.php#L155) with `[ $group, 'com_groups', $authorized, $limit, $start, $action, $pluginAccess, array($tab) ]`

Listeners:

- `plg_groups_activity` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/activity/activity.php)
- `plg_groups_announcements` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)
- `plg_groups_blog` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/blog/blog.php)
- `plg_groups_calendar` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/calendar/calendar.php)
- `plg_groups_citations` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/citations/citations.php)
- `plg_groups_collections` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/collections/collections.php)
- `plg_groups_courses` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/courses/courses.php)
- `plg_groups_files` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/files/files.php)
- `plg_groups_forum` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/forum/forum.php)
- `plg_groups_memberoptions` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/memberoptions/memberoptions.php)
- `plg_groups_members` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/members/members.php)
- `plg_groups_messages` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/messages/messages.php)
- `plg_groups_projects` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/projects.php)
- `plg_groups_resources` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/resources/resources.php)
- `plg_groups_usage` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/usage/usage.php)
- `plg_groups_wiki` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/wiki/wiki.php)
- `plg_groups_wishlist` — [`onGroup($group, $option, $authorized, $limit, $limitstart, $action, $access, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/wishlist/wishlist.php)

## `groups.onGroupAfterSave` { #groups-ongroupaftersave }

Fired from:

- [`core/components/com_groups/admin/controllers/manage.php:450`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/admin/controllers/manage.php#L450) with `[$before, $group]`
- [`core/components/com_groups/admin/controllers/manage.php:1258`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/admin/controllers/manage.php#L1258) with `[$before, $group]`
- [`core/components/com_groups/site/controllers/groups.php:812`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/controllers/groups.php#L812) with `[$before, $group]`

Listeners:

- `plg_groups_projects` — [`onGroupAfterSave($before, $after)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/projects.php)
- `plg_groups_search` — [`onGroupAfterSave($before, $group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/search/search.php)

## `groups.onGroupAreas` { #groups-ongroupareas }

Fired from:

- [`core/components/com_groups/api/controllers/groupsv1_0.php:353`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/groupsv1_0.php#L353) with `[]`
- [`core/components/com_groups/api/controllers/groupsv1_1.php:344`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/groupsv1_1.php#L344)
- [`core/components/com_groups/api/controllers/groupsv1_1.php:365`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/groupsv1_1.php#L365) with `[]`
- [`core/components/com_groups/helpers/view.php:87`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/helpers/view.php#L87) with `[]`
- [`core/components/com_groups/site/controllers/groups.php:533`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/controllers/groups.php#L533) with `[]`
- [`core/components/com_groups/site/views/emails/tmpl/saved.php:355`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/views/emails/tmpl/saved.php#L355) with `[]`
- [`core/components/com_groups/site/views/emails/tmpl/saved_plain.php:123`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/views/emails/tmpl/saved_plain.php#L123) with `[]`
- [`core/libraries/Hubzero/User/Group/Helper.php:283`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group/Helper.php#L283) with `[]`

No plugin in the source tree listens for this event.

## `groups.onGroupClassroomprojects` { #groups-ongroupclassroomprojects }

Fired from:

- [`core/plugins/groups/projects/views/browse/tmpl/default.php:59`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/views/browse/tmpl/default.php#L59) with `[$this->group]`

No plugin in the source tree listens for this event.

## `groups.onGroupDelete` { #groups-ongroupdelete }

Fired from:

- [`core/components/com_groups/admin/controllers/manage.php:1151`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/admin/controllers/manage.php#L1151) with `[$group]`
- [`core/components/com_groups/site/controllers/groups.php:1147`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/controllers/groups.php#L1147) with `[$group]`

Listeners:

- `plg_groups_blog` — [`onGroupDelete($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/blog/blog.php)
- `plg_groups_collections` — [`onGroupDelete($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/collections/collections.php)
- `plg_groups_forum` — [`onGroupDelete($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/forum/forum.php)
- `plg_groups_resources` — [`onGroupDelete($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/resources/resources.php)
- `plg_groups_wiki` — [`onGroupDelete($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/wiki/wiki.php)
- `plg_groups_wishlist` — [`onGroupDelete($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/wishlist/wishlist.php)

## `groups.onGroupDeleteCount` { #groups-ongroupdeletecount }

Fired from:

- [`core/components/com_groups/site/controllers/groups.php:1056`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/controllers/groups.php#L1056) with `[$this->view->group]`

Listeners:

- `plg_groups_blog` — [`onGroupDeleteCount($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/blog/blog.php)
- `plg_groups_collections` — [`onGroupDeleteCount($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/collections/collections.php)
- `plg_groups_resources` — [`onGroupDeleteCount($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/resources/resources.php)
- `plg_groups_wiki` — [`onGroupDeleteCount($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/wiki/wiki.php)
- `plg_groups_wishlist` — [`onGroupDeleteCount($group)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/wishlist/wishlist.php)

## `groups.onGroupMemberAfter` { #groups-ongroupmemberafter }

Fired from:

- [`core/plugins/groups/members/views/profile/tmpl/default.php:207`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/members/views/profile/tmpl/default.php#L207) with `[$this->group, $this->profile]`

Listeners:

- `plg_groups_citations` — [`onGroupMemberAfter($group, $profile)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/citations/citations.php)

## `groups.onGroupMemberBefore` { #groups-ongroupmemberbefore }

Fired from:

- [`core/plugins/groups/members/views/profile/tmpl/default.php:79`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/members/views/profile/tmpl/default.php#L79) with `[$this->group, $this->profile]`

No plugin in the source tree listens for this event.

## `groups.onGroupNew` { #groups-ongroupnew }

Fired from:

- [`core/components/com_groups/site/controllers/groups.php:830`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/controllers/groups.php#L830) with `[$group]`

No plugin in the source tree listens for this event.

## `groups.onGroupProjects` { #groups-ongroupprojects }

Fired from:

- [`core/plugins/groups/projects/views/partials/tmpl/submenu.php:11`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/views/partials/tmpl/submenu.php#L11) with `[$this->group]`

No plugin in the source tree listens for this event.

## `groups.onGroupUserEnrollment` { #groups-ongroupuserenrollment }

Fired from:

- [`core/components/com_groups/models/orm/group.php:452`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/models/orm/group.php#L452) with `[$this->get('gidNumber'), $userid]`
- [`core/libraries/Hubzero/User/Group.php:660`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group.php#L660) with `[$this->gidNumber, $userid]`

Listeners:

- `plg_groups_memberoptions` — [`onGroupUserEnrollment($gidNumber, $userid)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/memberoptions/memberoptions.php)

## `groups.onGroupUserRevocation` { #groups-ongroupuserrevocation }

Fired from:

- [`core/libraries/Hubzero/User/Group/Membership.php:651`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/User/Group/Membership.php#L651) with `[$gid, $uid, $reason]`

No plugin in the source tree listens for this event.

## `groups.onGroupsApiCreate` { #groups-ongroupsapicreate }

Fired from:

- [`core/components/com_groups/api/controllers/pluginsv1_0.php:172`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/pluginsv1_0.php#L172) with `[ $group, $active ]`

Listeners:

- `plg_groups_announcements` — [`onGroupsApiCreate($group, $active)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)

## `groups.onGroupsApiDelete` { #groups-ongroupsapidelete }

Fired from:

- [`core/components/com_groups/api/controllers/pluginsv1_0.php:438`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/pluginsv1_0.php#L438) with `[ $group, $active, $id ]`

Listeners:

- `plg_groups_announcements` — [`onGroupsApiDelete($group, $active, $id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)

## `groups.onGroupsApiList` { #groups-ongroupsapilist }

Fired from:

- [`core/components/com_groups/api/controllers/pluginsv1_0.php:97`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/pluginsv1_0.php#L97) with `[ $group, $active, $filters['start'], $filters['limit'] ]`

Listeners:

- `plg_groups_announcements` — [`onGroupsApiList($group, $active, $start, $limit)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)

## `groups.onGroupsApiRead` { #groups-ongroupsapiread }

Fired from:

- [`core/components/com_groups/api/controllers/pluginsv1_0.php:260`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/pluginsv1_0.php#L260) with `[ $group, $active, $id ]`

Listeners:

- `plg_groups_announcements` — [`onGroupsApiRead($group, $active, $id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)

## `groups.onGroupsApiUpdate` { #groups-ongroupsapiupdate }

Fired from:

- [`core/components/com_groups/api/controllers/pluginsv1_0.php:349`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/api/controllers/pluginsv1_0.php#L349) with `[ $group, $active, $id ]`

Listeners:

- `plg_groups_announcements` — [`onGroupsApiUpdate($group, $active, $id)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/announcements/announcements.php)
