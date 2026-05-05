---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Example Python Jobs

This section illustrates how to submit a small Python job to a SLURM queue.

Example 1: Hello world
----------------------

Prepare a Python input file with an appropriate filename, here named `hello.py`:

```

# FILENAME:  hello.py

import string, sys
print("Hello, world!")
```

Prepare a job submission file with an appropriate filename, here named `myjob.sub`:

```

#!/bin/bash
# FILENAME:  myjob.sub

module load conda
{::if resource.batchsystem == pbs}
cd $PBS_O_WORKDIR
{::/}
python hello.py
```

[Submit the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/submit)

[View job status](/knowledge/${resource.hostname}/run/${resource.batchsystem}/status)

[View results of the job](/knowledge/${resource.hostname}/run/${resource.batchsystem}/output)

```

Hello, world!
```

### Example 2: Matrix multiply

Save the following script as matrix.py:

```

# Matrix multiplication program

x = [[3,1,4],[1,5,9],[2,6,5]]
y = [[3,5,8,9],[7,9,3,2],[3,8,4,6]]

result = [[sum(a*b for a,b in zip(x_row,y_col)) for y_col in zip(*y)] for x_row in x]

for r in result:
        print(r)
```

Change the last line in the job submission file above to read:

```

python matrix.py
```

The standard output file from this job will result in the following matrix:

```

[28, 56, 43, 53]
[65, 122, 59, 73]
[63, 104, 54, 60]
```

### Example 3: Sine wave plot using numpy and matplotlib packages

Save the following script as sine.py:

```

import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

x = np.linspace(-np.pi, np.pi, 201)
plt.plot(x, np.sin(x))
plt.xlabel('Angle [rad]')
plt.ylabel('sin(x)')
plt.axis('tight')
plt.savefig('sine.png')
```

Change your job submission file to submit this script and the job will output a png file and blank standard output and error files.

For more information about Python:

* [The Python Programming Language - Official Website](http://www.python.org/)
* [Anaconda Python Distribution - Official Website](https://store.continuum.io/cshop/anaconda/)
* [Conda User Guide](https://conda.io/projects/conda/en/latest/user-guide/)