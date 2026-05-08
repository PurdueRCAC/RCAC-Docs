---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Octave

GNU Octave is a high-level, interpreted, programming language for numerical computations. Octave is a structured language (similar to C) and mostly compatible with MATLAB. You may use Octave to avoid the need for a MATLAB license, both during development and as a deployed application. By doing so, you may be able to run your application on more systems or more easily distribute it to others.

This section illustrates how to submit a small Octave job to a PBS queue. This Octave example computes the inverse of a matrix.

Prepare an Octave script file with an appropriate filename, here named `myjob.m`:

```

% FILENAME:  myjob.m

% Invert matrix A.
A = [1 2 3; 4 5 6; 7 8 0]
inv(A)

quit
```

Prepare a job submission file with an appropriate filename, here named `myjob.sub`:

```

#!/bin/sh -l
# FILENAME:  myjob.sub

module load octave
cd $PBS_O_WORKDIR

unset DISPLAY

# Use the -q option to suppress startup messages.
# octave -q < myjob.m
octave < myjob.m
```

The command `octave myjob.m` (without the redirection) also works in the preceding script.

Submit the job:

```

{::if resource.qsub_needs_gpu == 1}
$ qsub -l nodes=1:ppn=1:gpus=1 myjob.sub
{::else}
$ qsub -l nodes=1:ppn=${resource.nodecores} myjob.sub
{::/}
```

View job status:

```

$ qstat -u ${user.username}
```

View results in the file for all standard output, `myjob.sub.omyjobid`:

```

A =

   1   2   3
   4   5   6
   7   8   0

ans =

  -1.77778   0.88889  -0.11111
   1.55556  -0.77778   0.22222
  -0.11111   0.22222  -0.11111
```

Any output written to standard error will appear in `myjob.sub.emyjobid`.

For more information about Octave:

* [GNU Octave Website](http://www.octave.org)
* [Octave Online Documentation](http://www.gnu.org/software/octave/doc/interpreter/)
* [Porting Programs from MATLAB to Octave](http://wiki.octave.org/FAQ)