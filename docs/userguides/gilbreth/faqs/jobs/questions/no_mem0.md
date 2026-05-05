---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Why cannot I use --mem=0 when submitting jobs?

### Question

Why can't I specify `--mem=0` for my job?

### Answer

We no longer support requesting unlimited memory (`--mem=0`) as it has an adverse effect on the way scheduler allocates job, and could lead to large amount of nodes being blocked from usage.

Most often we suggest relying on default memory allocation (cluster-specific). But if you have to request custom amounts of memory, you can do it explicitly. For example `--mem=20G`.

If you want to use the entire node's memory, you can submit the job with the `--exclusive` option.