---
title: "Genomics Exchange Fall 2026 Session 5: Script to pipeline (Nov 10, 2026)"
tags:
  - Genomics Exchange
  - Nextflow
  - Life Sciences
---

# Session 5: Script to pipeline (Nov 10, 2026)

!!! info "Session details"
    - **Date:** Tuesday, November 10, 2026
    - **Time:** 11:00 AM – 12:00 PM EST (10:00 – 11:00 AM CST)
    - **Format:** 60 min interactive workshop, online (Microsoft Teams)
    - **Instructor:** Arun Seetharam
    - **Register:** [Register for Session 5 on Microsoft Teams](https://events.teams.microsoft.com/event/d93666fc-4812-48a5-a3ab-dbe5d9e65d63@4130bd39-7c53-419c-b1e5-8758d6d63f21). The Teams join link is sent to registrants.
    - **Recording:** TBD
    - **Materials:** [rcac-bioinformatics/script-to-pipeline](https://github.com/rcac-bioinformatics/script-to-pipeline) on GitHub (tag `v1.0.0`)
    - **Guide:** [Script to Pipeline: Turning Your Scripts into a Nextflow Workflow](../../../../lifesciences/guides/script-to-pipeline.md)

This page is for Purdue researchers who already run an analysis by hand, as a shell, R, or Python script, and want it to run many samples in parallel on RCAC clusters and be easy for a collaborator to rerun. The session converts a small variant-calling script on *Escherichia coli* samples into a Nextflow workflow on Negishi, one step at a time, without rewriting the commands. It covers turning script steps into processes, connecting them with channels, moving tool options and inputs into configuration, pinning software with containers, resuming after a change, and handing the finished workflow to a collaborator. The [companion guide](../../../../lifesciences/guides/script-to-pipeline.md) has every command and file from the session.

## Prerequisites

- An RCAC account with access to Negishi and a SLURM account to charge (run `slist` to list yours)
- Familiarity with Nextflow channels, processes, and `-profile`, as covered in [Session 3, Nextflow fundamentals](../session3/index.md)
- Experience running an nf-core pipeline on a cluster, as covered in [Session 4, Running nf-core pipelines on clusters](../session4/index.md)
- A shell, R, or Python analysis you already run by hand

**Next session:** Tuesday, November 17, 2026, 11:00 AM EST. [nf-core on Open OnDemand](../session6/index.md). [Register on Microsoft Teams](https://events.teams.microsoft.com/event/08b0b31b-8f2c-48b0-9174-df305a1c3640@4130bd39-7c53-419c-b1e5-8758d6d63f21).

[Back to Fall 2026](../index.md)
