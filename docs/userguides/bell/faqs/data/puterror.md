---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# HSI/HTAR: put: Error -5 on transfer

First, check your firewall settings, and ensure that there are no firewall rules interfering with connecting to Fortress. For firewall configuration, please see "[Do I need to do anything to my firewall to access Fortress?](../about/firewall.md)" **If firewalls are not responsible:**

Open the file named /etc/hosts on your workstation, especially if you run a Debian or Ubuntu Linux distribution. Look for a line like:

```

127.0.1.1  hostname.dept.purdue.edu hostname
```

Replace the IP address 127.0.1.1 with the real IP address for your system. If you don't know your IP address, you can find it with the command:

```

host `hostname --fqdn`
```

[**Back to the Data section**](../data.md)
