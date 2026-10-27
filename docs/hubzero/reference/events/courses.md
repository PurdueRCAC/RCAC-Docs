---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/courses.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('courses.*') call sites and core/plugins/courses/
---

# Courses events

Events in the `courses` group. A plugin in `core/plugins/courses/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `courses.onAfterDeleteCoupon` { #courses-onafterdeletecoupon }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_store` — [`onAfterDeleteCoupon($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onAfterSaveCoupon` { #courses-onaftersavecoupon }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_store` — [`onAfterSaveCoupon($model, $isNew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onAssetgroupDelete` { #courses-onassetgroupdelete }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onAssetgroupDelete($assetgroup)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onAssetgroupEdit` { #courses-onassetgroupedit }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onAssetgroupEdit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onAssetgroupSave` { #courses-onassetgroupsave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onAssetgroupSave($assetgroup)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onCourse` { #courses-oncourse }

Fired from:

- [`core/components/com_courses/site/controllers/offering.php:201`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/controllers/offering.php#L201) with `[ $this->course, $this->course->offering(), true ]`
- [`core/components/com_courses/site/controllers/offering.php:217`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/controllers/offering.php#L217) with `[ $this->course, $this->course->offering() ]`
- [`core/plugins/courses/guide/views/guide/tmpl/overlay.php:10`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/guide/views/guide/tmpl/overlay.php#L10) with `[ $this->course, $this->offering, true ]`

Listeners:

- `plg_courses_announcements` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/announcements/announcements.php)
- `plg_courses_dashboard` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/dashboard/dashboard.php)
- `plg_courses_discussions` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)
- `plg_courses_guide` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/guide/guide.php)
- `plg_courses_notes` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/notes/notes.php)
- `plg_courses_outline` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/outline/outline.php)
- `plg_courses_pages` — [`onCourse($course, $offering, $describe = false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/pages/pages.php)
- `plg_courses_progress` — [`onCourse($course, $offering, $describe=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/progress/progress.php)

## `courses.onCourseAfterLecture` { #courses-oncourseafterlecture }

Fired from:

- [`core/plugins/courses/outline/views/outline/tmpl/lecture.php:284`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/outline/views/outline/tmpl/lecture.php#L284) with `[ $this->course, $unit, $lecture ]`

Listeners:

- `plg_courses_discussions` — [`onCourseAfterLecture($course, $unit, $lecture)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)
- `plg_courses_notes` — [`onCourseAfterLecture($course, $unit, $lecture)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/notes/notes.php)

## `courses.onCourseAfterOutline` { #courses-oncourseafteroutline }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_guide` — [`onCourseAfterOutline($course, $offering)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/guide/guide.php)

## `courses.onCourseAreas` { #courses-oncourseareas }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onCourseAreas()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onCourseBeforeOutline` { #courses-oncoursebeforeoutline }

Fired from:

- [`core/plugins/courses/outline/views/outline/tmpl/default.php:82`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/outline/views/outline/tmpl/default.php#L82) with `[ $course, $offering ]`

Listeners:

- `plg_courses_announcements` — [`onCourseBeforeOutline($course, $offering)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/announcements/announcements.php)

## `courses.onCourseDashboard` { #courses-oncoursedashboard }

Fired from:

- [`core/plugins/courses/dashboard/views/overview/tmpl/default.php:133`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/dashboard/views/overview/tmpl/default.php#L133) with `[$this->course, $this->offering]`

Listeners:

- `plg_courses_announcements` — [`onCourseDashboard($course, $offering)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/announcements/announcements.php)
- `plg_courses_discussions` — [`onCourseDashboard($course, $offering)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onCourseDelete` { #courses-oncoursedelete }

Fired from:

- [`core/components/com_courses/models/orm/course.php:407`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/models/orm/course.php#L407) with `[$this]`

Listeners:

- `plg_courses_discussions` — [`onCourseDelete($course)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)
- `plg_courses_store` — [`onCourseDelete($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onCourseDeleteCount` { #courses-oncoursedeletecount }

Fired from:

- [`core/components/com_courses/site/controllers/course.php:589`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/controllers/course.php#L589) with `[$course]`

No plugin in the source tree listens for this event.

## `courses.onCourseEnrollLink` { #courses-oncourseenrolllink }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_store` — [`onCourseEnrollLink($course, $offering, $section)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onCourseEnrolled` { #courses-oncourseenrolled }

Fired from:

- [`core/components/com_courses/site/controllers/offering.php:364`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/controllers/offering.php#L364) with `[ $this->course, $offering, $offering->section() ]`

Listeners:

- `plg_courses_pec` — [`onCourseEnrolled($course, $offering, $section)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/pec/pec.php)

## `courses.onCourseSave` { #courses-oncoursesave }

Fired from:

- [`core/components/com_courses/models/orm/course.php:394`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/models/orm/course.php#L394) with `[$this]`

Listeners:

- `plg_courses_store` — [`onCourseSave($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onCourseView` { #courses-oncourseview }

Fired from:

- [`core/components/com_courses/site/controllers/course.php:146`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/controllers/course.php#L146) with `[ $this->course, $this->view->active ]`

Listeners:

- `plg_courses_offerings` — [`onCourseView($course, $active=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/offerings/offerings.php)
- `plg_courses_overview` — [`onCourseView($course, $active=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/overview/overview.php)
- `plg_courses_reviews` — [`onCourseView($course, $active=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/reviews/reviews.php)
- `plg_courses_store` — [`onCourseView($course, $active=null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onCourseViewAfter` { #courses-oncourseviewafter }

Fired from:

- [`core/components/com_courses/site/views/course/tmpl/display.php:721`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_courses/site/views/course/tmpl/display.php#L721) with `[$this->course]`

Listeners:

- `plg_courses_related` — [`onCourseViewAfter($course)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/related/related.php)

## `courses.onOfferingDelete` { #courses-onofferingdelete }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_store` — [`onOfferingDelete($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onOfferingEdit` { #courses-onofferingedit }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_pec` — [`onOfferingEdit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/pec/pec.php)
- `plg_courses_store` — [`onOfferingEdit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onOfferingSave` { #courses-onofferingsave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_store` — [`onOfferingSave($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onSectionDelete` { #courses-onsectiondelete }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_pec` — [`onSectionDelete($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/pec/pec.php)
- `plg_courses_store` — [`onSectionDelete($model)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onSectionEdit` { #courses-onsectionedit }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onSectionEdit()`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onSectionSave` { #courses-onsectionsave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_pec` — [`onSectionSave($model, $isNew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/pec/pec.php)
- `plg_courses_store` — [`onSectionSave($model, $isNew=false)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/store/store.php)

## `courses.onUnitDelete` { #courses-onunitdelete }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onUnitDelete($unit)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)

## `courses.onUnitSave` { #courses-onunitsave }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_courses_discussions` — [`onUnitSave($unit)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/courses/discussions/discussions.php)
