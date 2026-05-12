---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

# Distributed Training on RCAC Clusters

This page aims to provide users of RCAC resources a high-level overview of how distributed training works, along with complete working examples to serve as guides. This guide will cover the following:

- Single node DDP in PyTorch
- Multi-Node DDP in PyTorch
- FSDP in PyTorch

## Single Node Distributed Data Parallel

We will first focus on single node example of Distributed Data Parallelism (DDP) using 8 GPUs for an example mnist classification task. DDP aims to speed up training by training the model on multiple GPUs in parallel. Each instance of the model will receive its own batch of data, and compute its own gradients.

Importantly, before the update step, the gradients across each instance of the model will be accumulated and averaged. This prevents the weights of each of the models from diverging over time.

In this example, we will use ```torchrun``` to spawn 8 processes on the node (one for each GPU). Each GPU will receive its own copy of the model, along with its own batch from the dataloader. Pytorch provides us with a comprehensive set of tooling to orchestrate the necessary environment and communications between all of the different processes. We can visualize the setup below. Each process (rank) on the node has its own GPU, with a complete copy of the model.

## Slurm Script

In the Slurm script, we are requesting a single Gautschi H node (with all 8 H100 GPUs) with a single task. Although we are only requesting a single task, 8 separate processes will be spawned by this task for distributed training.

Before we start training, we must specify the master port and address that will be used for rendezvous communications. This is where all of the individual processes sync up for communication. The Hostname will be formatted like ```h012.gautschi.rcac.purdue.edu```, since this job landed on the ```h012``` node.

In the last line, ```torchrun``` is ran only once, and is responsible for managing the spawning of processes (one for each GPU on this node), as well as setting environment variables that will be used within each process for establishing communication:

```bash
RANK, LOCAL_RANK, WORLD_SIZE, MASTER_ADDR, MASTER_PORT
```

Here, the rank (and local rank, which is more relevant for multi-node training, see below), world size, and rendezvous backend and location are all set.

```bash
#!/bin/bash
#SBATCH --job-name=ddp_singlenode
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=8
#SBATCH --cpus-per-task=14
#SBATCH --time=00:20:00
#SBATCH --constraint=H
#SBATCH --partition=ai
#SBATCH --qos=normal
#SBATCH --output=train_gautschi_singlenode.out
#SBATCH --account=rcac #Change to your account!

#Change these to match your environment!
ml conda 
ml cuda
conda activate /depot/itap/user/envs/anaconda/gautschi/ddp_example

# Optional Logging (Uncomment these if you are having issues!)
# export NCCL_DEBUG=INFO
# export NCCL_DEBUG_SUBSYS=ALL
# export TORCH_CPP_LOG_LEVEL=INFO
# export TORCH_DISTRIBUTED_DEBUG=DETAIL


# Rendezvous settings (do this before so torchrun sees them)
# Will be used for establishing the rendezvous point for all processes
export MASTER_ADDR=$(hostname)
export MASTER_PORT=29500

echo "MASTER_ADDR: $MASTER_ADDR" #h012.gautschi.rcac.purdue.edu
echo "MASTER_PORT: $MASTER_PORT"
echo "SLURM_GPUS_ON_NODE: $SLURM_GPUS_PER_NODE" #8

torchrun --nproc_per_node=${SLURM_GPUS_PER_NODE} \
         --rdzv_endpoint=${MASTER_ADDR}:${MASTER_PORT} \
         ddp_train_gautschi.py
```

## PyTorch Script

The Pytorch script largely looks like a standard Pytorch training script, but with modifications to allow for distributed training. With respect to DDP, the important portions of this script are as follows:

- The ```dist.init_process_group(backend="nccl")``` initializes the distributed process group. This allows for the collective communication across processes. Using environment variables set for each process by torchrun, it connects all processes to a rendezvous endpoint to allow for collective communication before training begins. Effectively, it ensures that all processes understand what their rank is, what all the other processes are, and that all processes are able to communicate with each other. This then allows each process to see information specific to it (such as ```get_rank()```).

- ```backend="nccl"``` specifies the communication backend (Nvidia Collective Communications Library) for the sharing of gradients between processes.

