---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Job Dependencies

Dependencies are an automated way of holding and releasing jobs. Jobs with a dependency are held until the condition is satisfied. Once the condition is satisfied jobs only then become eligible to run and must still queue as normal.

Job dependencies may be configured to ensure jobs start in a specified order. Jobs can be configured to run after other job state changes, such as when the job starts or the job ends.

These examples illustrate setting dependencies in several ways. Typically dependencies are set by capturing and using the job ID from the last job submitted.

To run a job after job `myjobid` has started:

```

sbatch --dependency=after:myjobid myjobsubmissionfile
```

To run a job after job `myjobid` ends without error:

```

sbatch --dependency=afterok:myjobid myjobsubmissionfile
```

To run a job after job `myjobid` ends with errors:

```

sbatch --dependency=afternotok:myjobid myjobsubmissionfile
```

To run a job after job `myjobid` ends with or without errors:

```

sbatch --dependency=afterany:myjobid myjobsubmissionfile
```

To set more complex dependencies on multiple jobs and conditions:

```

sbatch --dependency=after:myjobid1:myjobid2:myjobid3,afterok:myjobid4 myjobsubmissionfile
```