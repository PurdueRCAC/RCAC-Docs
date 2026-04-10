---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

HSI, the Hierarchical Storage Interface, is the preferred method of transferring files to and from Gautschi. HSI is designed to be a friendly interface for users of the High Performance Storage System (HPSS). It provides a familiar Unix-style environment for working within HPSS while automatically taking advantage of high-speed, parallel file transfers without requiring any special user knowledge.

HSI is provided on all research systems as the command ```hsi```. HSI is also available for [download :octicons-link-external-16:](https://rcac.purdue.edu/downloads/archive#hsi) for many operating systems.

Interactive usage:

```bash
$ hsi

*************************************************************************
*                    Purdue University
*                  High Performance Storage System (HPSS)
*************************************************************************
* This is the Purdue Data Archive, Fortress.  For further information
* see http://www.rcac.purdue.edu/storage/fortress/
*
*   If you are having problems with HPSS, please call IT/Operational
*   Services at 49-44000 or send E-mail to rcac-help@purdue.edu.
*
*************************************************************************
Username: myusername  UID: 12345  Acct: 12345(12345) Copies: 1 Firewall: off [hsi.3.5.8 Wed Sep 21 17:31:14 EDT 2011]

[Fortress HSI]/home/myusername->put data1.fits
put  'test' : '/home/myusername/test' ( 1024000000 bytes, 250138.1 KBS (cos=11))

[Fortress HSI]/home/myusername->lcd /tmp

[Fortress HSI]/home/myusername->get data1.fits
get  '/tmp/data1.fits' : '/home/myusername/data1.fits' (2011/10/04 16:28:50 1024000000 bytes, 325844.9 KBS )

[Fortress HSI]/home/myusername->quit
```

Batch transfer file:

```bash
put data1.fits
put data2.fits
put data3.fits
put data4.fits
put data5.fits
put data6.fits
put data7.fits
put data8.fits
put data9.fits
```

Batch usage:

```bash
$ hsi < my_batch_transfer_file
*************************************************************************
*                    Purdue University
*                  High Performance Storage System (HPSS)
*************************************************************************
* This is the Purdue Data Archive, Fortress.  For further information
* see http://www.rcac.purdue.edu/storage/fortress/
*
*   If you are having problems with HPSS, please call IT/Operational
*   Services at 49-44000 or send E-mail to rcac-help@purdue.edu.
*
*************************************************************************
Username: myusername  UID: 12345  Acct: 12345(12345) Copies: 1 Firewall: off [hsi.3.5.8 Wed Sep 21 17:31:14 EDT 2011]
put  'data1.fits' : '/home/myusername/data1.fits' ( 1024000000 bytes, 250200.7 KBS (cos=11))
put  'data2.fits' : '/home/myusername/data2.fits' ( 1024000000 bytes, 258893.4 KBS (cos=11))
put  'data3.fits' : '/home/myusername/data3.fits' ( 1024000000 bytes, 222819.7 KBS (cos=11))
put  'data4.fits' : '/home/myusername/data4.fits' ( 1024000000 bytes, 224311.9 KBS (cos=11))
put  'data5.fits' : '/home/myusername/data5.fits' ( 1024000000 bytes, 323707.3 KBS (cos=11))
put  'data6.fits' : '/home/myusername/data6.fits' ( 1024000000 bytes, 320322.9 KBS (cos=11))
put  'data7.fits' : '/home/myusername/data7.fits' ( 1024000000 bytes, 253192.6 KBS (cos=11))
put  'data8.fits' : '/home/myusername/data8.fits' ( 1024000000 bytes, 253056.2 KBS (cos=11))
put  'data9.fits' : '/home/myusername/data9.fits' ( 1024000000 bytes, 323218.9 KBS (cos=11))
EOF detected on TTY - ending HSI session
```

For more information about HSI:

- [HSI Reference Manual :octicons-link-external-16:](https://rcac.purdue.edu/files/hpss/hsi_9.3_reference_manual.pdf)
- [Lawrence Livermore National Lab HSI User Guide :octicons-link-external-16:](https://hpc.llnl.gov/documentation/user-guides/using-hsi-hierarchical-storage-interface)

[**Back to the Storage section**](../storage.md)
