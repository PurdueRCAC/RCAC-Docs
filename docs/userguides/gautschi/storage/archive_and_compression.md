---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

There are several options for archiving and compressing groups of files or directories. The mostly commonly used options are: 

## tar

See the [official documentation](http://www.gnu.org/software/tar/tar.html) for tar for more information.

Saves many files together into a single archive file, and restores individual files from the archive. Includes automatic archive compression/decompression options and special features for incremental and full backups.

Examples:

```bash
  # (list contents of archive somefile.tar)
$ tar tvf somefile.tar

  # (extract contents of somefile.tar)
$ tar xvf somefile.tar

  # (extract contents of gzipped archive somefile.tar.gz)
$ tar xzvf somefile.tar.gz

  # (extract contents of bzip2 archive somefile.tar.bz2)
$ tar xjvf somefile.tar.bz2

  # (archive all ".c" files in current directory into one archive file)
$ tar cvf somefile.tar *.c

  # (archive and gzip-compress all files in a directory into one archive file)
$ tar czvf somefile.tar.gz somedirectory/

  # (archive and bzip2-compress all files in a directory into one archive file)
$ tar cjvf somefile.tar.bz2 somedirectory/
```

Other arguments for ```tar``` can be explored by using the ```man tar``` command.

## gzip

See [documention](http://www.gnu.org/software/gzip/gzip.html) for more info.

The standard compression system for all GNU software.

Examples:

```bash
  # (compress file somefile - also removes uncompressed file)
$ gzip somefile

  # (uncompress file somefile.gz - also removes compressed file)
$ gunzip somefile.gz
```

## bzip2

See the [official documentation](http://www.bzip.org/) for bzip for more information.

Strong, lossless data compressor based on the Burrows-Wheeler transform. Stronger compression than gzip.

Examples:

```bash
  # (compress file somefile - also removes uncompressed file)
$ bzip2 somefile

  # (uncompress file somefile.bz2 - also removes compressed file)
$ bunzip2 somefile.bz2
```

There are several other, less commonly used, options available as well:
- zip
- 7zip
- xz

[**Back to the Storage section**](../storage.md)
