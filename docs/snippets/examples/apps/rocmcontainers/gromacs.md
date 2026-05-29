# GROMACS

This example demonstrates how to run GROMACS on AMD GPUs with rocmcontainers modules.

First, download the .tpr input files for ['lysozyme in water' tutorial](http://www.mdtutorials.com/gmx/lysozyme) from [this archive](https://www.rcac.purdue.edu/files/knowledge/run/examples/apps/rocmcontainers/gromacs/tpr-file.zip). Then unzip the folder and go to that folder by

```
wget https://www.rcac.purdue.edu/files/knowledge/run/examples/apps/rocmcontainers/gromacs/tpr-file.zip
unzip tpr-file.zip
cd tpr-file
```

Submit a Slurm job, making sure to request GPU-enabled queue and desired number of GPUs. The following example shows an Slurm job submission, asking for one node (128 cores) in the "gpu" account with and two GPUs for 6 hours:

```

#!/bin/bash
#SBATCH -A gpu --gres=gpu:2
#SBATCH -N 1 -n 128
#SBATCH -t 6:00:00

module load rocmcontainers
module load gromacs/2020.3

gmx mdrun -v -deffnm em  
gmx mdrun -deffnm nvt
gmx mdrun -deffnm npt
gmx mdrun -deffnm md_0_1 -nb gpu -pme gpu -bonded gpu
```

The above batch script will perform energy minimization, NVT and NPT equilibrations and production MD simulations in sequence. The .log files contain the performance of GPU nodes. For better performance, please refer to the ['Getting good performance from mdrun'](https://manual.gromacs.org/current/user-guide/mdrun-performance.html) documentation for help.

Afterwards you can do interactive post analysis as usual:

```
gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_noPBC.xtc -pbc mol -center     # Select 1 ("Protein") as the group to be centered and 0 ("System") for output
gmx rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsd.xvg -tu ns                     # Select 4 ("Backbone") for both the least-squares fit and the group for RMSD calculation
gmx rms -s em.tpr -f md_0_1_noPBC.xtc -o rmsd_xtal.xvg -tu ns
```

To compare generated .xvg figures with reference, please see the [analysis step of the 'lysozyme in water' tutorial](http://www.mdtutorials.com/gmx/lysozyme/09_analysis.html) for help.