- The ```sampler = DistributedSampler(train_dataset, num_replicas=world_size, rank=rank)``` creates a sampler that will send different batches of your training dataset to each of the ranks (GPUs), which each contain their own copy of the model.

- The ```ddp_model = DDP(model, device_ids=[local_rank])``` is arguably the most important portion of the code. When you wrap a pytorch model in ```DDP()``` it transforms the model into a distributed model with all other ranks. This model will then share weighs with all other distributed models in all of the other ranks (using the nccl backend).

```bash
# (filename is ddp_train_gautschi.py)
import os
import torch
import torch.nn as nn
import torch.optim as optim
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data import DataLoader, DistributedSampler
from torchvision import datasets, transforms
import torch.nn.functional as F
import socket

def setup():
    dist.init_process_group(backend="nccl")

def cleanup():
    dist.destroy_process_group()

class MNISTModel(nn.Module):
    '''This is a vanilla CNN compatible with the default mnist dataset!'''
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(1, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.pool = nn.MaxPool2d(2)
        self.fc1 = nn.Linear(64 * 7 * 7, 128)
        self.fc2 = nn.Linear(128, 10)

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(x.size(0), -1)
        x = F.relu(self.fc1(x))
        return self.fc2(x)

def train():
    setup()
    rank = dist.get_rank() #Will be the same as global rank for single-node!
    world_size = dist.get_world_size() #Will be the #nodes * gpus/node!
    local_rank = int(os.environ["LOCAL_RANK"]) #LOCAL_RANK managed by torchrun!
    torch.cuda.set_device(local_rank) #LOCAL_RANK is just the GPU index to set!
    device = torch.device("cuda", local_rank)

    print(f"Rank:{rank}, local_rank:{local_rank}, hostname:{socket.gethostname()}, world_size = {world_size}", flush=True)

    #Load standard mnist dataset !
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])
    train_dataset = datasets.MNIST(root="./data", train=True, download=True, transform=transform)

    #DistributedSampler will give each rank (gpu) its own batch!
    sampler = DistributedSampler(train_dataset, num_replicas=world_size, rank=rank)
    dataloader = DataLoader(train_dataset, batch_size=64, sampler=sampler, num_workers=4, pin_memory=True)

    #Wrapping model in DDP allows for the sync of gradients across all ranks (gpus)!
    model = MNISTModel().to(device)
    ddp_model = DDP(model, device_ids=[local_rank])

    optimizer = optim.Adam(ddp_model.parameters(), lr=0.001)
    loss_fn = nn.CrossEntropyLoss()

    #After that the "training loop" is basically identical to a
    for epoch in range(5):
        ddp_model.train()
        sampler.set_epoch(epoch)
        total_loss = 0.0
        for batch_x, batch_y in dataloader:
            batch_x = batch_x.to(device, non_blocking=True)
            batch_y = batch_y.to(device, non_blocking=True)

            optimizer.zero_grad()
            output = ddp_model(batch_x)
            loss = loss_fn(output, batch_y)
            loss.backward()
            optimizer.step()

            total_loss += loss.item()

        print(f"Rank {rank}, Epoch {epoch},Loss: {total_loss / len(dataloader):.4f}", flush=True)

    print("done training", flush=True)

    # Only save the model once (from the first rank!)
    if rank == 0:
        torch.save(ddp_model.state_dict(), "mnist_ddp_model.pth")
        print("Model saved", flush=True)
    cleanup()

if __name__ == "__main__":
    train()
```

## Output

From the output, we see that the Python script is running 8 different times, with 8 separate ranks:

```bash
Rank:0, local_rank:0, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:2, local_rank:2, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:4, local_rank:4, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:3, local_rank:3, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:1, local_rank:1, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:7, local_rank:7, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:5, local_rank:5, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
Rank:6, local_rank:6, hostname:h007.gautschi.rcac.purdue.edu, world_size = 8
```

## Multi Node Distributed Data Parallel

Things become a bit more complicated when we want to distribute training across multiple nodes. With a total world size of 16 (2 nodes, with 8 ranks each) each process will have a "global rank" (1-16) as well as a "local rank" on that node, which will correspond the the GPU ID:

