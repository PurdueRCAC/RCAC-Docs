---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/members.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('members.*') call sites and core/plugins/members/
---

# Members events

Events in the `members` group. A plugin in `core/plugins/members/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `members.onCanManage` { #members-oncanmanage }

Fired from:

- [`core/components/com_members/admin/controllers/plugins.php:180`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/plugins.php#L180)

Listeners:

- `plg_members_dashboard` — [`onCanManage()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/dashboard/dashboard.php)

## `members.onExportMemberData` { #members-onexportmemberdata }

Fired from:

- [`core/components/com_members/admin/controllers/exports.php:349`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/exports.php#L349) with `[$member, $tmp]`

No plugin in the source tree listens for this event.

## `members.onExportMemberKeys` { #members-onexportmemberkeys }

Fired from:

- [`core/components/com_members/admin/controllers/exports.php:116`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/exports.php#L116) with `[$keys]`

No plugin in the source tree listens for this event.

## `members.onManage` { #members-onmanage }

Fired from:

- [`core/components/com_members/admin/controllers/plugins.php:207`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/plugins.php#L207) with `[ $this->_option, $this->_controller, Request::getString('action', 'default') ]`

Listeners:

- `plg_members_dashboard` — [`onManage($option, $controller='plugins', $action='default')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/dashboard/dashboard.php)

## `members.onMemberAfterDelete` { #members-onmemberafterdelete }

Fired from:

- [`core/plugins/user/xusers/xusers.php:644`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php#L644) with `[$user, $success, $msg]`

Listeners:

- `plg_members_blog` — [`onMemberAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/blog/blog.php)
- `plg_members_collections` — [`onMemberAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/collections/collections.php)
- `plg_members_points` — [`onMemberAfterDelete($user, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/points/points.php)

## `members.onMemberAfterSave` { #members-onmemberaftersave }

Fired from:

- [`core/plugins/user/xusers/xusers.php:591`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/user/xusers/xusers.php#L591) with `[$user, $isnew, $success, $msg]`

Listeners:

- `plg_members_blog` — [`onMemberAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/blog/blog.php)
- `plg_members_collections` — [`onMemberAfterSave($user, $isnew, $success, $msg)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/collections/collections.php)

## `members.onMemberProfile` { #members-onmemberprofile }

Fired from:

- [`core/components/com_members/site/views/profiles/tmpl/browse.php:389`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/views/profiles/tmpl/browse.php#L389) with `[$row]`
- [`core/components/com_members/site/views/profiles/tmpl/view.php:82`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/views/profiles/tmpl/view.php#L82) with `[$this->profile]`

No plugin in the source tree listens for this event.

## `members.onMembers` { #members-onmembers }

Fired from:

- [`core/components/com_members/site/controllers/profiles.php:890`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/controllers/profiles.php#L890) with `[User::getInstance(), $profile, $this->_option, array($tab)]`

Listeners:

- `plg_members_account` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/account/account.php)
- `plg_members_activity` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/activity/activity.php)
- `plg_members_blog` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/blog/blog.php)
- `plg_members_citations` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/citations/citations.php)
- `plg_members_collections` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/collections/collections.php)
- `plg_members_contributions` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/contributions/contributions.php)
- `plg_members_courses` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/courses/courses.php)
- `plg_members_dashboard` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/dashboard/dashboard.php)
- `plg_members_groups` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/groups/groups.php)
- `plg_members_impact` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/impact/impact.php)
- `plg_members_messages` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/messages/messages.php)
- `plg_members_points` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/points/points.php)
- `plg_members_profile` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/profile/profile.php)
- `plg_members_projects` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/projects/projects.php)
- `plg_members_resume` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/resume/resume.php)
- `plg_members_todo` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/todo/todo.php)
- `plg_members_usage` — [`onMembers($user, $member, $option, $areas)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/usage/usage.php)

## `members.onMembersAreas` { #members-onmembersareas }

Fired from:

- [`core/components/com_members/site/controllers/profiles.php:869`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/controllers/profiles.php#L869) with `[User::getInstance(), $profile]`

Listeners:

- `plg_members_collections` — [`onMembersAreas($user, $member)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/collections/collections.php)
- `plg_members_dashboard` — [`onMembersAreas($user, $member)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/dashboard/dashboard.php)

## `members.onMembersContributions` { #members-onmemberscontributions }

Fired from:

- [`core/plugins/members/contributions/contributions.php:107`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/contributions/contributions.php#L107) with `[ $member, $option, 0, $limitstart, $sort, $activeareas ]`
- [`core/plugins/members/contributions/contributions.php:167`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/contributions/contributions.php#L167) with `[ $member, $option, $limit, $limitstart, $sort, $activeareas]`

Listeners:

- `plg_members_courses` — [`onMembersContributions($member, $option, $limit, $limitstart, $sort, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/courses/courses.php)
- `plg_members_impact` — [`onMembersContributions($member, $option, $limit, $limitstart, $sort, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/impact/impact.php)
- `plg_members_publications` — [`onMembersContributions($member, $option, $limit, $limitstart, $sort, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/publications/publications.php)
- `plg_members_resources` — [`onMembersContributions($member, $option, $limit, $limitstart, $sort, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/resources/resources.php)
- `plg_members_wiki` — [`onMembersContributions($member, $option, $limit, $limitstart, $sort, $areas=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/wiki/wiki.php)

## `members.onMembersContributionsAreas` { #members-onmemberscontributionsareas }

Fired from:

- [`core/plugins/members/contributions/contributions.php:82`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/contributions/contributions.php#L82) with `[]`

Listeners:

- `plg_members_courses` — [`onMembersContributionsAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/courses/courses.php)
- `plg_members_publications` — [`onMembersContributionsAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/publications/publications.php)
- `plg_members_resources` — [`onMembersContributionsAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/resources/resources.php)

## `members.onMembersContributionsCount` { #members-onmemberscontributionscount }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_members_courses` — [`onMembersContributionsCount($user_id='m.uidNumber', $username='m.username')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/courses/courses.php)
- `plg_members_impact` — [`onMembersContributionsCount($user_id='m.uidNumber', $username='m.username')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/impact/impact.php)
- `plg_members_publications` — [`onMembersContributionsCount($user_id='m.uidNumber', $username='m.username')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/publications/publications.php)
- `plg_members_resources` — [`onMembersContributionsCount($user_id='m.uidNumber', $username='m.username')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/resources/resources.php)
- `plg_members_wiki` — [`onMembersContributionsCount($user_id='m.uidNumber', $username='m.username')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/wiki/wiki.php)

## `members.onMembersShortlist` { #members-onmembersshortlist }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_members_resume` — [`onMembersShortlist()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/resume/resume.php)

## `members.onUserEdit` { #members-onuseredit }

Fired from:

- [`core/components/com_members/admin/controllers/members.php:329`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/members.php#L329) with `[$user]`

No plugin in the source tree listens for this event.
