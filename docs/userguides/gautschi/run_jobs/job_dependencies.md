---
tags:
  - Gautschi
authors:
  - jin456
cluster: Gautschi
search:
  boost: 2
---

Dependencies are an automated way of holding and releasing jobs. Jobs with a dependency are held until the condition is satisfied. Once the condition is satisfied jobs only then become eligible to run and must still queue as normal.

Job dependencies may be configured to ensure jobs start in a specified order. Jobs can be configured to run after other job state changes, such as when the job starts or the job ends.

These examples illustrate setting dependencies in several ways. Typically dependencies are set by capturing and using the job ID from the last job submitted.

To run a job after job ```myjobid``` has started:

```bash
sbatch --dependency=after:myjobid myjobsubmissionfile
```

To run a job after job ```myjobid``` ends without error:

```bash
sbatch --dependency=afterok:myjobid myjobsubmissionfile
```

To run a job after job ```myjobid``` ends with errors:

```bash
sbatch --dependency=afternotok:myjobid myjobsubmissionfile
```

To run a job after job ```myjobid``` ends with or without errors:

```bash
sbatch --dependency=afterany:myjobid myjobsubmissionfile
```

To set more complex dependencies on multiple jobs and conditions:

```bash
sbatch --dependency=after:myjobid1:myjobid2:myjobid3,afterok:myjobid4 myjobsubmissionfile
```

[**Back to the Running Jobs section**](index.md)
