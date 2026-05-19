---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# HSI/HTAR: Unable to authenticate user with remote gateway (error 2 or 9)

There could be a variety of such errors, with wordings along the lines of

```

Could not initialize keytab on remote server.
result = -2, errno = 2rver connection
*** hpssex_OpenConnection: Unable to authenticate user with remote gateway at 128.211.138.40.1217result = -2, errno = 9
Unable to setup communication to HPSS...
ERROR (main) unable to open remote gateway server connection
HTAR: HTAR FAILED
```

and

```

*** hpssex_OpenConnection: Unable to authenticate user with remote gateway at 128.211.138.40.1217result = -11000, errno = 9
Unable to setup communication to HPSS...
*** HSI: error opening logging
Error - authentication/initialization failed
```

The root cause for these errors is an expired or non-existent keytab file (a special authentication token stored in your home directory). These keytabs are valid for 90 days and on most RCAC resources they are usually automatically checked and regenerated when you execute `hsi` or `htar` commands. However, if the keytab is invalid, or fails to generate, Fortress may be unable to authenticate you and you would see the above errors. This is especially common on those RCAC clusters that have their own dedicated home directories (such as Bell), or on standalone installations (such as if you downloaded and installed HSI and HTAR on your non-RCAC computer).

*This is a temporary problem and a permanent system-wide solution is being developed.* In the interim, the recommended workaround is to generate a new valid keytab file in your main research computing home directory, and then copy it to your home directory on Bell. The `fortresskey` command is used to generate the keytab and can be executed on another cluster or a dedicated data management host `data.rcac.purdue.edu`:

```

$ ssh myusername@data.rcac.purdue.edu fortresskey
$ scp -pr myusername@data.rcac.purdue.edu:~/.private $HOME
```

With a valid keytab in place, you should then be able to use `hsi` and `htar` commands to access Fortress from Bell. Note that only one keytab can be valid at any given time (i.e. if you regenerated it, you may have to copy the new keytab to all systems that you intend to use `hsi` or `htar` from if they do not share the main research computing home directory).
