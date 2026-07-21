---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Frequently Asked Questions

Frequently asked questions about Data Depot.

## About Data Depot

### Can you remove me from the Data Depot mailing list?

Your subscription in the Data Depot mailing list is tied to your account associated with your group(s) on Data Depot. If you are no longer using Data Depot, you can fist find your associated group(s) that have active Data Depot access from your [Storage Quotas](https://www.rcac.purdue.edu/account/quotas) page. Then you could contact the group PI or managers or [rcac-help](mailto:rcac-help@purdue.edu) to remove you from the group(s) Data Depot. Your account and mailing list subscription will be removed overnight. Be sure to make a copy of any data you wish to keep first.

### What sort of performance should I expect to and from the Data Depot?

The Data Depot is designed to be a high-capacity, fast, reliable and secure data storage system for research data. During acceptance testing, a number of performance baselines were measured:

| Access type | Large file, reading | Large file, writing | Many small files, reading | Many small files, writing |
|---|---|---|---|---|
| CIFS access, single client (GigE) | 102.1 MB/sec | 71.64 MB/sec | 12.43 MB/sec | 11.57 MB/sec |

### Is the Data Depot just a file server?

The Data Depot is a suite of file service tools, specifically targeted at the needs of an academic research lab. More than just the file service infrastructure and hardware, the Data Depot also encompasses self-service access management, permissions control, and file sharing with [RCAC Globus Server](http://transfer.rcac.purdue.edu).

### Do I need to do anything to my firewall to access Data Depot?

No firewall changes are needed to access Data Depot. However, to access data through [Network Drives / CIFS](storage/transfer.md#windows-network-drive--smb) (i.e., CIFS, "Z: Drive"), you must be on a Purdue campus network or connected through [VPN](https://it.purdue.edu/services/vpn.php).

### What is the best way to mount Data Depot in my lab?

You can mount your Data Depot space via [Network Drives / CIFS](storage/transfer.md#windows-network-drive--smb) using your Purdue Career Account credentials.

See the [Windows Network Drive / SMB](storage/transfer.md#windows-network-drive--smb) documentation for step-by-step instructions for Windows, Mac OS X, and Linux.

### How do Data Depot, Fortress, and PURR relate to each other?

The Data Depot, Fortress, and PURR, are complementary parts of Purdue's infrastructure for working with research data. The Data Depot is designed for large, actively-used, persistent research data; Fortress is intended for long-term, archival storage of data and results; and PURR is for management, curation, and long-term preservation of research data.


## Data

### Can I store Export-controlled data on Data Depot?

The Data Depot is not approved for storing data requiring Export control including ITAR, FISMA, DFAR-7012, NIST 800-171.

Please contact the [Export Control Office](http://www.purdue.edu/research/research-compliance/export-control/) to discuss technology control plans and data storage appropriate for export controlled projects.

### Can I store HIPAA data on Data Depot?

The Data Depot is not approved for storing data covered by HIPAA. Please contact the [HIPAA Compliance Office](http://www.purdue.edu/hipaa/) to discuss HIPAA-compliant data storage.

### What do I need to do in order to store non-HIPAA human subjects data in the Data Depot?

Use the following IRB-approved text in your IRB documentation when describing your data safeguards, substituting the PI's name for "PROFESSORNAME":

!!!info
    Only individuals specifically approved by PROFESSORNAME may access project data in the Research Data Depot. All membership in the PROFESSORNAME group is authorized by the project PI(s) and/or designees. Purdue University has network firewalls and other security devices to protect the Research Data Depot infrastructure from outside the campus.

    Purdue Career accounts have password security policies that enforce age and quality requirements.

    Auditing is enabled on Research Data Depot fileservers to track login attempts, maintain logs, and generate reports of access attempts.

### Can I share data with outside collaborators?

Yes! Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions. See the Globus documentation on how to share data:

- <https://docs.globus.org/how-to/share-files/>
