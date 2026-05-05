---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# ML Batch Jobs

Running ML Code in a Batch Job
==============================

Batch jobs allow us to automate model training without human intervention. They are also useful when you need to run a large number of simulations on the clusters. In the example below, we shall run a simple `tensor_hello.py` script in a batch job. We consider two situations: in the first example, we use the [ML-Toolkit](/knowledge/${resource.dir}/run/examples/apps/learning/mltoolkit) modules to run tensorflow, while in the second example, we use a custom installation of tensorflow (See Custom ML Packages page).

Using ML-Toolkit Modules
------------------------

Save the following code as `tensor_hello.sub` in the same directory where `tensor_hello.py` is located.

```
# filename: tensor_hello.sub
{::if resource.amdgpu== false}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
{::else}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${resource.nodecores}
{::/}
#SBATCH --time=00:05:00
#SBATCH -A ${resource.queue}
#SBATCH -J hello_tensor

module purge
{::if resource.name == Scholar }
module load learning
module load ml-toolkit-gpu/tensorflow

{::elseif resource.name == Gilbreth}
module load learning
module load ml-toolkit-gpu/tensorflow

{::else}
module load learning
module load ml-toolkit-cpu/tensorflow
{::/}
module list

python tensor_hello.py
```

Using a Custom Installation
---------------------------

Save the following code as `tensor_hello.sub` in the same directory where `tensor_hello.py` is located.

```
# filename: tensor_hello.sub
{::if resource.nodegpus != 0}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
{::else}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${resource.nodecores}
{::/}
#SBATCH --time=00:05:00
#SBATCH -A ${resource.queue}
#SBATCH -J hello_tensor

module purge
module load anaconda
{::if resource.name == Gilbreth}module load cuda
module load cudnn
module load use.own
module load conda-env/my_tf_env-py3.8.5

{::elseif resource.name == Scholar}
module load cuda
module load cudnn
module load use.own
module load conda-env/my_tf_env-py3.8.5

{::else}
module load use.own
module load conda-env/my_tf_env-py3.6.4
{::/}
module list

echo $PYTHONPATH

python tensor_hello.py
```

Running a Job
-------------

Now you can submit the batch job using the `sbatch` command.

```
sbatch tensor_hello.sub
```

Once the job finishes, you will find an output file (`slurm-xxxxx.out`).