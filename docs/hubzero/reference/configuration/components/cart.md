---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/cart.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_cart/config/config.xml
---

# Cart (com_cart)

Configure cart

Parameters from [`core/components/com_cart/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_cart/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `storeAdminId` | Store administrator ID | text | `1000` | Numeric ID |
| `sendNotificationTo` | Send notifications to | text | — | Comma-separated list of email addresses |
| `sendOrderInfoFromEmail` | Send order info from | text | — | Email addresses the order confirmations are going to be sent from (will also be a 'Reply-To' address) |
| `transactionTTL` | Transaction TTL | text | `120` | Time in minutes the cart items stay reserved until they get released back to inventory and transaction is killed |

## Payment

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `paymentProvider` | Payment Provider | text | — | DUMMY AUTO PAYMENT, UPAY |
| `paymentProviderEnv` | Payment environment | text | — | LIVE, DEV |
| `paymentSiteId` | Payment site ID | text | — |  |
| `paymentValidationKey` | Validation key | text | — |  |
