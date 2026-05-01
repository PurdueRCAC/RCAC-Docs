---
tags:
  - Gautschi
authors:
  - jin456
  - remender
resource: Gautschi
search:
  boost: 2
---

## Storage Options

File storage options on RCAC systems include long-term storage (home directories, depot, Fortress) and short-term storage (scratch directories, /tmp directory). Each option has different performance and intended uses, and some options vary from system to system as well. Daily snapshots of home directories are provided for a limited time for accidental deletion recovery. Scratch directories and temporary storage are not backed up and old files are regularly purged from scratch and /tmp directories. More details about each storage option appear below. 

- [Home Directory](storage/home_directory.md)
- [Scratch Space](storage/scratch_space.md)
- [/tmp Directory](storage/tmp_directory.md)
- [Long-Term Storage](storage/long_term_storage.md)

### Other Storage Topics
- [Storage Quota / Limits](storage/storage_quota.md)
- [Storage Environment Variables](storage/environment_variables.md)
- [Archive and Compression](storage/archive_and_compression.md)
- [Sharing](storage/sharing.md)

## File Transfer

Gautschi supports several methods for file transfer. Use the links below to learn more about these methods. 

- [Globus](storage/globus.md)
- [Windows Network Drive / SMB](storage/windows_network_drive.md)
- [SCP](storage/scp.md)
- [FTP / SFTP](storage/ftp_sftp.md)
- [HSI](storage/hsi.md)
- [HTAR](storage/htar.md)

