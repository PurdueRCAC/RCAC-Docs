# Parallel Computing Toolbox (parfor)

The MATLAB *Parallel Computing Toolbox (PCT)* extends the MATLAB language with high-level, parallel-processing features such as parallel for loops, parallel regions, message passing, distributed arrays, and parallel numerical methods. It offers a shared-memory computing environment running on the local cluster profile in addition to your MATLAB client. Moreover, the MATLAB *Distributed Computing Server (DCS)* scales PCT applications up to the limit of your DCS licenses.

This section illustrates the fine-grained parallelism of a parallel for loop (`parfor`) in a *pool job*.

The following examples illustrate a method for submitting a small, parallel, MATLAB program with a parallel loop (`parfor` statement) as a job to a queue. This MATLAB program prints the name of the run host and shows the values of variables `numlabs` and `labindex` for each iteration of the `parfor` loop.

This method uses the job submission command to submit a MATLAB client which calls the MATLAB `batch()` function with a [user-defined cluster profile](profile_manager.md).

Prepare a MATLAB pool program in a MATLAB script with an appropriate filename, here named `myscript.m`:

```
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

The execution of a pool job starts with a worker executing the statements of the first serial region up to the `parfor` block, when it pauses. A set of workers (the pool) executes the `parfor` block. When they finish, the first worker resumes by executing the second serial region. The code displays the names of the compute nodes running the batch session and the worker pool.

Prepare a MATLAB script that calls MATLAB function `batch()` which makes a four-lab pool on which to run the MATLAB code in the file `myscript.m`. Use an appropriate filename, here named `mylclbatch.m`:

```
% FILENAME:  mylclbatch.m

!echo "mylclbatch.m"
!hostname

pjob=batch('myscript','Profile','myslurmprofile','Pool',4,'CaptureDiary',true);
wait(pjob);
diary(pjob);
quit;
```

Prepare a job submission file with an appropriate filename, here named `myjob.sub`:

```
#!/bin/bash
# FILENAME:  myjob.sub

echo "myjob.sub"
hostname

module load matlab

unset DISPLAY

matlab -nodisplay -r mylclbatch
```

[Submit the job](../../../slurm/submit_script.md) as a single compute node with one processor core.

One processor core runs `myjob.sub` and `mylclbatch.m`.

Once this job starts, a second job submission is made.

[View job status](../../../slurm/monitoring_job.md)

[View results of the job](../../../slurm/checking_output.md)

```
myjob.sub

                            < M A T L A B (R) >
                  Copyright 1984-2013 The MathWorks, Inc.
                    R2013a (8.1.0.604) 64-bit (glnxa64)
                             February 15, 2013

To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.

mylclbatch.mbell-a000.rcac.purdue.edu
SERIAL REGION:  hostname:bell-a000.rcac.purdue.edu

                hostname                         numlabs  labindex  iteration
                -------------------------------  -------  --------  ---------
PARALLEL LOOP:  bell-a001.rcac.purdue.edu           4         1          2
PARALLEL LOOP:  bell-a002.rcac.purdue.edu           4         1          4
PARALLEL LOOP:  bell-a001.rcac.purdue.edu           4         1          5
PARALLEL LOOP:  bell-a002.rcac.purdue.edu           4         1          6
PARALLEL LOOP:  bell-a003.rcac.purdue.edu           4         1          1
PARALLEL LOOP:  bell-a003.rcac.purdue.edu           4         1          3
PARALLEL LOOP:  bell-a004.rcac.purdue.edu           4         1          7
PARALLEL LOOP:  bell-a004.rcac.purdue.edu           4         1          8

SERIAL REGION:  hostname:bell-a001.rcac.purdue.edu

Elapsed time in parallel loop:   5.411486
```

To scale up this method to handle a real application, increase the wall time in the [submission](../../../slurm/submit_script.md) command to accommodate a longer running job. Secondly, increase the wall time of `myslurmprofile` by using the [Cluster Profile Manager](profile_manager.md) in the `Parallel` menu to enter a new wall time in the property `SubmitArguments`.

For more information about MATLAB Parallel Computing Toolbox:

* [MathWorks MATLAB Parallel Computing Toolbox User's Guide](http://www.mathworks.com/help/distcomp/index.html)
* [MathWorks MATLAB Distributed Computing Server User's Guide](http://www.mathworks.com/help/mdce/index.html)
* [MathWorks Website](http://www.mathworks.com/)
