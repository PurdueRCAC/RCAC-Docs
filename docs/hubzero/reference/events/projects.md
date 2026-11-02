---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/projects.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('projects.*') call sites and core/plugins/projects/
---

# Projects events

Events in the `projects` group. A plugin in `core/plugins/projects/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `projects.onAfterChangeState` { #projects-onafterchangestate }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_projects_publications` — [`onAfterChangeState($pub, $originalStatus = 3)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php)

## `projects.onAfterCreate` { #projects-onaftercreate }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_projects_publications` — [`onAfterCreate($pub)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php)

## `projects.onAfterInitialise` { #projects-onafterinitialise }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_projects_databases` — [`onAfterInitialise()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/databases/databases.php)

## `projects.onAfterSave` { #projects-onaftersave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_projects_publications` — [`onAfterSave($pub)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php)

## `projects.onAfterUpdate` { #projects-onafterupdate }

Fired from:

- [`core/components/com_projects/api/controllers/filefsv1_0.php:877`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filefsv1_0.php#L877) with `$plugin_params`
- [`core/components/com_projects/api/controllers/filesv1_0.php:1098`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filesv1_0.php#L1098) with `$plugin_params`

Listeners:

- `plg_projects_files` — [`onAfterUpdate($model = null, $changes = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/files.php)

## `projects.onProject` { #projects-onproject }

Fired from:

- [`core/components/com_projects/site/controllers/projects.php:657`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/projects.php#L657) with `$plugin_params`
- [`core/components/com_projects/site/controllers/setup.php:948`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/setup.php#L948) with `[ $this->model, 'save', array('team') ]`
- [`core/components/com_projects/site/controllers/setup.php:1048`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/setup.php#L1048) with `[ $this->model, $this->_task, array('team') ]`
- [`core/components/com_publications/site/controllers/publications.php:1546`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_publications/site/controllers/publications.php#L1546) with `$plugin_params`
- [`core/plugins/cron/projects/projects.php:144`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cron/projects/projects.php#L144) with `$plugin_params`

Listeners:

- `plg_projects_databases` — [`onProject($model, $action = 'view', $areas = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/databases/databases.php)
- `plg_projects_feed` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php)
- `plg_projects_files` — [`onProject($model, $action = '', $areas = null, $params = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/files.php)
- `plg_projects_hipaacompliant` — [`onProject($model, $action = '', $areas = NULL)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/hipaacompliant/hipaacompliant.php)
- `plg_projects_info` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/info/info.php)
- `plg_projects_links` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/links/links.php)
- `plg_projects_notes` — [`onProject($model, $action = '', $areas = null, $tool = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/notes/notes.php)
- `plg_projects_publications` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php)
- `plg_projects_team` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/team/team.php)
- `plg_projects_todo` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/todo/todo.php)
- `plg_projects_watch` — [`onProject($model, $action = '', $areas = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/watch/watch.php)

## `projects.onProjectAfterDelete` { #projects-onprojectafterdelete }

Fired from:

- [`core/components/com_projects/models/orm/project.php:532`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/models/orm/project.php#L532) with `[$data]`

No plugin in the source tree listens for this event.

## `projects.onProjectAfterDeleteActivity` { #projects-onprojectafterdeleteactivity }

Fired from:

- [`core/components/com_projects/admin/controllers/activity.php:309`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/activity.php#L309) with `[$id]`

No plugin in the source tree listens for this event.

## `projects.onProjectAfterSave` { #projects-onprojectaftersave }

Fired from:

- [`core/components/com_projects/admin/controllers/projects.php:543`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L543) with `[$this->model]`
- [`core/components/com_projects/admin/controllers/projects.php:724`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L724) with `[$model]`
- [`core/components/com_projects/admin/controllers/projects.php:782`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L782) with `[$model]`
- [`core/components/com_projects/admin/controllers/projects.php:842`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L842) with `[$model]`
- [`core/components/com_projects/admin/controllers/projects.php:899`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L899) with `[$model]`
- [`core/components/com_projects/api/controllers/projectsv2_0.php:588`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/projectsv2_0.php#L588) with `[&$row, $isNew]`
- [`core/components/com_projects/api/controllers/projectsv2_0.php:1100`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/projectsv2_0.php#L1100) with `[&$row, $isNew]`
- [`core/components/com_projects/site/controllers/setup.php:351`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/setup.php#L351) with `[$this->model]`
- [`core/plugins/groups/projects/projects.php:288`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/projects.php#L288) with `[$model]`

No plugin in the source tree listens for this event.

## `projects.onProjectAfterSaveActivity` { #projects-onprojectaftersaveactivity }

Fired from:

- [`core/components/com_projects/admin/controllers/activity.php:261`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/activity.php#L261) with `[&$recipient, $isNew]`
- [`core/components/com_projects/admin/controllers/activity.php:424`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/activity.php#L424) with `[$entry]`

No plugin in the source tree listens for this event.

## `projects.onProjectAreas` { #projects-onprojectareas }

Fired from:

- [`core/components/com_projects/site/controllers/projects.php:614`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/projects.php#L614) with `[$this->model->get('alias')]`

No plugin in the source tree listens for this event.

## `projects.onProjectBeforeDelete` { #projects-onprojectbeforedelete }

Fired from:

- [`core/components/com_projects/models/orm/project.php:496`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/models/orm/project.php#L496) with `[$data]`

No plugin in the source tree listens for this event.

## `projects.onProjectBeforeSave` { #projects-onprojectbeforesave }

Fired from:

- [`core/components/com_projects/api/controllers/projectsv2_0.php:571`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/projectsv2_0.php#L571) with `[&$row, $isNew]`
- [`core/components/com_projects/api/controllers/projectsv2_0.php:1087`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/projectsv2_0.php#L1087) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `projects.onProjectBeforeSaveActivity` { #projects-onprojectbeforesaveactivity }

Fired from:

- [`core/components/com_projects/admin/controllers/activity.php:239`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/activity.php#L239) with `[&$recipient, $isNew]`

No plugin in the source tree listens for this event.

## `projects.onProjectCount` { #projects-onprojectcount }

Fired from:

- [`core/components/com_projects/admin/controllers/projects.php:266`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L266) with `[$model, 1]`
- [`core/components/com_projects/site/controllers/projects.php:682`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/projects.php#L682) with `[$this->model]`

Listeners:

- `plg_projects_links` — [`onProjectCount($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/links/links.php)

## `projects.onProjectCreate` { #projects-onprojectcreate }

Fired from:

- [`core/components/com_projects/api/controllers/projectsv2_0.php:672`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/projectsv2_0.php#L672) with `[$row]`
- [`core/components/com_projects/site/controllers/setup.php:611`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/controllers/setup.php#L611) with `[$this->model]`

No plugin in the source tree listens for this event.

## `projects.onProjectExtras` { #projects-onprojectextras }

Fired from:

- [`core/components/com_projects/site/views/projects/tmpl/internal.php:53`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/views/projects/tmpl/internal.php#L53) with `[ $this->model, $this->active ]`

Listeners:

- `plg_projects_feed` — [`onProjectExtras($model, $area)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php)

## `projects.onProjectIntegrationList` { #projects-onprojectintegrationlist }

Fired from:

- [`core/components/com_projects/site/views/projects/tmpl/_menu.php:103`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/views/projects/tmpl/_menu.php#L103) with `[$this->model]`

No plugin in the source tree listens for this event.

## `projects.onProjectMember` { #projects-onprojectmember }

Fired from:

- [`core/plugins/projects/feed/feed.php:212`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php#L212) with `[$model]`

Listeners:

- `plg_projects_watch` — [`onProjectMember($project)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/watch/watch.php)

## `projects.onProjectMiniList` { #projects-onprojectminilist }

Fired from:

- [`core/plugins/projects/feed/feed.php:207`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php#L207) with `[$model]`

Listeners:

- `plg_projects_files` — [`onProjectMiniList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/files.php)
- `plg_projects_notes` — [`onProjectMiniList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/notes/notes.php)
- `plg_projects_publications` — [`onProjectMiniList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php)
- `plg_projects_team` — [`onProjectMiniList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/team/team.php)
- `plg_projects_todo` — [`onProjectMiniList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/todo/todo.php)

## `projects.onProjectNotification` { #projects-onprojectnotification }

Fired from:

- [`core/components/com_projects/site/views/projects/tmpl/internal.php:46`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/views/projects/tmpl/internal.php#L46) with `[ $this->model, $this->active ]`

Listeners:

- `plg_projects_feed` — [`onProjectNotification($model, $area)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php)

## `projects.onProjectPublicList` { #projects-onprojectpubliclist }

Fired from:

- [`core/components/com_projects/site/views/projects/tmpl/external.php:99`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/views/projects/tmpl/external.php#L99) with `[$this->model]`

Listeners:

- `plg_projects_info` — [`onProjectPublicList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/info/info.php)
- `plg_projects_notes` — [`onProjectPublicList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/notes/notes.php)
- `plg_projects_publications` — [`onProjectPublicList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/publications/publications.php)
- `plg_projects_team` — [`onProjectPublicList($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/team/team.php)

## `projects.onProjectsBrowse` { #projects-onprojectsbrowse }

Fired from:

- [`core/components/com_projects/site/views/projects/tmpl/_item.php:272`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/site/views/projects/tmpl/_item.php#L272) with `[$this->row]`

No plugin in the source tree listens for this event.

## `projects.onShared` { #projects-onshared }

Fired from:

- [`core/plugins/groups/projects/projects.php:354`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/projects.php#L354) with `[ 'feed', $this->model, $this->_projects, User::get('id'), $filters/*, in_array(User::get('id'), $this->group->get('managers')), array( '…`
- [`core/plugins/members/projects/projects.php:250`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/projects/projects.php#L250) with `[ 'feed', $this->model, $projects, $this->_user->get('id'), $view->filters ]`
- [`core/plugins/members/todo/views/browse/tmpl/default.php:57`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/todo/views/browse/tmpl/default.php#L57) with `[ 'todo', $this->model, $this->projects, $this->member->get('id'), $this->filters ]`

Listeners:

- `plg_projects_feed` — [`onShared($area, $model, $projects, $uid, $filters)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php)
- `plg_projects_todo` — [`onShared($area, $model, $projects, $uid, $filters)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/todo/todo.php)

## `projects.onSharedUpdate` { #projects-onsharedupdate }

Fired from:

- [`core/plugins/groups/projects/projects.php:419`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/groups/projects/projects.php#L419) with `[ $project, $entry, $managers, $posted_by, $posted ]`

Listeners:

- `plg_projects_feed` — [`onSharedUpdate($model, $entry, $managers = 0, $posted_by = 0, $posted = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php)

## `projects.onWatch` { #projects-onwatch }

Fired from:

- [`core/components/com_projects/models/project.php:1486`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/models/project.php#L1486) with `[$this, $class, array($aid), User::get('id')]`
- [`core/plugins/projects/feed/feed.php:439`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/feed/feed.php#L439) with `[ $this->model, ($row->get('parent') ? 'quote' : 'blog'), array($row->get('id')), User::get('id') ]`

Listeners:

- `plg_projects_watch` — [`onWatch($project, $area = '', $activities = array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/watch/watch.php)
