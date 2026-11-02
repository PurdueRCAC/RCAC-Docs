---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/cart.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/cart/*/*.xml
---

# Cart plugins

Parameters of every plugin in the `cart` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Cart - Payment: Offline (`plg_cart_offline`) { #cart-payment-offline-plg-cart-offline }

Offline payment processor for the cart.

This plugin has no parameters.

## Cart - Payment: PayPal (`plg_cart_paypal`) { #cart-payment-paypal-plg-cart-paypal }

PayPal payment processor for the cart.

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `title` | Tab title | text | `PayPal` | Tab title |
| `description` | Description text | textarea | `Click on the button to pay with PayPal` | Description text |
| `env` | PLG_AUTHENTICATION_FACEBOOK_PARAM_SITELOGIN_LABEL | radio | `1` | PLG_AUTHENTICATION_FACEBOOK_PARAM_SITELOGIN_DESC. Options: `live` Live, `sandbox` Sandbox. |
| `receiver_email` | Paypal Email | text | — | Paypal Email Desc |
| `currency` | Paypal Currency | text | `USD` | Paypal Currency Desc |
| `secure_post` | Paypal Secure Post | radio | `0 (No)` | Paypal Secure Post Desc. Options: `0` No, `1` Yes. |
| `sandbox_receiver_email` | Paypal Sandbox Email | text | — | Paypal Sandbox Email Desc |

## Cart - Payment: UPay (`plg_cart_upay`) { #cart-payment-upay-plg-cart-upay }

UPay payment processor for the cart.

### Basic { #basic-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `title` | Tab title | text | `PayPal` | Tab title |
| `paymentSiteId` | UPay site ID | text | — | UPay site ID |
| `paymentValidationKey` | Payment validation key | text | — | Payment validation key |
| `env` | Environment | radio | `1` | Environment. Options: `live` Live, `sandbox` Sandbox. |
