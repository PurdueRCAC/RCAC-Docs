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

# Distributed Computing Server (parallel job)

The MATLAB Parallel Computing Toolbox (PCT) enables a parallel job via the MATLAB Distributed Computing Server (DCS). The tasks of a parallel job are identical, run simultaneously on several MATLAB workers, or labs, and communicate with each other.

This example illustrates an MPI-like program.

The example shows how to submit a small MATLAB parallel job with four workers running one MPI-like task to a batch queue. The MATLAB program broadcasts an integer to four workers and gathers the names of the compute nodes running the workers and the lab IDs of the workers.

This example uses the job submission command to submit a MATLAB script with a user-defined cluster profile. The profile scatters the MATLAB workers onto different compute nodes.

This method uses:

- the MATLAB interpreter
- the Parallel Computing Toolbox
- the Distributed Computing Server

It requires and checks out six licenses:

- one MATLAB license for the client running on the compute node
- one Parallel Computing Toolbox license
- four Distributed Computing Server licenses

Four DCS licenses run the four copies of the parallel job.

This job is completely off the front end.

## MATLAB Script

Prepare a MATLAB script named `myscript.m`:

```matlab
% FILENAME:  myscript.m

% Specify pool size.
% Convert the parallel job to a pool job.
parpool('4');
spmd

if labindex == 1
    % Lab (rank) #1 broadcasts an integer value to other labs (ranks).
    N = labBroadcast(1,int64(1000));
else
    % Each lab (rank) receives the broadcast value from lab (rank) #1.
    N = labBroadcast(1);
end

% Form a string with host name, total number of labs, lab ID, and broadcast value.
[c name] =system('hostname');
name = name(1:length(name)-1);
fmt = num2str(floor(log10(numlabs))+1);
str = sprintf(['%s:%d:%' fmt 'd:%d   '], name,numlabs,labindex,N);

% Apply global concatenate to all str's.
% Store the concatenation of str's in the first dimension (row) and on lab #1.
result = gcat(str,1,1);
if labindex == 1
    disp(result)
end

end   % spmd
matlabpool close force;
quit;
```

## SLURM Job Submission File

Prepare a job submission file. In this example, the file is named `myjob.sub`.

Run with the name of the script:

```bash
# FILENAME:  myjob.sub

echo "myjob.sub"

module load matlab

unset DISPLAY

# -nodisplay: run MATLAB in text mode; X11 server not needed
# -r:         read MATLAB program; use MATLAB JIT Accelerator
matlab -nodisplay -r myscript
```

## Set the Default Parallel Configuration

Run MATLAB to set the default parallel configuration to your appropriate profile:

```bash
matlab -nodisplay
```

Then, inside MATLAB:

```matlab
defaultParallelConfig('myslurmprofile');
quit;
```

## Submit the Job

Submit the job as a single compute node with one processor core.

Once this job starts, a second job submission is made.

## Example Output

The output may look similar to this:

```text
myjob.sub
                            < M A T L A B (R) >
                  Copyright 1984-2011 The MathWorks, Inc.
                    R2011b (7.13.0.564) 64-bit (glnxa64)
                              August 13, 2011

To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.
>Starting matlabpool using the 'myslurmprofile' configuration ... connected to 4 labs.
Lab 1:
  a006.gautschi.rcac.purdue.edu:4:1:1000
  a007.gautschi.rcac.purdue.edu:4:2:1000
  a008.gautschi.rcac.purdue.edu:4:3:1000
  a009.gautschi.rcac.purdue.edu:4:4:1000
Sending a stop signal to all the labs ... stopped.
Did not find any pre-existing parallel jobs created by matlabpool.
```

The output shows the name of one compute node, `a006`, that processed the job submission file `myjob.sub`.

The job submission scattered four processor cores, or four MATLAB labs, among four different compute nodes:

- `a006`
- `a007`
- `a008`
- `a009`

These nodes processed the four parallel regions.

## Scaling Up

To scale this method for a real application:

1. Increase the wall time in the submission command to accommodate a longer-running job.
2. Increase the wall time of `myslurmprofile` by using the MATLAB Cluster Profile Manager.
3. In the Cluster Profile Manager, use the `Parallel` menu to enter a new wall time in the `SubmitArguments` property.

## Additional Resources

- [MathWorks MATLAB Parallel Computing Toolbox User's Guide](https://www.mathworks.com/help/parallel-computing/)
- [MathWorks MATLAB Distributed Computing Server User's Guide](https://www.mathworks.com/help/matlab-parallel-server/)
- [MathWorks Website](https://www.mathworks.com/)

[**Back to Matlab**](../matlab_example.md)