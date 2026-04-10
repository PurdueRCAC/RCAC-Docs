---
tags:
  - Gautschi
  - Python
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

## Example 1: Hello world

Prepare a Python input file with an appropriate filename, here named ```hello.py```:

```bash
# FILENAME:  hello.py

import string, sys
print("Hello, world!")
```

Prepare a job submission file with an appropriate filename, here named ```myjob.sub```:

```bash
#!/bin/bash
# FILENAME:  myjob.sub

module load conda

python hello.py
```

Then, submit your job via SLURM and view the output file, which should simply output:

```bash
Hello, world!
```

## Example 2: Matrix multiply

Save the following script as ```matrix.py```:

```bash
# Matrix multiplication program

x = [[3,1,4],[1,5,9],[2,6,5]]
y = [[3,5,8,9],[7,9,3,2],[3,8,4,6]]

result = [[sum(a*b for a,b in zip(x_row,y_col)) for y_col in zip(*y)] for x_row in x]

for r in result:
        print(r)
```

Change the last line in the job submission file above to read:

```bash
python matrix.py
```

The standard output file from this job will result in the following matrix:

```bash
[28, 56, 43, 53]
[65, 122, 59, 73]
[63, 104, 54, 60]
```

## Example 3: Sine wave plot using numpy and matplotlib packages

Save the following script as ```sine.py```:

```bash
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

- [**The Python Programming Language - Official Website** :octicons-link-external-16:](https://www.python.org/)
- [**Anaconda Python Distribution - Official Website** :octicons-link-external-16:](https://store.continuum.io/cshop/anaconda/)
- [**Conda User Guide** :octicons-link-external-16:](https://conda.io/projects/conda/en/latest/user-guide/)

[**Back to the Python Examples section**](../python_example.md)