## Slurm Script

In this Slurm script, we are now requesting two Gautschi H nodes (each with all 8 H100 GPUs), and specify that each node should have a single task. Again, the single task on each node will spawn 8 separate processes (corresponding to the 8 local ranks) per node.

Before we start training, we must specify the master port and address that will be used for rendezvous communications. This is where all of the individual processes sync up for communication. Since there are now multiple nodes, we must pull out the first node (from ```$SLURM_JOB_NODELIST```) to serve as the master.
When we run ```srun torchrun``` here, and since we requested 1 task per node, **torchrun is being ran once on each node**, which in-turn spawns 8 processes (one for each rank) on each node.

```bash
#!/bin/bash
#SBATCH --job-name=ddp_multinode
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1  
#SBATCH --gpus-per-node=8
#SBATCH --cpus-per-task=14
#SBATCH --time=00:05:00
#SBATCH --constraint=H
#SBATCH --partition=ai
#SBATCH --qos=normal
#SBATCH --output=train_gautschi_multinode.out
#SBATCH --account=rcac

ml conda 
ml cuda
conda activate /depot/itap/user/envs/anaconda/gautschi/ddp_example

export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n1)
export MASTER_PORT=29500

srun torchrun \
    --nnodes=${SLURM_NNODES} \
    --node_rank=${SLURM_NODEID} \
    --nproc_per_node=${SLURM_GPUS_PER_NODE} \
    --rdzv_id=${SLURM_JOB_ID} \
    --rdzv_backend=c10d \
    --rdzv_endpoint=${MASTER_ADDR}:${MASTER_PORT} \
    ddp_train_gautschi.py
```

## PyTorch Script

Torchrun is handling all of the processes and environment variables that are needed to initiate the distributed process group, so no changes to the python script are needed!

## Output

From the output, we see that the Python script is now running 16 different times, with 8 processes on each node!

```bash
Rank:0, local_rank:0, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:8, local_rank:0, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:1, local_rank:1, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:3, local_rank:3, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:6, local_rank:6, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:4, local_rank:4, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:2, local_rank:2, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:7, local_rank:7, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:5, local_rank:5, hostname:h014.gautschi.rcac.purdue.edu, world_size = 16
Rank:9, local_rank:1, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:10, local_rank:2, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:15, local_rank:7, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:14, local_rank:6, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:11, local_rank:3, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:12, local_rank:4, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
Rank:13, local_rank:5, hostname:h016.gautschi.rcac.purdue.edu, world_size = 16
```

## Fully Sharded Data Parallel

Fully Sharded Data Parallel (FSDP) is useful if your model is too large to fit on a single GPU. FSDP allows you to shard your model across multiple GPUs, and lets NCCL handle communincation between them. The Slurm submission script looks almost identical to our single-node DDP example above:

```bash
#!/bin/bash
#SBATCH --job-name=fsdp_singlenode
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=8
#SBATCH --cpus-per-task=14
#SBATCH --time=00:20:00
#SBATCH --constraint=H
#SBATCH --partition=ai
#SBATCH --qos=normal
#SBATCH --output=fsdp_train_gautschi_singlenode.out
#SBATCH --account=rcac

#Change these to match your environment!
ml conda 
ml cuda
conda activate /depot/itap/verburgt/envs/anaconda/gautschi/ddp_example

# Optional Logging (Uncomment these if you are having issues!)
# export NCCL_DEBUG=INFO
# export NCCL_DEBUG_SUBSYS=ALL
# export TORCH_CPP_LOG_LEVEL=INFO
# export TORCH_DISTRIBUTED_DEBUG=DETAIL


# Rendezvous settings (do this before so torchrun sees them)
# Will be used for establishing the rendezvous point for all processes
export MASTER_ADDR=$(hostname)
export MASTER_PORT=29500

echo "MASTER_ADDR: $MASTER_ADDR"
echo "MASTER_PORT: $MASTER_PORT"
echo "SLURM_GPUS_ON_NODE: $SLURM_GPUS_PER_NODE"

torchrun --nproc_per_node=${SLURM_GPUS_PER_NODE} \
         --rdzv_endpoint=${MASTER_ADDR}:${MASTER_PORT} \
         fsdp_train_gautschi.py
```

