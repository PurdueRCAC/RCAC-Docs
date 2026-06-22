---
tags:
  - Fortress
authors:
  - jin456
  - ramonw
search:
  boost: 2
draft: false
---

# Frequently Asked Questions

Frequently asked questions about Fortress.

## About Fortress

### Can you remove me from the Fortress mailing list?

Your subscription in the Fortress mailing list is tied to your account on Fortress. If you are no longer using your account on Fortress, your account can be deleted from the [My Accounts](https://www.rcac.purdue.edu/account/myinfo) page. Hover over the resource you wish to remove yourself from and click the red 'X' button. Your account and mailing list subscription will be removed overnight. Be sure to make a copy of any data you wish to keep first.

### Do I need to do anything to my firewall to access Fortress?

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

Firewall issues may manifest with error messages like "[put: Error -50 on transfer](#hsihtar-put-error--5-on-transfer)." If you are unsure of how to modify your firewall settings, please consult with your department's IT support or the documentation for your operating system. Access to Fortress is restricted to on-campus networks. If you need to directly access Fortress from off-campus, please use the Purdue VPN service before connecting.

!!!info
    The list of IP addresses changes occasionally as machines are added or retired. The list above is current, so if you have other IP addresses in your firewall, they can be safely removed. In particular, any IPs in the range 128.211.138.40-128.211.138.48 can be removed.

### Can I download HSI or HTAR binaries for my OS platform?

Yes, visit the [Downloads](https://www.rcac.purdue.edu/downloads/archive#hsi) page to download HSI or HTAR packages for your operating system.

!!!info
    **Note:** If your username on your desktop does not match your career account username, HSI and HTAR require configuration to connect using your career account username:

- For HSI, use the `-l careeraccount` option on the `hsi` command line.
- For HTAR, set the `HPSS_PRINCIPAL` environment variable to your career account username:

    bash: `export HPSS_PRINCIPAL=careeraccount`

    csh/tcsh: `setenv HPSS_PRINCIPAL=careeraccount`

### What limitations does Fortress have?

Fortress has a few limitations that you should keep in mind:

- Fortress does not support direct FTP or SCP transfers. SFTP connections are supported.
- Fortress does not support Unicode filenames. All filenames must contain only ASCII characters.
- Fortress does not support sparse files.
- Fortress is a tape archive. While it can handle use case of *"multitude of small files"*, performance may be severely decreased (compared to a much preferred case of *"fewer files of much larger size"*). If you need to store a large number of small files, we strongly recommend that you bundle them up first (with `zip`, `tar`, `htar`, etc) before placing resulting archive into Fortress. Note: a *"small file"* on Fortress scale is typically considered something under 30-50MB per file.
- HTAR has an individual file size limit of 64GB. If any files you are trying to archive with HTAR are greater than 64GB, then HTAR will immediately fail. This does not limit the number of files in the archive or the total overall size of the archive. To get around this limitation, try using the `htar_large` command. It is slower than using HTAR but it will work around the 64GB file size limit.

## Data

### What is the best way to access my data?

[HSI](storage/transfer/hsi.md) and [HTAR](storage/transfer/htar.md): HSI provides a FTP-style interface taking advantage of the power of HPSS without requiring any special user knowledge. HTAR is a utility to aggregate a set of files into a single tar archive directly into Fortress, without requiring space to first create an archive.

### Can I set up a shared space for my research group to share data?

Research groups are assigned a group data storage space within Fortress with each Data Depot group space. Faculty should [request a Data Depot trial](https://www.rcac.purdue.edu/purchase#datadepot) to create a shared Fortress space for their research group.

!!!note
    RCAC resources are not intended to store data protected by Federal privacy and security laws (e.g., HIPAA, ITAR, classified, etc.). It is the responsibility of the faculty partner to ensure that no protected data is stored on the systems.

Please keep in mind that such spaces are, by design, accessible by others and should not be used to store private information such as grades, login credentials, or personal data. [Contact us](mailto:rcac-help@purdue.edu) to create a group space for your group.

### How can I verify the contents of my archives while using HTAR?

You can ask HTAR to verify the contents of an archive during or after creation using the `-Hverify` switch. Please see the [HTAR](storage/transfer/htar.md#htar-archive-verification) documentation for details.

### HSI/HTAR: put: Error -5 on transfer

First, check your firewall settings, and ensure that there are no firewall rules interfering with connecting to Fortress. For firewall configuration, please see "[Do I need to do anything to my firewall to access Fortress?](#do-i-need-to-do-anything-to-my-firewall-to-access-fortress)" **If firewalls are not responsible:**

Open the file named `/etc/hosts` on your workstation, especially if you run a Debian or Ubuntu Linux distribution. Look for a line like:

```
127.0.1.1  hostname.dept.purdue.edu hostname
```

Replace the IP address `127.0.1.1` with the real IP address for your system. If you don't know your IP address, you can find it with the command:

```
host `hostname --fqdn`
```

### Can I share data with outside collaborators?

Yes! Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions. See the Globus documentation on how to share data:

- <https://docs.globus.org/how-to/share-files/>

### HSI/HTAR: Unable to authenticate user with remote gateway (error 2 or 9)

There could be a variety of such errors, with wordings along the lines of:

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

*This is a temporary problem and a permanent system-wide solution is being developed.* In the interim, the recommended workaround is to generate a new valid keytab file in your main research computing home directory, and then copy it to your home directory on Fortress. The `fortresskey` command is used to generate the keytab and can be executed on another cluster or a dedicated data management host `data.rcac.purdue.edu`:

```
$ ssh username@data.rcac.purdue.edu fortresskey
$ scp -pr username@data.rcac.purdue.edu:~/.private $HOME
```

With a valid keytab in place, you should then be able to use `hsi` and `htar` commands to access Fortress. Note that only one keytab can be valid at any given time (i.e. if you regenerated it, you may have to copy the new keytab to all systems that you intend to use `hsi` or `htar` from if they do not share the main research computing home directory).
