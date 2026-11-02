---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/xmessage.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('xmessage.*') call sites and core/plugins/xmessage/
---

# Xmessage events

Events in the `xmessage` group. A plugin in `core/plugins/xmessage/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `xmessage.onMessage` { #xmessage-onmessage }

Fired from:

- [`core/libraries/Hubzero/Message/Helper.php:156`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/libraries/Hubzero/Message/Helper.php#L156) with `[$from, $xmessage, $user, $action))) { $this->setError(Lang::txt('Unable to message user %s with method %s', $uid, $action]`

Listeners:

- `plg_xmessage_email` — [`onMessage($from, $xmessage, $user, $action)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/xmessage/email/email.php)
- `plg_xmessage_internal` — [`onMessage($from, $xmessage, $user, $action)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/xmessage/internal/internal.php)

## `xmessage.onMessageMethods` { #xmessage-onmessagemethods }

Fired from:

- [`core/components/com_members/admin/controllers/messages.php:252`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/admin/controllers/messages.php#L252) with `[]`
- [`core/plugins/members/messages/messages.php:435`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/members/messages/messages.php#L435) with `[]`

Listeners:

- `plg_xmessage_email` — [`onMessageMethods()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/xmessage/email/email.php)
- `plg_xmessage_internal` — [`onMessageMethods()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/xmessage/internal/internal.php)

## `xmessage.onSendMessage` { #xmessage-onsendmessage }

Fired from:

- [`core/components/com_answers/site/controllers/questions.php:174`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L174) with `['answers_reply_comment', $subject, $message, $from, array($authorid), $this->_option))) { $this->setError(Lang::txt('COM_ANSWERS_MESSAGE…`
- [`core/components/com_answers/site/controllers/questions.php:184`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L184) with `['new_answer_admin', $subject, $message, $from, $receivers, $this->_option))) { $this->setError(Lang::txt('COM_ANSWERS_MESSAGE_FAILED']`
- [`core/components/com_answers/site/controllers/questions.php:797`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L797) with `['new_question_admin', $subject, $message, $from, $recipients, $this->_option))) { Notify::error(Lang::txt('COM_ANSWERS_MESSAGE_FAILED']`
- [`core/components/com_answers/site/controllers/questions.php:916`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L916) with `['answers_question_deleted', $subject, $message, $from, $users, $this->_option))) { $this->setError(Lang::txt('COM_ANSWERS_MESSAGE_FAILED']`
- [`core/components/com_answers/site/controllers/questions.php:1064`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L1064) with `[$messageType , $subject, $message, $from, array($authorid), $this->_option))) { $this->setError(Lang::txt('COM_ANSWERS_MESSAGE_FAILED']`
- [`core/components/com_answers/site/controllers/questions.php:1073`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L1073) with `['new_answer_admin', $subject, $message, $from, $receivers, $this->_option))) { $this->setError(Lang::txt('COM_ANSWERS_MESSAGE_FAILED']`
- [`core/components/com_cart/lib/cartmessenger/CartMessenger.php:511`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/lib/cartmessenger/CartMessenger.php#L511) with `['store_notifications', $mailSubject, $mailMessage, $from, $adminId, '', null, '', 0, true]`
- [`core/components/com_courses/site/controllers/course.php:649`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/controllers/course.php#L649) with `['courses_deleted', $subject, $message, $from, $members, $this->_option))) { Notify::error(Lang::txt('COM_COURSES_ERROR_EMAIL_MEMBERS_FAI…`
- [`core/components/com_groups/site/controllers/membership.php:860`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_groups/site/controllers/membership.php#L860) with `array('groups_cancelled_me', $subject, $message, $from, $this->view->group->get('managers'), $this->_option))) { $this->setError(Lang::tx…`
- [`core/components/com_jobs/admin/controllers/jobs.php:339`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_jobs/admin/controllers/jobs.php#L339) with `['jobs_ad_status_changed', $subject, $emailbody, $from, array($job->addedBy), $this->_option))) { Notify::error(Lang::txt('COM_JOBS_ERROR…`
- [`core/components/com_projects/admin/controllers/projects.php:577`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/admin/controllers/projects.php#L577) with `['projects_admin_notice', $subject, $body, $from, $managers, $this->_option]`
- [`core/components/com_projects/helpers/html.php:1323`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/helpers/html.php#L1323) with `[ $component, $subject, $body, $from, $addressees, $option ]`
- and 28 more call sites

Listeners:

- `plg_xmessage_handler` — [`onSendMessage($type, $subject, $message, $from=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/xmessage/handler/handler.php)

## `xmessage.onTakeAction` { #xmessage-ontakeaction }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_xmessage_handler` — [`onTakeAction($type, $uids=array()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/xmessage/handler/handler.php)
