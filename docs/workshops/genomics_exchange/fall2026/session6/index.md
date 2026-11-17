---
title: "Genomics Exchange Fall 2026 Session 6: nf-core on Open OnDemand (Nov 17, 2026)"
tags:
  - Genomics Exchange
  - Nextflow
  - nf-core
  - Life Sciences
---

# Session 6: nf-core on Open OnDemand (Nov 17, 2026)

!!! info "Session details"
    - **Date:** Tuesday, November 17, 2026
    - **Time:** 11:00 AM – 12:00 PM EST (10:00 – 11:00 AM CST)
    - **Format:** 60 min interactive workshop, online (Microsoft Teams)
    - **Instructor:** Arun Seetharam
    - **Register:** closed.
    - **Recording:** [Teams Recording](https://purdue0-my.sharepoint.com/:v:/g/personal/aseethar_purdue_edu/IQAghHegKXM5TY9z41nLWq0oAQG-hiW3m5HQDe8PlfQTTwc?e=u083SB)
    - **Materials:** [Run nf-core Pipelines in Open OnDemand](../../../../lifesciences/tutorials/nfcore-ondemand.md)

## Session description

This session showed how to run nf-core pipelines on Gautschi from a web browser, using the nf-core Pipelines app in Open OnDemand, without writing job scripts. After a short introduction to nf-core and Nextflow, the live demo ran nf-core/rnaseq 3.26.0 on the pipeline's test dataset: choosing a pipeline by assay, preparing the samplesheet and reference files, filling in the scheduling and pipeline sections of the form, launching, and monitoring the launcher and child Slurm jobs. We then reviewed the outputs of a completed run (the execution report and timeline, the parameters and software versions files, and the MultiQC report), explained how to resume an interrupted run, and ran the same analysis from the command line with a batch script. Questions covered availability on other clusters, requesting additional pipelines, and how R scripts fit into Nextflow workflows.

The [tutorial](../../../../lifesciences/tutorials/nfcore-ondemand.md) covers every step in detail, along with data staging, troubleshooting, and FAQs.

## Prerequisites

None to watch the recording. To run the tutorial yourself, you need a Gautschi account with a Slurm account (run `slist` to check) and a web browser. Background from [Session 3](../session3/index.md) and [Session 4](../session4/index.md), or the [Nextflow and nf-core guide](../../../../lifesciences/guides/nextflow.md), is helpful.

## Next session

- [Session 5: Script to pipeline (Nov 24, 2026)](../session5/index.md), rescheduled from Nov 10
- [Session 7: R/RStudio and r-bioconductor on RCAC clusters (Dec 1, 2026)](../session7/index.md)

[Back to Fall 2026](../index.md)