Changes are primarily made to the python script:

```bash
import os
import torch
import torch.nn as nn
import torch.optim as optim
import torch.distributed as dist
from torch.distributed.fsdp import FullyShardedDataParallel as FSDP
from torch.distributed.fsdp import StateDictType, FullStateDictConfig, ShardedStateDictConfig
from torch.distributed.fsdp.wrap import size_based_auto_wrap_policy
from torch.distributed.fsdp import ShardingStrategy
from torch.utils.data import DataLoader
from torch.utils.data.distributed import DistributedSampler
from torchvision import datasets, transforms
import torch.nn.functional as F
import socket
from functools import partial

def setup():
    dist.init_process_group(backend="nccl")

def cleanup():
    dist.destroy_process_group()

class MNISTModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(1, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.pool = nn.MaxPool2d(2)
        self.fc1 = nn.Linear(64 * 7 * 7, 128)
        self.fc2 = nn.Linear(128, 10)

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(x.size(0), -1)
        x = F.relu(self.fc1(x))
        return self.fc2(x)

def train():
    setup()
    rank = dist.get_rank()
    world_size = dist.get_world_size()
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    device = torch.device("cuda", local_rank)
    print(f"Rank:{rank}, local_rank:{local_rank}, hostname:{socket.gethostname()}, world_size = {world_size}", flush=True)
    
    # Transform and dataset
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])

    train_dataset = datasets.MNIST(root="./data", train=True, download=True, transform=transform)
    sampler = DistributedSampler(train_dataset, num_replicas=world_size, rank=rank)
    dataloader = DataLoader(train_dataset, batch_size=64, sampler=sampler, num_workers=4, pin_memory=True)


    # Initialize FSDP model
    # We define a wrap policy to allow our relatively small model to be fully sharded
    base_model = MNISTModel().to(device)
    wrap_policy = partial(size_based_auto_wrap_policy, min_num_params=1)
    # Create the FSDP Model with the wrap policy
    fsdp_model = FSDP(
        base_model,
        auto_wrap_policy=wrap_policy,
        sharding_strategy=ShardingStrategy.FULL_SHARD,
    )

    #Show the number of parameters in each rank (for demonstration purposes)
    param_count = sum(p.numel() for p in base_model.parameters()) #The un-sharded model
    local_cnt = sum(p.numel() for p in fsdp_model.parameters()) # The sharded model
    t = torch.tensor([local_cnt], device=device)
    gathered = [torch.zeros_like(t) for _ in range(world_size)]
    dist.all_gather(gathered, t)
    if rank == 0:
        cnts = [int(x.item()) for x in gathered]
        print("Local param counts per rank:", cnts) #There might be extra padding in some shards!
        print("Total parameters:", param_count)

    optimizer = optim.Adam(fsdp_model.parameters(), lr=0.001)
    loss_fn = nn.CrossEntropyLoss()

    for epoch in range(5):
        sampler.set_epoch(epoch)
        fsdp_model.train()
        total_loss = 0.0
        for batch_x, batch_y in dataloader:
            batch_x = batch_x.to(device, non_blocking=True)
            batch_y = batch_y.to(device, non_blocking=True)

            optimizer.zero_grad()
            output = fsdp_model(batch_x)
            loss = loss_fn(output, batch_y)
            loss.backward()
            optimizer.step()

            total_loss += loss.item()

        print(f"Rank {rank}, Epoch {epoch}, Avg Loss: {total_loss / len(dataloader):.4f}", flush=True)

    print("done training", flush=True)
    

    #Aggregate the model and save it from rank 0
    dist.barrier() #Ensure all ranks are done

    # Build a full state dict but only on rank 0
    full_cfg = FullStateDictConfig(offload_to_cpu=True, rank0_only=True)
    with FSDP.state_dict_type(fsdp_model, StateDictType.FULL_STATE_DICT, full_cfg):
        state_dict = fsdp_model.state_dict()    

    #Save full model from only rank 0
    if rank == 0:
        torch.save(state_dict, "mnist_fsdp_full.pth")
        print("Model saved", flush=True)

    # Cam also save shards from each rank
    with FSDP.state_dict_type(fsdp_model, StateDictType.SHARDED_STATE_DICT, ShardedStateDictConfig()):
        shard = fsdp_model.state_dict()
        torch.save(shard, f"mnist_fsdp_shard_rank{rank}.pth")

    dist.barrier()
    cleanup()

if __name__ == "__main__":
    train()
```

