---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/courses.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/courses/*/*.xml
---

# Courses plugins

Parameters of every plugin in the `courses` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Courses - Announcements (`plg_courses_announcements`) { #courses-announcements-plg-courses-announcements }

Display a course's announcements

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the this plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - Dashboard (`plg_courses_dashboard`) { #courses-dashboard-plg-courses-dashboard }

Display a course manager dashboard

### Basic { #basic-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the this plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - Discussions (`plg_courses_discussions`) { #courses-discussions-plg-courses-discussions }

Display and manage a forum for a specific course

### Basic { #basic-3 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |
| `display_limit` | Display Limit | text | `50` | The number of records to display at a time. |
| `comments_depth` | Depth | text | `3` | The number of levels comments can be nested. 1 level would be just comments, no replies to comments. |
| `default_discussions_category` | Asset Group Discussions | list | `0 (Off)` | Global default setting for allowing discussion threads on an asset group. Options: `0` Off, `1` On. |

### 

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `discussions_threads` | Show threads from | list | `section (This section only)` | Determine what threads to show to students in this section. NOTE: Sticky threads show across all sections regardless of this setting. Options: `all` All sections, `section` This section only. |

### 

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `discussions_category` | Discussion threads | list | `0 (Off)` | Allow discussion threads on this or not?. Options: `0` Off, `1` On. |

## Courses - Guide (`plg_courses_guide`) { #courses-guide-plg-courses-guide }

Display getting started guide page

### Basic { #basic-4 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - Notes (`plg_courses_notes`) { #courses-notes-plg-courses-notes }

Display user notes for a course

### Basic { #basic-5 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `managers` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

## Courses - Offerings (`plg_courses_offerings`) { #courses-offerings-plg-courses-offerings }

Display a course's offerings

### Basic { #basic-6 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `managers` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - outline (`plg_courses_outline`) { #courses-outline-plg-courses-outline }

Display course outline

### Basic { #basic-7 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the outline plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - Overview (`plg_courses_overview`) { #courses-overview-plg-courses-overview }

Display course overview info

### Basic { #basic-8 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `managers` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - Pages (`plg_courses_pages`) { #courses-pages-plg-courses-pages }

Display and manage course pages

### Basic { #basic-9 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |

## Courses - Store (`plg_courses_pec`) { #courses-store-plg-courses-pec }

Handles course to store data

### Basic { #basic-10 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `some_thing` | Some thing | list | `1 (Enabled)` | Enable/Disable some thing. Options: `0` Disabled, `1` Enabled. |
| `url` | PEC URL | text | `https://www.distance.purdue.edu/{{course}}` | The PEC URL for registration |

### 

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `pec_register` | PEC Registration | radio | `0 (No)` | Enable PEC registration?. Options: `0` No, `1` Yes. |
| `pec_course` | PEC Course ID | text | — | The PEC course ID |

## Courses - Progress (`plg_courses_progress`) { #courses-progress-plg-courses-progress }

Display progress for a course

### Basic { #basic-11 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Course Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Course Members, `nobody` Disabled/Off. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

## Courses - Related (`plg_courses_related`) { #courses-related-plg-courses-related }

Display other courses by these instructors

### Basic { #basic-12 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `display_limit` | Display Limit | text | `3` | Number of items to return |

## Reviews (`plg_courses_reviews`) { #reviews-plg-courses-reviews }

Display reviews for a course

### Basic { #basic-13 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `display_limit` | Display Limit | text | `50` | Number of items to return |
| `voting` | Voting Enabled | radio | `1 (Yes)` | Allow voting on reviews and comments. Options: `0` No, `1` Yes. |

## Courses - Store (`plg_courses_store`) { #courses-store-plg-courses-store }

Handles course to store data

### Basic { #basic-14 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `some_thing` | Some thing | list | `1 (Enabled)` | Enable/Disable some thing. Options: `0` Disabled, `1` Enabled. |

### 

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `store_product` | Add to store | radio | `0 (No)` | Add a product entry to the store for this course?. Options: `0` No, `1` Yes. |
| `store_price` | Price ($) | text | `30.00` | The price of the course |
| `store_membership_duration` | Membership duration | list | `1 year` | How long does membership last?. Options: `1 WEEK` 1 week, `2 WEEKS` 2 weeks, `3 WEEKS` 3 weeks, `1 MONTH` 1 month, `3 MONTHS` 3 months, `6 MONTHS` 6 months, `1 YEAR` 1 year. |
