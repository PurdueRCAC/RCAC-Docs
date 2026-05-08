---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Thinlinc session frozen

### Problem

Your Thinlinc session is frozen and you can not launch any commands or close the session.

### Solution

This can happen due to various reasons. The most common reason is that you ran something memory-intensive inside that Thinlinc session on a front-end, so parts of the Thinlinc session got killed by Cgroups, and the entire session got stuck.

* **If you are using a web-version Thinlinc remote desktop (inside the browser):**

  The web version does not have the capability to kill the existing session, only the standalone client does. Please install the standalone client and follow the steps below:

  [ThinLinc](/knowledge/${resource.dir}/accounts/login/thinlinc)
* **If you are using a Thinlinc client:**

  Close the ThinLinc client, reopen the client login popup, and select `End existing session`.

  ![ThinLinc Login Popup](/knowledge/accounts/Thinlinc-End-Existing-Session.png)


  Select "End existing session" and try "Connect" again.