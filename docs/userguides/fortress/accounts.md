---
tags:
  - Fortress
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Accounts on Fortress

## Obtaining an Account

All Purdue faculty, staff, and students participating in the Community Cluster program have access to Fortress along with their cluster nodes and scratch space. Your home directory on Fortress is the default directory in which your archive files are stored and will appear as `/home/username`, but this is not the same directory as your home directory on any other Purdue IT systems. Your home directory on Fortress is your long-term storage directory for all Purdue IT systems.

Research groups are assigned a group data storage space within Fortress with each Data Depot group space. Faculty should [request a Data Depot trial](https://www.rcac.purdue.edu/purchase#datadepot) to create a shared Fortress space for their research group. The actual location for the group space on Fortress is `/group/mylab/` (replace `mylab` with your group name).

!!! info 
    RCAC computing resources are not intended to store data protected by Federal privacy and security laws (e.g., HIPAA, ITAR, classified, etc.). It is the responsibility of the faculty partner to ensure that no protected data is stored on the systems.

- Particularly in the case of group storage, please keep in mind that such spaces are, by design, accessible by others and should not be used to store private information such as grades, login credentials, or personal data.

Fortress sets no limits on the amount or number of files that you may store. However, there are several restrictions on the nature of files you may store:

- Many small files: Fortress is a tape archive and works best with a few, large files. Large sets of small files should be compressed into archives with utilities such as [htar](storage/transfer/htar.md). Other technical limitations are [detailed on the Fortress FAQs](faqs.md#what-limitations-does-fortress-have).
- Backing up individual or departmental computers. Fortress is intended to be a research data store and not a personal or enterprise backup solution.

Additionally, while Fortress access is included with RCAC services, storing more than 1 PB of data may incur a cost recovery charge.

## Outside Collaborators

Your Departmental Business Office can submit a [Request for Privileges (R4P)](https://service.purdue.edu/TDClient/32/Purdue/KB/Article/33/What-is-a-Request-for-Privileges-R4P) to provide access to collaborators outside Purdue, including recent graduates.

## Login & Keytabs

It is not possible to login directly to Fortress via SSH or SCP. You may access your files there efficiently using HSI, HTAR, or SFTP.

A *keytab* file is required to log into Fortress via HSI or HTAR. However, **all RCAC systems may access Fortress without any keytab preparation.** If for some reason you lose your keytab, you may easily regenerate one on any RCAC system by running the command `fortresskey`.

However, to access Fortress from a **personal or departmental computer**, you will need to first copy your keytab file to the computer you wish to use. This keytab can be found in your research home directory, within the hidden subdirectory named ".private" as the file "hpss.unix.keytab" (`~/.private/hpss.unix.keytab`). This keytab will allow you to access HPSS services without needing to type a password and will remain valid for 90 days. Your keytab on RCAC systems will automatically be regenerated after this time, and you will need to re-copy the new keytab file to any other computers you use to directly access Fortress then.

If you do not have an account on any RCAC systems other than Fortress, you will need to generate a keytab file using the web interface:

- [Web Form to Generate New Fortress Keytab](https://www.rcac.purdue.edu/fortresskey)

!!! warning "Warning"
    Using this invalidates your existing keytab on RCAC systems in the `~/.private/hpss.unix.keytab` file.
