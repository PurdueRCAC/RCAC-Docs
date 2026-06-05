---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Data Depot Overview

As with the community clusters, research labs will be able to easily purchase capacity in the Data Depot through the [Data Depot Purchase](https://www.rcac.purdue.edu/purchase) page on this site. For more information, please [contact us](/contact).

## Data Depot Features

The Data Depot offers research groups in need of centralized data storage unique features and benefits.

- **Available**

    To any Purdue research group as a purchase in increments of 1 TB at a competitive annual price or you may [request a 100 GB trial space](https://www.rcac.purdue.edu/orders/products?category=3) free of charge. **Participation in the Community Cluster program is not required.**

- **Accessible**

    - As a [Windows or Mac OS X network drive](storage/transfer/cifs.md) on personal and lab computers on campus.
    - Directly on Community Cluster nodes.
    - From other universities or labs [through Globus](storage/transfer/globus.md).

- **Capable**

    The Data Depot facilitates joint work on shared files across your research group, avoiding the need for numerous copies of datasets across individuals' home or scratch directories. It is an ideal place to store group applications, tools, scripts, and documents.

- **Controllable Access**

    Access management is under your direct control. Unix groups can be created for your group and staff can assist you in setting appropriate permissions to allow exactly the access you want and prevent any you do not. Easily manage who has access through [a simple web application](/account/groups) — the same application used to manage access to Community Cluster queues.

- **Data Retention**

    All data kept in the Data Depot remains owned by the research group's lead faculty. When researchers or students leave your group, any files left in their home directories may become difficult to recover. Files kept in Data Depot remain with the research group, unaffected by turnover, and could head off potentially difficult disputes.

- **Never Purged**

    The Data Depot is never subject to purging.

- **Reliable**

    The Data Depot is redundant and protected against hardware failures and accidental deletion. All data is mirrored at two different sites on campus to provide for greater reliability and to protect against physical disasters.

- **Restricted Data**

    The Data Depot **is** suitable for non-HIPAA human subjects data. See the Data Depot [FAQ](faqs.md#what-do-i-need-to-do-in-order-to-store-non-hipaa-human-subjects-data-in-the-data-depot) for a data security statement for your IRB documentation. The Data Depot is **not** approved for regulated data, including HIPAA, ePHI, FISMA, or ITAR data.

[Download Data Depot Features Guide](/assets/pdfs/Research_Data_Depot_white_text.pdf)

## Data Depot Hardware Details

The Data Depot uses an enterprise-class GPFS storage solution with an initial total capacity of over 2 PB. This storage is redundant and reliable, features regular snapshots, and is globally available on all RCAC systems. The Data Depot is non-purged space suitable for tasks such as sharing data, editing files, developing and building software, and many other uses. Built on Data Direct Networks' SFA12k storage platform, the Data Depot has redundant storage arrays in multiple campus datacenters for maximum availability.

!!! note
    **While the Data Depot will scale well for most uses, it is recommended to continue using each cluster's parallel scratch filesystem for use as high-performance working space (scratch) for running jobs.**
