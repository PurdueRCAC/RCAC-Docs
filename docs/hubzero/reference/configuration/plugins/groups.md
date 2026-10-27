---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/groups.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/groups/*/*.xml
---

# Groups plugins

Parameters of every plugin in the `groups` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Activity (`plg_groups_activity`) { #activity-plg-groups-activity }

Display a list of activity on the site relevant to a group.

This plugin has no parameters.

## Groups - Announcements (`plg_groups_announcements`) { #groups-announcements-plg-groups-announcements }

Display a group's announcements

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

## Groups - Blog (`plg_groups_blog`) { #groups-blog-plg-groups-blog }

Display a blog

### Basic { #basic-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Blog' in group menu. Options: `0` No, `1` Yes. |
| `cleanintro` | Clean Introtext | list | `1 (Yes)` | Strip tags from the introtext or show as is in lists of entries. Options: `0` No, `1` Yes. |
| `introlength` | Intro Length | text | `300` | The length of text the intros should be in lists of entries. |
| `posting` | Article Posting | list | `0 (All members)` | The default setting for who can post to the blog. Options: `0` All members, `1` Managers only. |
| `feeds_enabled` | Feeds | list | `1 (Enabled)` | Enable/Disable RSS feeds. Options: `0` Disabled, `1` Enabled. |
| `feed_entries` | Feed Entries | list | `partial (Partial)` | The length of RSS feed entries. Options: `full` Full, `partial` Partial. |

## Groups - Calendar (`plg_groups_calendar`) { #groups-calendar-plg-groups-calendar }

Displays a Group Calendar

### Basic { #basic-3 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the calendar plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Calendar' in group menu. Options: `0` No, `1` Yes. |
| `allow_registrations` | Event Registrations | list | `1 (Yes)` | Allow group events to capture event registrations. Options: `0` No, `1` Yes. |
| `allow_subscriptions` | Calendar Subscriptions | list | `1 (Yes)` | Allow groups to publish calendars. Options: `0` No, `1` Yes. |
| `allow_quick_create` | Event Quick Create | list | `1 (Yes)` | Allow users to double click on calendar date and create event. Options: `0` No, `1` Yes. |
| `allow_import` | Event Import | list | `1 (Yes)` | Allow users import events and calendar subscriptions. Options: `0` No, `1` Yes. |
| `import_subscription_interval` | Calendar Subscription Refresh Interval | list | `60 (60 Minutes)` | Interval of which imported calendar subscriptions refreshed. Options: `5` 5 Minutes, `15` 15 Minutes, `30` 30 Minutes, `60` 60 Minutes, `120` 2 Hours, `240` 4 Hours, `480` 8 Hours, `1440` 1 Day. |

## Groups - Citations (`plg_groups_citations`) { #groups-citations-plg-groups-citations }

Displays group citations

### Basic { #basic-4 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `sort` | Default Sort | list | `year DESC (Year)` | Default value to sort records by. Options: `year DESC` Year, `created DESC` Created, `title ASC` Title, `author ASC` Author, `journal ASC` Journal. |
| `labeling_scheme` | Labeling Scheme | list | `both (Record ID and Citation Type)` | Select the metadata information to be shown. Options: `both` Record ID and Citation Type, `numtype` Sequential Number and Citation Type, `id` Record ID, `number` Sequential Number, `type` Citation Type, `none` None. |

## Groups - Collections (`plg_groups_collections`) { #groups-collections-plg-groups-collections }

Display collections

### Basic { #basic-5 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the 'Collections' plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Collections' in group menu. Options: `0` No, `1` Yes. |
| `maxWidth` | Max Image Width | text | `290` | Max Image Width for tile listing |
| `posting` | Article Posting | list | `0 (All members)` | The default setting for who can post to the blog. Options: `0` All members, `1` Managers only. |
| `feeds_enabled` | Feeds | list | `1 (Enabled)` | Enable/Disable RSS feeds. Options: `0` Disabled, `1` Enabled. |
| `feed_entries` | Feed Entries | list | `partial (Partial)` | The length of RSS feed entries. Options: `full` Full, `partial` Partial. |

## Groups - Courses (`plg_groups_courses`) { #groups-courses-plg-groups-courses }

Display courses for a group

### Basic { #basic-6 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Forum' in group menu. Options: `0` No, `1` Yes. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

## Groups - Files (`plg_groups_files`) { #groups-files-plg-groups-files }

Display a group's files

### Basic { #basic-7 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the Files plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Files' in group menu. Options: `0` No, `1` Yes. |

## Groups - Forum (`plg_groups_forum`) { #groups-forum-plg-groups-forum }

Display and manage a forum for a specific group

### Basic { #basic-8 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Forum' in group menu. Options: `0` No, `1` Yes. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

### Forum

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `allow_anonymous` | Allow anonymous | radio | `1 (Yes)` | Allow users to make posts anonymously?. Options: `0` No, `1` Yes. |
| `threading` | Threading | list | `both` | Determines what type of comment nesting threads have. Options: `list` Flat, one level threads (traditional), `tree` Nested threads. |
| `threading_depth` | Threading level | text | `3` | How many levels deep a nested thread can go. |

## Groups - Member Options (`plg_groups_memberoptions`) { #groups-member-options-plg-groups-memberoptions }

Group Member Options

### Basic { #basic-9 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Projects' in group menu. Options: `0` No, `1` Yes. |

## Groups - Members (`plg_groups_members`) { #groups-members-plg-groups-members }

Display a group's members

### Basic { #basic-10 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Members' in group menu. Options: `0` No, `1` Yes. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

## Groups - Messages (`plg_groups_messages`) { #groups-messages-plg-groups-messages }

Display a group's messages

### Basic { #basic-11 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `0 (No)` | Display 'Messages' in group menu. Options: `0` No, `1` Yes. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |
| `stamp_logo` | Message Stamp Image | text | `/plugins/groups/messages/mail-send.png` |  |

## Groups - Projects (`plg_groups_projects`) { #groups-projects-plg-groups-projects }

Displays the projects a particular group has access to.

### Basic { #basic-12 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Projects' in group menu. Options: `0` No, `1` Yes. |

## Groups - Resources (`plg_groups_resources`) { #groups-resources-plg-groups-resources }

Displays resources associated with a group

### Basic { #basic-13 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Resources' in group menu. Options: `0` No, `1` Yes. |

## Groups - Search (`plg_groups_search`) { #groups-search-plg-groups-search }

Automatically update search index when group info is changed.

This plugin has no parameters.

## Groups - Usage (`plg_groups_usage`) { #groups-usage-plg-groups-usage }

Display usage information for a group

### Basic { #basic-14 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Usage' in group menu. Options: `0` No, `1` Yes. |

## Groups - Wiki (`plg_groups_wiki`) { #groups-wiki-plg-groups-wiki }

Display a wiki for a group

### Basic { #basic-15 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Wiki' in group menu. Options: `0` No, `1` Yes. |
| `display_limit` | Display Limit | text | `50` | Number of items to return |

## Groups - Wishlist (`plg_groups_wishlist`) { #groups-wishlist-plg-groups-wishlist }

Display wishlist for a group

### Basic { #basic-16 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `plugin_access` | Default Plugin Access | list | `members (Only Group Members)` | Default access level assigned to the blog plugin. Options: `anyone` Any HUB Visitor, `registered` Only Registered HUB Users, `members` Only Group Members, `nobody` Disabled/Off. |
| `display_tab` | Display in Menu | list | `1 (Yes)` | Display 'Wishlist' in group menu. Options: `0` No, `1` Yes. |
| `limit` | Display Limit | text | `50` | Number of items to return |
