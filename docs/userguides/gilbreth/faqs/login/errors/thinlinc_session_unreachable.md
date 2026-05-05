---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Thinlinc session unreachable

### Problem

When trying to login to Thinlinc and re-connect to your existing session, you receive an error *"Your Thinlinc session is currently unreachable"*.

### Solution

This can happen if the specific login node your existing remote desktop session was residing on is currently offline or down, so Thinlinc can not reconnect to your existing session.  Most often the session is non-recoverable at this point, so the solution is to terminate your existing Thinlinc desktop session and start a new one.

* **If you are using a web-version Thinlinc remote desktop (inside the browser):**

  The web version does not have the capability to kill the existing session, only the standalone client does. Please install the standalone client and follow the steps below:

  [ThinLinc](https://www.rcac.purdue.edu/knowledge/scholar/accounts/login/thinlinc)
* **If you are using a Thinlinc client:**

  Close the ThinLinc client, reopen the client login popup, and select `End existing session`.

  ![ThinLinc Login Popup](https://www.rcac.purdue.edu/files/knowledge/accounts/Thinlinc-End-Existing-Session.png)


  Select "End existing session" and try "Connect" again.