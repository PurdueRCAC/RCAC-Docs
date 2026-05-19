---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# ThinLinc session frozen

## Problem

Your ThinLinc session is frozen and you can not launch any commands or close the session.

## Solution

This can happen due to various reasons. The most common reason is that you ran something memory-intensive inside that ThinLinc session on a front-end, so parts of the ThinLinc session got killed by Cgroups, and the entire session got stuck.

* **If you are using a web-version ThinLinc remote desktop (inside the browser):**

  The web version does not have the capability to kill the existing session, only the standalone client does. Please install the standalone client and follow the steps below:

  [ThinLinc](../../../accounts.md#thinlinc)
  
* **If you are using a ThinLinc client:**

  Close the ThinLinc client, reopen the client login popup, and select `End existing session`.

  <p style="text-align: center;">
    <img src="/assets/images/userguides/bell/accounts-ThinLinc-End-Existing-Session.png" alt="ThinLinc Login Popup" width="80%">
  </p>


  Select "End existing session" and try "Connect" again.
