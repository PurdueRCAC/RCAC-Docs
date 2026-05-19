# Tensorflow

This example demonstrates how to run Tensorflow on AMD GPUs with `rocmcontainers` modules.

First, prepare the matrix multiplication example from [Tensorflow documentation](https://www.tensorflow.org/guide/gpu):

```
# filename: matrixmult.py
import tensorflow as tf

# Log device placement
print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
tf.debugging.set_log_device_placement(True)

# Create some tensors
a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
c = tf.matmul(a, b)

print(c)
```

Submit a Slurm job, making sure to request GPU-enabled queue and desired number of GPUs. For illustration purpose, the following example shows an interactive job submission, asking for one node (128 cores) in the "gpu" account with and two GPUs for 6 hours, but the same applies to your production batch jobs as well:

```
sinteractive -A gpu -N 1 -n 128 -t 6:00:00 --gres=gpu:2
salloc: Granted job allocation 5401130
salloc: Waiting for resource configuration
salloc: Nodes bell-g000 are ready for job
```

Inside the job, load necessary modules:

```
module load rocmcontainers
module load tensorflow/2.5-rocm4.2-dev
```

And run the application as usual:

```
python matrixmult.py
Num GPUs Available:  2
[...]
2021-09-02 21:07:34.087607: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1418] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 32252 MB memory) -> physical GPU (device: 0, name: Vega 20, pci bus id: 0000:83:00.0)
[...]
2021-09-02 21:07:36.265167: I tensorflow/core/common_runtime/eager/execute.cc:733] Executing op MatMul in device /job:localhost/replica:0/task:0/device:GPU:0
2021-09-02 21:07:36.266755: I tensorflow/stream_executor/platform/default/dso_loader.cc:53] Successfully opened dynamic library librocblas.so
tf.Tensor(
[[22. 28.]
 [49. 64.]], shape=(2, 2), dtype=float32)
```

For more information, see the application’s [AMD Infinity Hub page](https://web.archive.org/web/20230902021513/https://www.amd.com/en/technologies/infinity-hub/). For applications deployed as modules, see `module help` command for a direct link to the relevant page (e.g. `module help tensorflow/2.5-rocm4.2-dev` in the above example).
