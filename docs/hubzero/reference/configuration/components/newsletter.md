---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/components/newsletter.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/components/com_newsletter/config/config.xml
---

# Newsletter (com_newsletter)

Manage Newsletters

Parameters from [`core/components/com_newsletter/config/config.xml`](https://github.com/hubzero/hubzero-cms/blob/9c1a8c678002bdfb41860f90915a3589ab60339e/core/components/com_newsletter/config/config.xml), as shown on the component's **Options** screen in the administrator interface.

## Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `newsletter_from_name` | Newsletter From Name | text | `My HUB` | From name for newsletter. |
| `newsletter_from_address` | Newsletter From Address | text | `contact@myhub.org` | From address for newsletter. |
| `newsletter_replyto_name` | Newsletter Reply-To Name | text | `My HUB Reply` | Reply-to name for newsletter. |
| `newsletter_replyto_address` | Newsletter Reply-To Address | text | `reply@myhub.org` | Reply-to address for newsletter. |
| `email_tracking_link` | Email Tracking Info | text | `http://kb.mailchimp.com/article/how-open-tracking-works` | Link to how email tracking works. |
| `template_tips` | Guides for Creating Template URL | text | `http://www.campaignmonitor.com/guides/` | A URL that shows tips and tricks to building a newsletter template that will work with all email clients. |
| `template_templates` | Newsletter Templates and/or Examples | text | `http://www.campaignmonitor.com/templates/` | A URL that has newsletter templates or shows examples of newsletter templates. |
