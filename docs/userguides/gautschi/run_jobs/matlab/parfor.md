---
tags:
  - Gautschi
authors:
  - jin456
  - remender
resource: Gautschi
search:
  boost: 2
---

# Parallel Computing Toolbox (`parfor`)

The MATLAB Parallel Computing Toolbox (PCT) extends MATLAB with high-level parallel-processing features such as parallel `for` loops, parallel regions, message passing, distributed arrays, and parallel numerical methods.

This example illustrates the fine-grained parallelism of a parallel `for` loop, or `parfor`, in a pool job.

The examples below show a method for submitting a small parallel MATLAB program with a `parfor` loop as a job to a queue. The MATLAB program prints the name of the run host and shows the values of the variables `numlabs` and `labindex` for each iteration of the `parfor` loop.

This method uses the job submission command to submit a MATLAB client, which calls the MATLAB `batch()` function with a user-defined cluster profile.

## MATLAB `parfor` Script

Prepare a MATLAB pool program in a MATLAB script with an appropriate filename. In this example, the file is named `myscript.m`.

```M
% FILENAME:  myscript.m
% SERIAL REGION
[c name] = system('hostname');
fprintf('SERIAL REGION:  hostname:%s\n', name)
numlabs = parpool('poolsize');
fprintf('        hostname                         numlabs  labindex  iteration\n')
fprintf('        -------------------------------  -------  --------  ---------\n')
tic;

% PARALLEL LOOP
parfor i = 1:8
    [c name] = system('hostname');
    name = name(1:length(name)-1);
    fprintf('PARALLEL LOOP:  %-31s  %7d  %8d  %9d\n', name,numlabs,labindex,i)
    pause(2);
end

% SERIAL REGION
elapsed_time = toc;        % get elapsed time in parallel loop
fprintf('\n')
[c name] = system('hostname');
name = name(1:length(name)-1);
fprintf('SERIAL REGION:  hostname:%s\n', name)
fprintf('Elapsed time in parallel loop:   %f\n', elapsed_time)
```

The execution of a pool job starts with a worker executing the statements of the first serial region up to the `parfor` block, where it pauses. A set of workers, called the pool, executes the `parfor` block. When they finish, the first worker resumes by executing the second serial region.

The code displays the names of the compute nodes running the batch session and the worker pool.

## MATLAB Batch Script

Prepare a MATLAB script that calls the MATLAB `batch()` function. This creates a four-lab pool on which to run the MATLAB code in `myscript.m`.

In this example, the file is named `mylclbatch.m`.

```M
% FILENAME:  mylclbatch.m

!echo "mylclbatch.m"
!hostname

pjob=batch('myscript','Profile','myslurmprofile','Pool',4,'CaptureDiary',true);
wait(pjob);
diary(pjob);
quit;
```

## SLURM Job Submission File

Prepare a job submission file with an appropriate filename. In this example, the file is named `myjob.sub`.

```bash
#!/bin/bash
# FILENAME:  myjob.sub

echo "myjob.sub"
hostname

module load matlab

unset DISPLAY

matlab -nodisplay -r mylclbatch
```

## Submit the Job

Submit the job as a single compute node with one processor core.

One processor core runs `myjob.sub` and `mylclbatch.m`.

Once this job starts, a second job submission is made by MATLAB through the configured SLURM cluster profile.

## Example Output

The output may look similar to this:

```text
myjob.sub
                            < M A T L A B (R) >
                  Copyright 1984-2013 The MathWorks, Inc.
                    R2013a (8.1.0.604) 64-bit (glnxa64)
                             February 15, 2013

To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.

mylclbatch.m a000.gautschi.rcac.purdue.edu
SERIAL REGION:  hostname:a000.gautschi.rcac.purdue.edu
                hostname                         numlabs  labindex  iteration
                -------------------------------  -------  --------  ---------
PARALLEL LOOP:  a001.gautschi.rcac.purdue.edu           4         1          2
PARALLEL LOOP:  a002.gautschi.rcac.purdue.edu           4         1          4
PARALLEL LOOP:  a001.gautschi.rcac.purdue.edu           4         1          5
PARALLEL LOOP:  a002.gautschi.rcac.purdue.edu           4         1          6
PARALLEL LOOP:  a003.gautschi.rcac.purdue.edu           4         1          1
PARALLEL LOOP:  a003.gautschi.rcac.purdue.edu           4         1          3
PARALLEL LOOP:  a004.gautschi.rcac.purdue.edu           4         1          7
PARALLEL LOOP:  a004.gautschi.rcac.purdue.edu           4         1          8
SERIAL REGION:  hostname:a001.gautschi.rcac.purdue.edu

Elapsed time in parallel loop:   5.411486
```

## Scaling Up

To scale this method for a real application:

1. Increase the wall time in the SLURM submission command to accommodate a longer-running job.
2. Increase the wall time of `myslurmprofile` by using the MATLAB Cluster Profile Manager.
3. In the Cluster Profile Manager, use the `Parallel` menu to enter a new wall time in the `SubmitArguments` property.

## Additional Resources

- [MathWorks MATLAB Parallel Computing Toolbox User's Guide](https://www.mathworks.com/help/parallel-computing/)
- [MathWorks MATLAB Parallel Server Documentation](https://www.mathworks.com/help/matlab-parallel-server/)
- [MathWorks Website](https://www.mathworks.com/)

[**Back to Matlab**](../matlab_example.md)