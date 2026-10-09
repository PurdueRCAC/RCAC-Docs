---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/support.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('support.*') call sites and core/plugins/support/
---

# Support events

Events in the `support` group. A plugin in `core/plugins/support/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `support.onCommentPrepare` { #support-oncommentprepare }

Fired from:

- [`core/components/com_support/models/comment.php:208`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/models/comment.php#L208) with `['com_support.comment', &$this]`

Listeners:

- `plg_support_markdown` — [`onCommentPrepare($context, &$comment)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/markdown/markdown.php)

## `support.onGetCaptcha` { #support-ongetcaptcha }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_support_captcha` — [`onGetCaptcha($ext='com')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/captcha/captcha.php)

## `support.onGetComponentCaptcha` { #support-ongetcomponentcaptcha }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_support_captcha` — [`onGetComponentCaptcha()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/captcha/captcha.php)

## `support.onGetModuleCaptcha` { #support-ongetmodulecaptcha }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_support_captcha` — [`onGetModuleCaptcha()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/captcha/captcha.php)

## `support.onPreTicketSubmission` { #support-onpreticketsubmission }

Fired from:

- [`core/components/com_support/site/controllers/tickets.php:861`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/controllers/tickets.php#L861) with `[]`

No plugin in the source tree listens for this event.

## `support.onReportItem` { #support-onreportitem }

Fired from:

- [`core/components/com_support/site/controllers/abuse.php:196`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/controllers/abuse.php#L196) with `[ $refid, $cat ]`

Listeners:

- `plg_support_answers` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/answers/answers.php)
- `plg_support_blog` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/blog/blog.php)
- `plg_support_comments` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/comments/comments.php)
- `plg_support_forum` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/forum/forum.php)
- `plg_support_kb` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/kb/kb.php)
- `plg_support_resources` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/resources/resources.php)
- `plg_support_wiki` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/wiki/wiki.php)
- `plg_support_wishlist` — [`onReportItem($refid, $category)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/wishlist/wishlist.php)

## `support.onTicketComment` { #support-onticketcomment }

Fired from:

- [`core/components/com_support/admin/views/tickets/tmpl/edit.php:392`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/admin/views/tickets/tmpl/edit.php#L392) with `[$this->row]`
- [`core/components/com_support/site/views/tickets/tmpl/ticket.php:588`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/views/tickets/tmpl/ticket.php#L588) with `[$this->row]`

No plugin in the source tree listens for this event.

## `support.onTicketSubmission` { #support-onticketsubmission }

Fired from:

- [`core/components/com_support/site/controllers/tickets.php:1409`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/controllers/tickets.php#L1409) with `[$row]`

Listeners:

- `plg_support_slack` — [`onTicketSubmission($ticket)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/slack/slack.php)

## `support.onTicketUpdate` { #support-onticketupdate }

Fired from:

- [`core/components/com_support/admin/controllers/tickets.php:578`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/admin/controllers/tickets.php#L578) with `[$ticket, $comment]`
- [`core/components/com_support/site/controllers/tickets.php:1793`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/controllers/tickets.php#L1793) with `[$row, $rowc]`

Listeners:

- `plg_support_slack` — [`onTicketUpdate($ticket, $comment)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/slack/slack.php)

## `support.onValidateCaptcha` { #support-onvalidatecaptcha }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_support_captcha` — [`onValidateCaptcha()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/support/captcha/captcha.php)

## `support.onValidateTicketSubmission` { #support-onvalidateticketsubmission }

Fired from:

- [`core/components/com_support/site/controllers/tickets.php:910`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/controllers/tickets.php#L910) with `[$reporter, $problem]`

No plugin in the source tree listens for this event.
