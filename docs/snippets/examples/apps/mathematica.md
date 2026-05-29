# Mathematica

Mathematica implements numeric and symbolic mathematics. This section illustrates how to submit a small Mathematica job to a PBS queue. This Mathematica example finds the three roots of a third-degree polynomial.

Prepare a Mathematica input file with an appropriate filename, here named `myjob.in`:

```

(* FILENAME:  myjob.in *)

(* Find roots of a polynomial. *)
p=x^3+3*x^2+3*x+1
Solve[p==0]
Quit
```

Prepare a job submission file with an appropriate filename, here named `myjob.sub`:

```

#!/bin/sh -l
# FILENAME:  myjob.sub

module load mathematica
cd $PBS_O_WORKDIR

math < myjob.in
```

Submit the job:

```


$ qsub -l nodes=1:ppn=128 myjob.sub

```

View job status:

```

$ qstat -u myusername
```

View results in the file for all standard output, here named `myjob.sub.omyjobid`:

```

Mathematica 5.2 for Linux x86 (64 bit)
Copyright 1988-2005 Wolfram Research, Inc.
 -- Terminal graphics initialized --

In[1]:=
In[2]:=
In[2]:=
In[3]:=
                     2    3
Out[3]= 1 + 3 x + 3 x  + x

In[4]:=
Out[4]= {{x -> -1}, {x -> -1}, {x -> -1}}

In[5]:=
```
{% endraw %}

View the standard error file, `myjob.sub.emyjobid`:

```

rmdir: ./ligo/rengel/tasks: Directory not empty
rmdir: ./ligo/rengel: Directory not empty
rmdir: ./ligo: Directory not empty
```

For more information about Mathematica:

* [Wolfram Research Website](http://www.wolfram.com/products/mathematica/index.html)
