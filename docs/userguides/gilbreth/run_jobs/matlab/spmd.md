---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Parallel Toolbox (spmd)

The MATLAB *Parallel Computing Toolbox (PCT)* extends the MATLAB language with high-level, parallel-processing features such as parallel for loops, parallel regions, message passing, distributed arrays, and parallel numerical methods. It offers a shared-memory computing environment with a maximum of eight MATLAB workers (labs, threads; versions R2009a) and 12 workers (labs, threads; version R2011a) running on the local configuration in addition to your MATLAB client. Moreover, the MATLAB *Distributed Computing Server (DCS)* scales PCT applications up to the limit of your DCS licenses.

This section illustrates how to submit a small, parallel, MATLAB program with a parallel region (`spmd` statement) as a MATLAB pool job to a batch queue.

This example uses the [submission command](/knowledge/${resource.hostname}/run/${resource.batchsystem}/submit) to submit to compute nodes a MATLAB client which interprets a Matlab .m with a [user-defined cluster profile](/knowledge/${resource.dir}/run/examples/apps/matlab/profile_manager) which scatters the MATLAB workers onto different compute nodes. This method uses the MATLAB interpreter, the Parallel Computing Toolbox, and the Distributed Computing Server; so, it requires and checks out six licenses: one MATLAB license for the client running on the compute node, one PCT license, and four DCS licenses. Four DCS licenses run the four copies of the `spmd` statement. This job is completely off the front end.

Prepare a MATLAB script called `myscript.m`:

```

% FILENAME:  myscript.m

% SERIAL REGION
[c name] = system('hostname');
fprintf('SERIAL REGION:  hostname:%s\n', name)
p = parpool('4');
fprintf('                    hostname                         numlabs  labindex\n')
fprintf('                    -------------------------------  -------  --------\n')
tic;

% PARALLEL REGION
spmd
    [c name] = system('hostname');
    name = name(1:length(name)-1);
    fprintf('PARALLEL REGION:  %-31s  %7d  %8d\n', name,numlabs,labindex)
    pause(2);
end

% SERIAL REGION
elapsed_time = toc;          % get elapsed time in parallel region
delete(p);
fprintf('\n')
[c name] = system('hostname');
name = name(1:length(name)-1);
fprintf('SERIAL REGION:  hostname:%s\n', name)
fprintf('Elapsed time in parallel region:   %f\n', elapsed_time)
quit;
```

Prepare a job submission file with an appropriate filename, here named `myjob.sub`. Run with the name of the script:

```

#!/bin/bash 
# FILENAME:  myjob.sub

echo "myjob.sub"

module load matlab
{::if resource.batchsystem == pbs}
cd $PBS_O_WORKDIR
{::/}
unset DISPLAY

matlab -nodisplay -r myscript
```

Run MATLAB to set the default parallel configuration to your job configuration:

```

$ matlab -nodisplay
>> parallel.defaultClusterProfile('my${resource.batchsystem}profile');
>> quit;
$
```

[Submit the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/submit)

Once this job starts, a second job submission is made.

[View job status](/knowledge/${resource.hostname}/run/${resource.batchsystem}/status)

[View results for the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/output)

```
myjob.sub

                            < M A T L A B (R) >
                  Copyright 1984-2011 The MathWorks, Inc.
                    R2011b (7.13.0.564) 64-bit (glnxa64)
                              August 13, 2011

To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.

SERIAL REGION:  hostname:{::if resource.nodashnames == true}a001.${resource.hostname}{::else}${resource.hostname}-a001{::/}.rcac.purdue.edu

Starting matlabpool using the 'my${resource.batchsystem}profile' profile ... connected to 4 labs.
                    hostname                         numlabs  labindex
                    -------------------------------  -------  --------
Lab 2:
  PARALLEL REGION:  {::if resource.nodashnames == true}a002.${resource.hostname}{::else}${resource.hostname}-a002{::/}.rcac.purdue.edu           4         2
Lab 1:
  PARALLEL REGION:  {::if resource.nodashnames == true}a001.${resource.hostname}{::else}${resource.hostname}-a001{::/}.rcac.purdue.edu           4         1
Lab 3:
  PARALLEL REGION:  {::if resource.nodashnames == true}a003.${resource.hostname}{::else}${resource.hostname}-a003{::/}.rcac.purdue.edu           4         3
Lab 4:
  PARALLEL REGION:  {::if resource.nodashnames == true}a004.${resource.hostname}{::else}${resource.hostname}-a004{::/}.rcac.purdue.edu           4         4

Sending a stop signal to all the labs ... stopped.

SERIAL REGION:  hostname:{::if resource.nodashnames == true}a001.${resource.hostname}{::else}${resource.hostname}-a001{::/}.rcac.purdue.edu
Elapsed time in parallel region:   3.382151
```

Output shows the name of one compute node (a001) that processed the job submission file `myjob.sub` and the two serial regions. The job submission scattered four processor cores (four MATLAB labs) among four different compute nodes (a001,a002,a003,a004) that processed the four parallel regions. The total elapsed time demonstrates that the jobs ran in parallel.

For more information about MATLAB Parallel Computing Toolbox:

* [MathWorks MATLAB Parallel Computing Toolbox User's Guide](http://www.mathworks.com/help/distcomp/index.html)
* [MathWorks MATLAB Distributed Computing Server User's Guide](http://www.mathworks.com/help/mdce/index.html)
* [MathWorks Website](http://www.mathworks.com/)