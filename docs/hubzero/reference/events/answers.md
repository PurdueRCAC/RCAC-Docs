---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/answers.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('answers.*') call sites and core/plugins/answers/
---

# Answers events

Events in the `answers` group. A plugin in `core/plugins/answers/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `answers.onQuestionNotify` { #answers-onquestionnotify }

Fired from:

- [`core/components/com_answers/site/controllers/questions.php:756`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L756) with `array($row)) as $results) { $recipients = array_merge($recipients, $results`

Listeners:

- `plg_answers_tools` — [`onQuestionNotify($row)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/answers/tools/tools.php)

## `answers.onQuestionsFilters` { #answers-onquestionsfilters }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_answers_members` — [`onQuestionsFilters()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/answers/members/members.php)

## `answers.onQuestionsPrepareFilters` { #answers-onquestionspreparefilters }

Fired from:

- [`core/components/com_answers/site/controllers/questions.php:432`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_answers/site/controllers/questions.php#L432) with `[$filters]`

Listeners:

- `plg_answers_members` — [`onQuestionsPrepareFilters($filters)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/answers/members/members.php)
- `plg_answers_tools` — [`onQuestionsPrepareFilters($filters)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/answers/tools/tools.php)
