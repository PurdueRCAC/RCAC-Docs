---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Gateway (Open OnDemand)

Gilbreth's Gateway is an [open-source HPC portal](http://openondemand.org/) developed by the [Ohio Supercomputing Center](https://www.osc.edu/). Open OnDemand allows one to interact with HPC resources through a web browser and easily manage files, submit jobs, and interact with graphical applications directly in a browser, all with no software to install. Gilbreth has an instance of OnDemand available that can be accessed via {::if resource.active != false}[${resource.oodname}.${resource.hostname}.rcac.purdue.edu](https://${resource.oodname}.${resource.hostname}.rcac.purdue.edu){::else}${resource.oodname}.${resource.hostname}.rcac.purdue.edu{::/}.

Logging In
----------

To log into Gateway:

* Navigate to {::if resource.active != false}[${resource.oodname}.${resource.hostname}.rcac.purdue.edu](https://${resource.oodname}.${resource.hostname}.rcac.purdue.edu){::else}${resource.oodname}.${resource.hostname}.rcac.purdue.edu{::/}
* Log in using your Career account username and Purdue Login Duo client.

On the splash page you will see a quota usage report. If you are over 90% on any of your quotas a warning will be displayed. This information will update every 10-15 minutes while you are active on Gateway.

Apps
----

There are a number of built-in apps in Gateway that can be accessed from the top menu bar. Below are links to documentation on each app.