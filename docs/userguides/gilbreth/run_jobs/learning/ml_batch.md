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

# ML Batch Jobs

## Running ML Code in a Batch Job


Batch jobs allow us to automate model training without human intervention. They are also useful when you need to run a large number of simulations on the clusters. In the example below, we shall run a simple `tensor_hello.py` script in a batch job.

### Using a Custom Installation


Save the following code as `tensor_hello.sub` in the same directory where `tensor_hello.py` is located.

```bash
# filename: tensor_hello.sub
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH -A accountname
#SBATCH -J hello_tensor

module purge
module load anaconda
module load cuda
module load cudnn
module load use.own
module load conda-env/my_tf_env-py3.8.5
module list

echo $PYTHONPATH

python tensor_hello.py
```

### Running a Job

Now you can submit the batch job using the `sbatch` command.

```bash
sbatch tensor_hello.sub
```

Once the job finishes, you will find an output file (`slurm-xxxxx.out`).

[**Back to the Running Jobs section**](index.md)