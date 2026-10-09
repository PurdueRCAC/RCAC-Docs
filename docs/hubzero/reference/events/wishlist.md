---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/wishlist.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('wishlist.*') call sites and core/plugins/wishlist/
---

# Wishlist events

Events in the `wishlist` group. A plugin in `core/plugins/wishlist/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `wishlist.onWishlistAfterDelete` { #wishlist-onwishlistafterdelete }

Fired from:

- [`core/components/com_wishlist/admin/controllers/lists.php:261`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/lists.php#L261) with `[$id]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistAfterDeleteComment` { #wishlist-onwishlistafterdeletecomment }

Fired from:

- [`core/components/com_wishlist/admin/controllers/comments.php:304`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/comments.php#L304) with `[$id]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistAfterDeleteWish` { #wishlist-onwishlistafterdeletewish }

Fired from:

- [`core/components/com_wishlist/admin/controllers/wishes.php:423`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/wishes.php#L423) with `[$id]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistAfterSave` { #wishlist-onwishlistaftersave }

Fired from:

- [`core/components/com_wishlist/admin/controllers/lists.php:209`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/lists.php#L209) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistAfterSaveComment` { #wishlist-onwishlistaftersavecomment }

Fired from:

- [`core/components/com_wishlist/admin/controllers/comments.php:256`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/comments.php#L256) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistAfterSaveWish` { #wishlist-onwishlistaftersavewish }

Fired from:

- [`core/components/com_wishlist/admin/controllers/wishes.php:375`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/wishes.php#L375) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistBeforeSave` { #wishlist-onwishlistbeforesave }

Fired from:

- [`core/components/com_wishlist/admin/controllers/lists.php:193`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/lists.php#L193) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistBeforeSaveComment` { #wishlist-onwishlistbeforesavecomment }

Fired from:

- [`core/components/com_wishlist/admin/controllers/comments.php:240`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/comments.php#L240) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.

## `wishlist.onWishlistBeforeSaveWish` { #wishlist-onwishlistbeforesavewish }

Fired from:

- [`core/components/com_wishlist/admin/controllers/wishes.php:331`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_wishlist/admin/controllers/wishes.php#L331) with `[&$row, $isNew]`

No plugin in the source tree listens for this event.
