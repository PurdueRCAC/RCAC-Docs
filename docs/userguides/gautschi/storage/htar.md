---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

## HTAR

HTAR (short for "HPSS TAR") is a utility program that writes TAR-compatible archive files directly onto Gautschi, without having to first create a local file. Its command line was originally based on ```tar```, with a number of extensions added to provide extra features.

HTAR is provided on all research systems as the command ```htar```. HTAR is also available for [download :octicons-link-external-16:](https://rcac.purdue.edu/downloads/archive#hsi) for many operating systems.

Usage:

Create a tar archive on Gautschi named data.tar including all files with the extension ".fits":

```bash
$ htar -cvf data.tar *.fits
HTAR: a   data1.fits
HTAR: a   data2.fits
HTAR: a   data3.fits
HTAR: a   data4.fits
HTAR: a   data5.fits
HTAR: a   /tmp/HTAR_CF_CHK_17953_1317760775
HTAR Create complete for data.tar. 5,120,006,144 bytes written for 5 member files, max threads: 3 Transfer time: 16.457 seconds (311.121 MB/s)
HTAR: HTAR SUCCESSFUL
```

Unpack a tar archive on Gautschi named data.tar into a scratch directory for use in a batch job:

```bash
$ cd $RCAC_SCRATCH/job_dir
$ htar -xvf data.tar
HTAR: x data1.fits, 1024000000 bytes, 2000001 media blocks
HTAR: x data2.fits, 1024000000 bytes, 2000001 media blocks
HTAR: x data3.fits, 1024000000 bytes, 2000001 media blocks
HTAR: x data4.fits, 1024000000 bytes, 2000001 media blocks
HTAR: x data5.fits, 1024000000 bytes, 2000001 media blocks
HTAR: Extract complete for data.tar, 5 files. total bytes read: 5,120,004,608 in 18.841 seconds (271.749 MB/s )
HTAR: HTAR SUCCESSFUL
```

Look at the contents of the data.tar HTAR archive on Gautschi:

```bash
$ htar -tvf data.tar
HTAR: -rw-r--r--  myusername/pucc 1024000000 2011-10-04 16:30  data1.fits
HTAR: -rw-r--r--  myusername/pucc 1024000000 2011-10-04 16:35  data2.fits
HTAR: -rw-r--r--  myusername/pucc 1024000000 2011-10-04 16:35  data3.fits
HTAR: -rw-r--r--  myusername/pucc 1024000000 2011-10-04 16:35  data4.fits
HTAR: -rw-r--r--  myusername/pucc 1024000000 2011-10-04 16:35  data5.fits
HTAR: -rw-------  myusername/pucc        256 2011-10-04 16:39  /tmp/HTAR_CF_CHK_17953_1317760775
HTAR: Listing complete for data.tar, 6 files 6 total objects
HTAR: HTAR SUCCESSFUL
```

Unpack a single file, ```data5.fits```, from the tar archive on Gautschi named data.tar into a scratch directory:

```bash
$ htar -xvf data.tar data5.fits
HTAR: x data5.fits, 1024000000 bytes, 2000001 media blocks
HTAR: Extract complete for data.tar, 1 files. total bytes read: 1,024,000,512 in 3.642 seconds (281.166 MB/s )
HTAR: HTAR SUCCESSFUL
```

## HTAR Archive Verification

HTAR allows different types of content verification while creating archives. Users can ask HTAR to verify the contents of an archive during (or after) creation using the '-Hverify' switch. The syntax of this option is:

```bash
$ htar -Hverify=option[,option...] ... other arguments ... 
```
Where option can be any of the following:

| Option | Explanation |
| ------ | ------ |
| info | Compares tar header info with the corresponding values in the index |
| crc | Enables CRC checking of archive files for which a CRC was generated when the file is added to the archive |
| compare | Enables a byte-by-byte comparison of archive member files and their local file counterparts |
| nocrc | Disables CRC checking of archive files |
| nocompare | Disables a byte-by-byte comparison of archive member files and their local file counterparts |

Users can use a comma-separated list of ```options``` shown above, or a numeric value, or the wildcard ```all``` to specify the degree of verification. The numeric values for ```Hverify``` can be interpreted as follows:

```bash
0: Enables "info" verification.
1: Enables level 0 + "crc" verification.
2: Enables level 1 + "compare" verification.
all: Enables all comparison options.
```

An example to verify an archive during creation using checksums (crc):

```bash
htar -Hverify=1 -cvf abc.tar ./abc
```

An example to verify a previously created archive using checksums (crc):

```bash
htar -Hverify=1 -Kvf abc.tar
```

Please note that the time for verifying an archive increases as you increase the verification level. Carefully choose the option that suits your dataset best.

For details please see the [HTAR Man Page :octicons-link-external-16:](https://rcac.purdue.edu/files/hpss/htar_man.html).

For more information about HTAR:

- [Lawrence Livermore National Labs HTAR User Guide :octicons-link-external-16:](https://hpc.llnl.gov/documentation/user-guides/using-htar-hpss-tape-archiver)

!!!important
    HTAR has an individual file size limit of 64GB. If any files you are trying to archive with HTAR are greater than 64GB, then HTAR will immediately fail. This does not limit the number of files in the archive or the total overall size of the archive. To get around this limitation, try using the ```htar_large``` command. It is slower than using ```htar``` but it will work around the 64GB file size limit. The usage of ```htar_large``` is almost the same as ```htar``` except that ```htar_large``` will not generate the tar index file. Thus, the ```-Hverify=1``` option cannot be used since it's based on the index file. This does not limit the number of files in the archive or the total overall size of the archive.

[**Back to the Storage section**](../storage.md)