The primary differences here are in saving the model. Instead of using ```DDP``` to create the model, we instead use ```FSDP```, along with a "wrap policy", which defines how, and which parts of our model, are to be wrapped inside FSDP. We also save the model differently. Since the model is sharded across multiple GPUs, we must aggregate the model onto a single node before saving the complete model. Alternatively, we can save the sharded model from each rank individually.

## Investigating Inter-Process Communications

If you enabled detailed logging by uncommenting these variables:

```bash
export NCCL_DEBUG=INFO
export NCCL_DEBUG_SUBSYS=ALL
export TORCH_CPP_LOG_LEVEL=INFO
export TORCH_DISTRIBUTED_DEBUG=DETAIL
```

You will be able to see detailed information reported by the rendezvous and NCCL backends. (**WARNING** This will produce *very* large logs)

When doing gradient updating, you will see that NCCL is handling the synchronization of data between ranks (with the ```AllReduce``` function):

```bash
h015:2073494:2073958 [2] NCCL INFO AllReduce: opCount 1e7 sendbuff 0x145d0be7e400 recvbuff 0x145d0be7e400 count 18816 datatype 7 op 0 root 0 comm 0x55956223bb90 [nranks=16] stream 0x55956223a9a0
```

You can also see that each of the ranks are frequently accessing the rendezvous backend ```(c10d)``` for getting and setting information about other ranks:

```bash
[I521 16:05:33.213697937 TCPStoreLibUvBackend.cpp:827] [c10d - trace] set key:/default_pg/0//cuda//NCCL_4_trace_start address:[h005.gautschi.rcac.purdue.edu]:57348
```

## FAQ

- **Is the ```NCCL``` "process group" backend different than the "rendezvous" backend? What's the difference?**
    - The rendezvous backend (typically ```c10d```) is what is used to allow different ranks to find, discover, and communicate with each other. Under the hood, it's effectively just a TCPStore key-value server that all ranks have access to. In the logs, you'll see each rank is often getting and setting values, which will be visible to all other ranks.

!!!note
    The ```NCCL``` (Nvidia Collective Communications Library) process group backend is what is facilitating distributed operations of for GPUs. For example, ```NCCL``` is handling the ```AllReduce``` function, which is averaging gradients across GPUs when backpropgating in a DDP() model. There are other process group backends (```gloo```, ```mpi```) but ```nccl``` is strongly recommended for use with Nvidia GPUs.

- **Do I need to use ```torchrun```? What exactly is ```torchrun``` doing?**
    - You don't necessarily need to use ```torchrun```, and could launch all processes with ```srun```, or even manually. However, you'll need to ensure that the environment for each rank are set up properly, which would be tedious and error-prone without torchrun.

- **How can I ensure all of the individual processes are synced?**
    - In the ```setup()``` function, you can add a ```torch.distributed.barrier()``` line, which will prevent all processes from continuing until all have reached the barrier.

- **Can I run distributed training in a container?**
    - Yes! You can use NGC (Nvidia GPU Cloud) containers to perform distributed training. Running with singularity may look something like this:

```bash
    singularity run --nv /apps/ngc/images/nvcr.io_nvidia_pytorch:25.01-py3.sif \
        torchrun --nproc_per_node=$SLURM_GPUS_PER_NODE \
                 --rdzv-backend=c10d \
                 --rdzv-endpoint=$MASTER_ADDR:$MASTER_PORT \
            ddp_train_gautschi.py
```

[**Return to the Python Examples section**](../python_example.md)
