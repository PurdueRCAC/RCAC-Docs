---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Matlab Script (.m File)

This section illustrates how to submit a small, serial, MATLAB program as a job to a batch queue. This MATLAB program prints the name of the run host and gets three random numbers.

Prepare a MATLAB script `myscript.m`, and a MATLAB function file `myfunction.m`:

```
% FILENAME:  myscript.m

% Display name of compute node which ran this job.
[c name] = system('hostname');
fprintf('\n\nhostname:%s\n', name);

% Display three random numbers.
A = rand(1,3);
fprintf('%f %f %f\n', A);

quit;
```

```
% FILENAME:  myfunction.m

function result = myfunction ()

    % Return name of compute node which ran this job.
    [c name] = system('hostname');
    result = sprintf('hostname:%s', name);

    % Return three random numbers.
    A = rand(1,3);
    r = sprintf('%f %f %f', A);
    result=strvcat(result,r);

end
```

Also, prepare a job submission file, here named `myjob.sub`. Run with the name of the script:

```
#!/bin/bash
# FILENAME:  myjob.sub

echo "myjob.sub"

# Load module, and set up environment for Matlab to run
module load matlab
{::if resource.batchsystem == pbs}
cd $PBS_O_WORKDIR
{::/}
unset DISPLAY

# -nodisplay:        run MATLAB in text mode; X11 server not needed
# -singleCompThread: turn off implicit parallelism
# -r:                read MATLAB program; use MATLAB JIT Accelerator
# Run Matlab, with the above options and specifying our .m file
matlab -nodisplay -singleCompThread -r myscript
```

[Submit the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/submit)

[View job status](/knowledge/${resource.hostname}/run/${resource.batchsystem}/status)

[View results of the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/output)

```
myjob.sub

                            < M A T L A B (R) >
                  Copyright 1984-2011 The MathWorks, Inc.
                    R2011b (7.13.0.564) 64-bit (glnxa64)
                              August 13, 2011

To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.

hostname:{::if resource.nodashnames == true}a001.${resource.hostname}{::else}${resource.hostname}-a001{::/}.rcac.purdue.edu
0.814724 0.905792 0.126987
```

Output shows that a processor core on one compute node ({::if resource.nodashnames == true}a001{::else}${resource.hostname}-a001{::/}) processed the job. Output also displays the three random numbers.

For more information about MATLAB:

* [inv()](http://www.mathworks.com/help/techdoc/ref/inv.html)
* [Run a Batch Job](http://www.mathworks.com/help/distcomp/introduction-to-parallel-solutions.html#brjw1fx-2)
* [Archived MathWorks Documentation](http://www.mathworks.com/help/doc-archives.html)
* [MathWorks Website](http://www.mathworks.com/)