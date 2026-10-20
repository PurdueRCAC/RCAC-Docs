---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/events/captcha.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: Event::trigger('captcha.*') call sites and core/plugins/captcha/
---

# Captcha events

Events in the `captcha` group. A plugin in `core/plugins/captcha/` receives an event by defining a public method with the event's name; the arguments are those the call site passes, in order.

## `captcha.onCheckAnswer` { #captcha-oncheckanswer }

Fired from:

- [`core/components/com_members/models/registration.php:761`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/models/registration.php#L761)
- [`core/components/com_members/site/controllers/register.php:1365`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/controllers/register.php#L1365)
- [`core/components/com_support/site/controllers/tickets.php:950`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_support/site/controllers/tickets.php#L950)

Listeners:

- `plg_captcha_image` — [`onCheckAnswer($code = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/image/image.php)
- `plg_captcha_math` — [`onCheckAnswer($code = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/math/math.php)
- `plg_captcha_recaptcha` — [`onCheckAnswer($code = null)`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/recaptcha/recaptcha.php)

## `captcha.onDisplay` { #captcha-ondisplay }

Fired from:

- [`core/components/com_members/site/views/register/tmpl/default.php:600`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/views/register/tmpl/default.php#L600)
- [`core/components/com_members/site/views/register/tmpl/resend_request.php:37`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_members/site/views/register/tmpl/resend_request.php#L37)

Listeners:

- `plg_captcha_image` — [`onDisplay($name = null, $id = 'image_captcha_1', $class = '')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/image/image.php)
- `plg_captcha_math` — [`onDisplay($name = null, $id = 'image_captcha_1', $class = '')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/math/math.php)
- `plg_captcha_recaptcha` — [`onDisplay($name = null, $id = 'dynamic_recaptcha_1', $class = '')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/recaptcha/recaptcha.php)

## `captcha.onInit` { #captcha-oninit }

No call site in the CMS fires this event; the listener may answer an event fired by another package or by an older plugin.

Listeners:

- `plg_captcha_image` — [`onInit($id = 'image_captcha_1')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/image/image.php)
- `plg_captcha_recaptcha` — [`onInit($id = 'dynamic_recaptcha_1')`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/plugins/captcha/recaptcha/recaptcha.php)
