---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Do I need to do anything to my firewall to access ${resource.name}?

{::if resource.name == Fortress}

Yes, any machines using HSI or HTAR must have all firewalls (local and departmental) configured to allow open access from the following IP addresses:

```
128.211.138.154
128.211.138.155
128.211.138.156
128.211.138.157
128.211.138.158
128.211.138.159
128.211.138.160
128.211.138.161
128.211.138.162
128.211.138.163
```

Firewall issues may manifest with error messages like "[put: Error -50 on transfer](/knowledge/${resource.dir}/faq/data/puterror)." If you are unsure of how to modify your firewall settings, please consult with your department's IT support or the documentation for your operating system. Access to Fortress is restricted to on-campus networks. If you need to directly access Fortress from off-campus, please use the Purdue VPN service before connecting.

Note: The list of IP addresses changes occasionally as machines are added or retired.  The list above is current, so if you have other IP addresses in your firewall, they can be safely removed.  In particular, any IPs in the range 128.211.138.40-128.211.138.48 can be removed.

{::else}

No firewall changes are needed to access ${resource.name}. However, to access data through Network Drives (i.e., CIFS, "Z: Drive"), you must be on a Purdue campus network or connected through [VPN](http://www.itap.purdue.edu/connections/vpn/).

{::/}