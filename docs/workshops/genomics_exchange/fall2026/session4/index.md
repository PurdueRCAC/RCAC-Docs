---
title: "Genomics Exchange Fall 2026 Session 4: Running nf-core pipelines on clusters (Oct 27, 2026)"
tags:
  - Genomics Exchange
  - Nextflow
  - nf-core
  - Life Sciences
---

# Session 4: Running nf-core pipelines on clusters (Oct 27, 2026)

!!! info "Session details"
    - **Date:** Tuesday, October 27, 2026
    - **Time:** 11:00 AM – 12:00 PM EDT (10:00 – 11:00 AM CDT)
    - **Format:** 60 min live demonstration, online (Microsoft Teams)
    - **Instructor:** Yucheng Zhang, Tufts University
    - **Register:** closed.
    - **Recording:** [Teams Recording](https://purdue0-my.sharepoint.com/:v:/g/personal/aseethar_purdue_edu/IQCBymMfrn6bTbGAly1BJKivAcg-RKMvDkuWIXLq3tMbbH4?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJTdHJlYW1XZWJBcHAiLCJyZWZlcnJhbFZpZXciOiJTaGFyZURpYWxvZy1MaW5rIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXcifX0%3D&e=ubtv4u)
    - **Materials:** [nf-core fundamentals guide](https://zhan4429.github.io/PurdueNfWorkshop/nf-core/) · [GitHub repo](https://github.com/zhan4429/PurdueNfWorkshop)

## Session description

Second of four sessions on Nextflow. Yucheng Zhang (Tufts) showed how to run community-maintained nf-core pipelines on Gautschi without writing any Nextflow: choosing a pipeline from the nf-core catalog, reading a launch command (`-r` for a fixed release, `-profile` for test data and cluster settings, `--input` and `--outdir`), and running nf-core/demo three ways: inside one Slurm job with the `apptainer` profile, with the `purdue_gautschi` institutional profile submitting each task as its own job, and with `--use_standby true` routing short tasks to the standby QoS. Also covered: where pipeline code and container images are cached, reading Slurm output, `work/`, and `.nextflow.log` after a failure, `-resume`, and overriding per-step resources in a `custom.config` by label or process name instead of editing the pipeline. The closing section walked through preparing a samplesheet and reference files for a real nf-core/rnaseq run.

## Prerequisites

- An RCAC account with a Slurm allocation on Gautschi (run `slist` to find your account name)
- Comfortable with the shell and `sbatch` / `squeue`
- Session 3 or basic familiarity with what a Nextflow process and channel are

## Running the materials on Gautschi

Tested Oct 27, 2026 with Nextflow 26.04.2 and Apptainer 1.5.0. Two Gautschi-specific items before the guide's scripts will run:

1. Use `module --force purge` instead of `module purge` in each script. xalt is a sticky module on Gautschi and its `LD_PRELOAD` breaks some container images.
2. Give Nextflow a GitHub token. Gautschi shares one outbound IP, so anonymous GitHub API calls are often rate-limited and `nextflow run nf-core/...` fails at the pull step with "API rate limit exceeded". Create `~/.nextflow/scm` once (a classic personal access token with no scopes is enough for public repos):
   ```groovy
   providers {
       github {
           user = 'YOUR_GITHUB_USERNAME'
           password = 'YOUR_GITHUB_TOKEN'
       }
   }
   ```
   then `chmod 600 ~/.nextflow/scm`.

With both in place, all three demo routes complete in under four minutes each. For your own analyses, prefer `--cluster_account "$SLURM_JOB_ACCOUNT"` in the launch command so the account only has to be set once, in the `#SBATCH` header. See also the [RCAC Nextflow on Gautschi guide](https://docs.rcac.purdue.edu/lifesciences/guides/nextflow-gautschi/).

## Next session

[Session 5: Script to pipeline (Nov 10, 2026)](session-5.md)

[Back to Fall 2026](../index.md)
