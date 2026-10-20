---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/metadata.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('metadata.*') call sites and core/plugins/metadata/
---

# Metadata events

Events in the `metadata` group. A plugin in `core/plugins/metadata/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `metadata.onFileMove` { #metadata-onfilemove }

Fired from:

- [`core/plugins/projects/files/connections.php:1333`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/connections.php#L1333) with `[$oldName, $item->getAbsolutePath()]`
- [`core/plugins/projects/files/connections.php:1424`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/connections.php#L1424) with `[$oldName, $entity->getAbsolutePath()]`

Listeners:

- `plg_metadata_local` — [`onFileMove($old, $new)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/metadata/local/local.php)

## `metadata.onMetadataEdit` { #metadata-onmetadataedit }

Fired from:

- [`core/plugins/projects/files/connections.php:1531`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/connections.php#L1531)

No plugin in the source tree listens for this event.

## `metadata.onMetadataGet` { #metadata-onmetadataget }

Fired from:

- [`core/components/com_projects/api/controllers/filefsv1_0.php:948`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filefsv1_0.php#L948) with `[$entity]`
- [`core/components/com_projects/api/controllers/filefsv1_0.php:1036`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filefsv1_0.php#L1036) with `[$entity]`
- [`core/components/com_projects/api/controllers/filesv1_0.php:1176`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filesv1_0.php#L1176) with `[$entity]`
- [`core/components/com_projects/api/controllers/filesv1_0.php:1271`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filesv1_0.php#L1271) with `[$entity]`
- [`core/plugins/projects/files/connections.php:1539`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/connections.php#L1539) with `[$entity]`

Listeners:

- `plg_metadata_local` — [`onMetadataGet(Hubzero\Filesystem\File $file, $maxEntries = 1)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/metadata/local/local.php)

## `metadata.onMetadataSave` { #metadata-onmetadatasave }

Fired from:

- [`core/components/com_projects/api/controllers/filefsv1_0.php:1039`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filefsv1_0.php#L1039) with `[$entity, array_merge($oldmetadata, $metadata)]`
- [`core/components/com_projects/api/controllers/filesv1_0.php:1274`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_projects/api/controllers/filesv1_0.php#L1274) with `[$entity, array_merge($oldmetadata, $metadata)]`
- [`core/plugins/projects/files/connections.php:1601`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/projects/files/connections.php#L1601) with `[ $entity, $metadata ]`

Listeners:

- `plg_metadata_local` — [`onMetadataSave(Hubzero\Filesystem\File $file, $metadata)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/metadata/local/local.php)
