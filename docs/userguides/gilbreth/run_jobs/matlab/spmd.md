---
tags:
  - Gilbreth
authors:
  - jin456
  - verburgt
resource: Gilbreth
search:
  boost: 2
---

# Parallel Toolbox (`spmd`)

The MATLAB Parallel Computing Toolbox (PCT) extends the MATLAB language with high-level parallel-processing features such as parallel `for` loops, parallel regions, message passing, distributed arrays, and parallel numerical methods.

It offers a shared-memory computing environment with a maximum number of MATLAB workers running on the local configuration in addition to your MATLAB client. MATLAB Distributed Computing Server (DCS) can scale PCT applications up to the limit of your DCS licenses.

This example shows how to submit a small parallel MATLAB program with a parallel region, using an `spmd` statement, as a MATLAB pool job to a batch queue.

This method uses the job submission command to submit a MATLAB client to compute nodes. The MATLAB client interprets a MATLAB `.m` file with a user-defined cluster profile, which scatters the MATLAB workers onto different compute nodes.

This method uses the MATLAB interpreter, the Parallel Computing Toolbox, and the Distributed Computing Server. It requires and checks out six licenses:

- one MATLAB license for the client running on the compute node
- one Parallel Computing Toolbox license
- four Distributed Computing Server licenses

Four DCS licenses run the four copies of the `spmd` statement. This job is completely off the front end.

## MATLAB `spmd` Script

Prepare a MATLAB script called `myscript.m`:

```matlab
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

## SLURM Job Submission File

Prepare a job submission file with an appropriate filename. In this example, the file is named `myjob.sub`.

Run with the name of the script:

```bash
#!/bin/bash
# FILENAME:  myjob.sub

echo "myjob.sub"
module load matlab

unset DISPLAY

matlab -nodisplay -r myscript
```

## Set the Default Parallel Configuration

Run MATLAB to set the default parallel configuration to your job configuration:

```bash
matlab -nodisplay
```

Then, inside MATLAB:

```matlab
parallel.defaultClusterProfile('myslurmprofile');
quit;
```

## Submit the Job

Submit the job using `sbatch`.

Once this job starts, a second job submission is made by MATLAB through the configured SLURM cluster profile.

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

SERIAL REGION:  hostname:gilbreth-a001.rcac.purdue.edu
Starting matlabpool using the 'myslurmprofile' profile ... connected to 4 labs.
                    hostname                         numlabs  labindex
                    -------------------------------  -------  --------
Lab 2:
  PARALLEL REGION:  gilbreth-a002.rcac.purdue.edu           4         2
Lab 1:
  PARALLEL REGION:  gilbreth-a001.rcac.purdue.edu           4         1
Lab 3:
  PARALLEL REGION:  gilbreth-a003.rcac.purdue.edu           4         3
Lab 4:
  PARALLEL REGION:  gilbreth-a004.rcac.purdue.edu           4         4
Sending a stop signal to all the labs ... stopped.

SERIAL REGION:  hostname:gilbreth-a001.rcac.purdue.edu
Elapsed time in parallel region:   3.382151
```

The output shows that one compute node, `gilbreth-a001`, processed the job submission file `myjob.sub` and the two serial regions.

The job submission scattered four processor cores, or four MATLAB labs, among four different compute nodes:

- `gilbreth-a001`
- `gilbreth-a002`
- `gilbreth-a003`
- `gilbreth-a004`

These nodes processed the four parallel regions. The total elapsed time demonstrates that the jobs ran in parallel.

## Additional Resources

- [MathWorks MATLAB Parallel Computing Toolbox User's Guide](https://www.mathworks.com/help/parallel-computing/)
- [MathWorks MATLAB Distributed Computing Server User's Guide](https://www.mathworks.com/help/matlab-parallel-server/)
- [MathWorks Website](https://www.mathworks.com/)


[**Back to Matlab**](../matlab_example.md)