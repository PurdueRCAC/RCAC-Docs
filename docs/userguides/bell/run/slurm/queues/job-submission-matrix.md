---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Job Submission Matrix

| Job Type | Partition | QoS | Job Submission Options | Number of Cores Per Account | Number of Jobs Per Account | Priority Accrual | Max Walltime |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PI Queue | cpu | normal | `-A "mygroup" -p cpu` | Limited to purchased cores | No limit | No Limit | 2 weeks |
| Standby Job | cpu | standby | `-A "mygroup" -p cpu -q standby` | 15360 Cores | 5000 | No Limit | 4 hours |
| Highmem Job | highmem | normal | `-A "mygroup" -p highmem` | 128 Cores | 2 | 1 | 24 hours |
| GPU Job | gpu | normal | `-A "mygroup" -p gpu` | 128 cores | 1 | 1 | 24 hours |
| Multi GPU Job | multigpu | normal | `-A "mygroup" -p multigpu` | 48 cores | 1 | 1 | 24 hours |

!!! Note
    The normal QOS is the default and does not need to be specified.

[**Back to the Queues section**](../queues.md)
