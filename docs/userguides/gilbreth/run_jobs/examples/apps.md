---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Specific Applications

The following examples demonstrate job submission files for some common real-world applications. {::if resource.batchsystem == pbs} See the [Generic PBS Examples](/knowledge/${resource.dir}/run/pbs) section for more examples on job submissions that can be adapted for use. {::elseif resource.batchsystem == slurm} See the [Generic SLURM Examples](/knowledge/${resource.dir}/run/slurm) section for more examples on job submissions that can be adapted for use. {::elseif resource.batchsystem == hadoop} See the [Running Hadoop Jobs](/knowledge/${resource.dir}/run/hadoop) section for more examples on job submissions that can be adapted for use. {::else} {::/}