---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
hide:
  - toc

---

# Job Submission Matrix


| Job Type | Partition | QoS | Job Submission Options | Number of Cores Per Account | Number of Jobs Per Account | Priority Accrual | Max Walltime |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PI Queue | cpu | normal | `-A "mygroup" -p cpu` | Limited to purchased cores | No limit | No Limit | 2 weeks |
| Standby Job | cpu | standby | `-A "mygroup" -p cpu -q standby` | 14272 Cores | 5000 | No Limit | 4 hours |
| Highmem Job | highmem | normal | `-A "mygroup" -p highmem` | 128 Cores | 2 | 1 | 24 hours |
| GPU Job | gpu | normal | `-A "mygroup" -p gpu` | 64 cores/3 GPUs/1 Node | 2 | 1 | 24 hours |
| Interactive-Tier Queues | interactive | normal | `-A "mygroup" -p interactive` | 4 cores | 1 per user | 1 | 24 hours |

Note: The normal QOS is the default and does not need to be specified.

[**Back to the Running Jobs section**](index.md)