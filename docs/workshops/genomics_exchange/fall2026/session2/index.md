---
title: "Genomics Exchange Fall 2026 Session 2: Data management for biologists (Sep 29, 2026)"
tags:
  - Genomics Exchange
  - Data Management
  - Life Sciences
---

# Session 2: Data management for biologists (Fortress, Depot, Globus, DMP text) (Sep 29, 2026)

!!! info "Session details"
    - **Date:** Tuesday, September 29, 2026
    - **Time:** 11:00 AM – 12:00 PM EDT (10:00 – 11:00 AM CDT)
    - **Format:** 60 min interactive workshop, online (Microsoft Teams)
    - **Instructors:** Arun Seetharam and Rose Wilfong (RCAC)
    - **Register:** [Register for Session 2 on Microsoft Teams](https://events.teams.microsoft.com/event/f99c5474-7bdf-4987-9391-52e14578676b@4130bd39-7c53-419c-b1e5-8758d6d63f21). The Teams join link is sent to registrants.
    - **Recording:** [recording link coming soon]
    - **Materials:** This page.

This page is for Purdue faculty, postdocs, students, and staff in the life sciences who store or analyze research data on RCAC systems, whether or not you attended the session. It explains what each RCAC storage tier (home, scratch, Data Depot, Fortress) is for, how to share data within your lab and archive it to tape, how Globus moves data between tiers and to collaborators, and what to write in an NIH Data Management and Sharing (DMS) Plan. It ends with a five-step checklist to complete before your lab generates new data. No prior HPC experience is needed. An RCAC account and your lab's Data Depot group name help you run the commands.

## The data lifecycle on RCAC

RCAC has four storage tiers, each built for a different stage of a project. The most common mistake is leaving the only copy of important data in scratch.

A typical genomics project moves through the tiers like this:

1. Raw data arrives from the sequencing core. Put it on **Data Depot** and archive a copy to **Fortress** right away. For sequence data you will share, consider also submitting to NCBI (SRA or GEO) now with a release hold. NCBI keeps it private and releases it when the accession is published. Fortress remains your exact-copy backup; SRA does not return files byte-for-byte as submitted.
2. Copy the inputs your jobs need into **scratch** and run the analysis there.
3. Copy results worth keeping back to **Data Depot**.
4. When the project ends or the paper is published, bundle the project and archive it to **Fortress**.

**Home** holds your scripts, configuration files, and small documents, never sequencing data.

| | Home | Scratch | Data Depot | Fortress |
|---|---|---|---|---|
| **Purpose** | Scripts, configs, small files | Working space for running jobs | Shared, active lab data | Long-term archive (tape) |
| **Capacity** | 25 GB per user (TODO(arun): verify) | Large per-user quota; check with `myquota` | Purchased in 1 TB increments; 100 GB free trial | No quota |
| **Backup** | Nightly snapshots, kept up to about 3 months | None | Nightly snapshots, kept up to about 3 months; mirrored at two campus sites | Two copies on separate media; no protection against deletion |
| **Cost** | Included | Included | See the [RCAC orders page](https://www.rcac.purdue.edu/orders/products?category=3) (sign-in required) | Free with RCAC cluster access |
| **Purge** | Never | Files not accessed or modified in 60 days (30 days on Bell and Anvil) | Never | Never |
| **Who pays** | Included with your RCAC account | Included with your RCAC account | The lab (PI), annually | Included with RCAC services; storing more than 1 PB may incur a cost recovery charge |

!!! warning "Scratch purge"
    Scratch is not backed up, and RCAC no longer sends warning emails before a purge. Run `purgelist` on a cluster to see which of your scratch files are scheduled for removal.

Snapshots let you recover from accidental deletion for a limited time, but they are not a backup. A file deleted on the day it was created cannot be recovered. See [Data Depot lost file recovery](../../../../userguides/depot/recover/index.md).

## Depot and Fortress in practice

### Getting Data Depot for your lab

- The PI purchases capacity on the [Data Depot Purchase](https://www.rcac.purdue.edu/purchase) page, in 1 TB increments at an annual rate. You do not need to own cluster nodes.
- To try it first, [request a free 100 GB trial](https://www.rcac.purdue.edu/orders/products?category=3).
- Data on Depot belongs to the PI's research group, not to individuals, so it stays with the lab when students and postdocs leave.
- Each Depot group also gets a shared Fortress group space at `/group/mylab/`.

### Sharing and permissions

A lab's Depot space is `/depot/mylab/`, where `mylab` is your group name. By default it has a `data/` folder for shared research data and an `apps/` folder for shared software. Unix groups control access: for example, write access to `/depot/mylab/data/` requires membership in `mylab-data`. The PI or a designee manages membership on the [RCAC group management page](https://www.rcac.purdue.edu/account/groups). New members must log out and back in before their access takes effect.

Depot is suitable for non-HIPAA human subjects data. It is not approved for HIPAA, ePHI, FISMA, ITAR, or other regulated data.

### Fortress: hsi and htar

Fortress is a tape library. You cannot log in to it with SSH. From any RCAC cluster, use `hsi` to manage files and `htar` to create archives. No keytab setup is needed on RCAC systems.

Fortress stores a few large files efficiently but many small files very slowly. A file under about 30 to 50 MB counts as "small" at Fortress scale. Bundle directories of FASTQ files, per-sample outputs, or pipeline work folders into archives before sending them to Fortress. `htar` does this in one step, without needing local disk space for the archive.

### Commands

Replace `mylab` with your group name and `project_2026` with your project directory.

Check which lab storage groups you belong to:

```bash
groups
```

Count the files in a project directory before archiving (thousands of files means bundle them):

```bash
find /depot/mylab/data/project_2026 -type f | wc -l
```

Bundle a project directory into one archive in your lab's Fortress space, with checksum verification:

```bash
cd /depot/mylab/data
htar -Hverify=1 -cvf /group/mylab/project_2026.tar project_2026
```

List the contents of that archive without restoring it:

```bash
htar -tvf /group/mylab/project_2026.tar
```

List what is in your lab's Fortress space:

```bash
hsi ls -l /group/mylab
```

!!! note
    `htar` cannot archive a single file larger than 64 GB. Use `htar_large` for those files, or compress and `hsi put` them individually. Archiving a large project can take hours, so run it inside a batch job rather than on a login node.

!!! danger "Deletion on Fortress is permanent"
    Fortress keeps two copies of every file to protect against media failure, but if you delete or overwrite a file on Fortress, it cannot be recovered.

## Globus

### Globus endpoints at RCAC

TODO(arun): Rose to write.

### Transferring to Depot and Fortress

TODO(arun): Rose to write.

### Sharing with external collaborators

TODO(arun): Rose to write.

### Globus Connect Personal

TODO(arun): Rose to write.

## DMP text

### What the NIH policy means for your lab

The [NIH Data Management and Sharing Policy](https://sharing.nih.gov/data-management-and-sharing-policy), effective January 25, 2023, requires a Data Management and Sharing Plan for NIH-funded research that generates scientific data. Three parts of it change what your lab does day to day:

- **Share in an established repository.** Use a domain repository where one exists (for example, SRA for reads, GEO for expression data, dbGaP for controlled-access human data). RCAC storage keeps your data safe but is not a public sharing repository.
- **Share on time.** Share data no later than the associated publication or the end of the award period, whichever comes first.
- **Submit early, release later.** Submitting raw reads to SRA or GEO at the start of a project, with a release hold, settles the repository and metadata up front. NCBI releases held data once the accession is published. TODO(arun): verify current maximum hold period and extension process. Do not use this route for human participant data; controlled-access data belongs in dbGaP.

### Getting help writing a DMP

!!! tip "Contact PURR for DMP help"
    For help writing a DMP, including templates and review, contact [PURR](https://purr.purdue.edu/). PURR is also a Purdue data repository that assigns DOIs, an option for data that has no domain repository such as SRA or GEO.

### RCAC storage text for your DMP or facilities statement

Paste this paragraph into your DMP template or facilities statement. Replace the bracketed fields and delete any sentence that does not apply to your project.

> Data will be stored on the Purdue Research Data Depot, operated by the Rosen Center for Advanced Computing (RCAC). Data Depot is enterprise-class GPFS storage mirrored across two campus data centers to protect against hardware failure and physical disaster, with nightly snapshots retained for up to three months to recover from accidental deletion. Access is restricted to members of the [LAB NAME] group, whose membership is authorized by the PI. Analyses will be performed on RCAC community clusters, which provide high-performance scratch storage for active computation. Raw data and final results will be archived on Fortress, RCAC's tape archive with a capacity of over 200 PB, which keeps two copies of every file on separate media. Data will be retained for [NUMBER] years after the end of the award, and data underlying publications will be deposited in [REPOSITORY, for example SRA or GEO] no later than the time of publication.

TODO(arun): verify this paragraph with RCAC before sharing it as approved text. For non-HIPAA human subjects data on Depot, RCAC provides [IRB-ready data security text](../../../../userguides/depot/faqs.md#what-do-i-need-to-do-in-order-to-store-non-hipaa-human-subjects-data-in-the-data-depot).

## Summary

**Before you generate data, do these 5 things:**

1. **Get Data Depot space for the lab** (purchase or trial) and agree on a folder layout.
2. **Set up access:** decide who needs read or write access and add them to the lab's Unix groups.
3. **Map each stage to a tier:** raw data on Depot, working files in scratch, results back on Depot, finished projects on Fortress.
4. **Archive raw data to Fortress on arrival**, bundled with `htar` and verified.
5. **Write the DMP now:** choose the sharing repository, the metadata standard, and the retention period. PURR can help.

**Feedback survey:** [Take the post-session survey](https://purdue.ca1.qualtrics.com/jfe/form/SV_5zozxPOpfZsjyui)

**Next session:** Tuesday, October 20, 2026, 11:00 AM EDT. [Nextflow fundamentals](../session3/index.md), with guest instructor Yucheng Zhang (Tufts University). [Register on Microsoft Teams](https://events.teams.microsoft.com/event/46244839-e339-4751-aa98-7ec633a06b1f@4130bd39-7c53-419c-b1e5-8758d6d63f21).

## Links

- [Data Depot overview](../../../../userguides/depot/overview.md)
- [Data Depot permissions and Unix groups](../../../../userguides/depot/permissions/unixgroups.md)
- [Data Depot file transfer, including Globus](../../../../userguides/depot/storage/transfer.md)
- [Fortress accounts and group space](../../../../userguides/fortress/accounts.md)
- [Fortress HSI](../../../../userguides/fortress/storage/transfer/hsi.md) and [HTAR](../../../../userguides/fortress/storage/transfer/htar.md)
- [Fortress with Globus](../../../../userguides/fortress/storage/transfer/globus.md)
- [Fortress limitations, including small files](../../../../userguides/fortress/faqs.md#what-limitations-does-fortress-have)

[Back to Fall 2026](../index.md)
