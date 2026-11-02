---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/cart.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('cart.*') call sites and core/plugins/cart/
---

# Cart events

Events in the `cart` group. A plugin in `core/plugins/cart/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `cart.onComplete` { #cart-oncomplete }

Fired from:

- [`core/components/com_cart/site/controllers/order.php:69`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/site/controllers/order.php#L69) with `[$provider]`

Listeners:

- `plg_cart_offline` — [`onComplete($provider)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/offline/offline.php)
- `plg_cart_upay` — [`onComplete($provider)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/upay/upay.php)

## `cart.onPostback` { #cart-onpostback }

Fired from:

- [`core/components/com_cart/site/controllers/order.php:220`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/site/controllers/order.php#L220) with `[$_POST, User::getRoot()]`

Listeners:

- `plg_cart_offline` — [`onPostback($postData)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/offline/offline.php)
- `plg_cart_upay` — [`onPostback($postData)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/upay/upay.php)

## `cart.onProcessPayment` { #cart-onprocesspayment }

Fired from:

- [`core/components/com_cart/site/controllers/checkout.php:594`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/site/controllers/checkout.php#L594) with `[$transaction, User::getInstance()]`

Listeners:

- `plg_cart_paypal` — [`onProcessPayment($transaction, $user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/paypal/paypal.php)

## `cart.onRenderPaymentOptions` { #cart-onrenderpaymentoptions }

Fired from:

- [`core/components/com_cart/site/views/checkout/tmpl/payment.php:37`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/site/views/checkout/tmpl/payment.php#L37) with `[$this->transaction, User::getRoot()]`

Listeners:

- `plg_cart_offline` — [`onRenderPaymentOptions($transaction, $user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/offline/offline.php)
- `plg_cart_paypal` — [`onRenderPaymentOptions($cart, $user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/paypal/paypal.php)
- `plg_cart_upay` — [`onRenderPaymentOptions($cart, $user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/upay/upay.php)

## `cart.onSelectedPayment` { #cart-onselectedpayment }

Fired from:

- [`core/components/com_cart/site/controllers/checkout.php:568`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/site/controllers/checkout.php#L568) with `[$transaction, User::getInstance()]`

Listeners:

- `plg_cart_offline` — [`onSelectedPayment($transaction, $user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/offline/offline.php)
- `plg_cart_upay` — [`onSelectedPayment($transaction, $user)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/cart/upay/upay.php)
