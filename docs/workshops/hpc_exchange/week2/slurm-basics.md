# Cluster Job Submission (Slurm)


[Back to Week 2](./index.md)


In this section, we will talk about how you can interact with the scheduler to submit jobs to the cluster

A scheduler is software that manages how computing resources are shared among users. At RCAC, we use **Slurm**, the most widely used scheduler at major computing centers.

Because there are a limited number of compute nodes and many users submitting jobs, the scheduler is responsible for deciding when and where each job runs. It tracks resource requests (such as CPUs, GPUs, memory, and time limits), queues, jobs, and launches them when the requested resources become available.


![slurm_submission](../_static/slurm_submission.png)


## Run Types

Before we get started with how to run jobs on the compute nodes, we should talk about the two paradigms of running code on a supercomputer:

* Batch mode

* Interactively

In the `batch` paradigm, you write your code, and then submit one (or many) instances of your code using the scheduler and it can run on arbitrarily many nodes without worry of interruption.

In the `interactive` paradigm, you get a session on a compute node (using the gateway, ssh, or ThinLinc), and the run your code directly. However, if your network drops, your code could be interrupted.

## Batch Scripts

Users submit their work to Slurm in the form of batch job scripts, which are shell scripts that describe the resources needed and the commands to run. This shell script can be submitted to the scheduler via the `sbatch` program. The details of what resources are requested are called directives and are commonly inside the script itself, but can also be passed to the `sbatch` program manually. Let's take a look at an example job script, `myjob.sh`:

```bash title="myjob.sh" linenums="1"
#!/bin/bash
#SBATCH  --account=hpcexc
#SBATCH  --partition=cpu
#SBATCH  --qos=normal
#SBATCH  --time=0-1:00:00
#SBATCH  --nodes=1
#SBATCH  --ntasks-per-node=1

cd $SLURM_SUBMIT_DIR

module load conda
conda activate example_env
python example.py
echo "Script is finished! Exiting..."
```


### Submission
Once you are ready, submit it to the scheduler with the `sbatch` program:

```bash
$ ls
example.py  myjob.sh  ...

$ sbatch myjob.sh
Submitted batch job 32209880
```
`sbatch` will read the directives that we put in the script, and schedule your job script to be ran.  You have now submitted your first supercomputing resource allocation request! This job ID number is helpful to note down as it can be used elsewhere.

!!! note 
    The output of your job will, by default, be saved in files with this ID (e.g. `slurm-32209880.out`).

    Once our job is done, we can see the output with:
    ```bash
    $ ls slurm-32209880.out
    slurm-32209880.out

    $cat slurm-32209880.out # cat prints the contents of a file!
    2499.9118
    ```

--- 

Let's take a closer look at the individual pieces of information we need to provide Slurm for it to schedule our job. 


=== "Account"
    ```bash linenums="1" hl_lines="2"
    #!/bin/bash
    #SBATCH  --account=hpcexc
    #SBATCH  --partition=cpu
    #SBATCH  --qos=normal
    #SBATCH  --time=0-1:00:00
    #SBATCH  --nodes=1
    #SBATCH  --ntasks-per-node=1
    ```
    The first of which is what account to submit
    that job to. Accounts are typically associated with a research group or department. Each account will have access to a limited amount of resources that they have purchased.

    Use the `slist` program to show which Slurm accounts are available for you to submit to, and what their current usage is. 

    ```
    $ slist
                            Current Negishi Accounts                                
    ==============================================================================    
                |              CPU Partition              |     Standby QOS        
    Accounts       |   Total     Queue      Run      Free    |   Queue      Run       
    ============== | ========= ========= ========= ========= | ========= =========    
    hpcexc         |        64         0        10        54 |         0         0

    ```

    In the above example, the group has bought 64 cores of priority access. However, someone from this group is using 10 cores, sop this group has 54 cores of priority access left.

=== "Partition"
    ```bash linenums="1" hl_lines="3"
    #!/bin/bash
    #SBATCH  --account=hpcexc
    #SBATCH  --partition=cpu
    #SBATCH  --qos=normal
    #SBATCH  --time=0-1:00:00
    #SBATCH  --nodes=1
    #SBATCH  --ntasks-per-node=1
    ```

    Remember that not all backend/compute nodes are the same! Some nodes have special hardware like GPUs or increased RAM, or are set aside for a dedicated use like machine learning training. To manage this, we use partitions, which are just subsets of the compute nodes. We need to tell Slurm which partition we intend on using.

    To show the different partitions
    available on the cluster, run the `showpartitions`
    program:

    ```
    $ showpartitions
    Partition statistics for cluster negishi at Thu Jul 17 16:12:58 EDT 2025
    Partition       #Nodes     #CPU_cores  Cores_pending   Job_Nodes MaxJobTime Cores Mem/Node
    Name  State   Total  Idle  Total   Idle Resorc  Other   Min   Max  Day-hr:mn /node     (GB)
    cpu      up     446     0  57088   2078      0  15973     1 infin   infinite   128     257
    highmem  up       6     0    768    236      0   2114     1 infin   infinite   128    1031
    gpu      up       5     3    160    132      0      0     1 infin   infinite    32     515
    ```

    !!! note
        On many clusters, certain accounts will only be able to submit to specific partitions.
     

=== "QoS"
    ```bash linenums="1" hl_lines="4"
    #!/bin/bash
    #SBATCH  --account=hpcexc
    #SBATCH  --partition=cpu
    #SBATCH  --qos=normal
    #SBATCH  --time=0-1:00:00
    #SBATCH  --nodes=1
    #SBATCH  --ntasks-per-node=1
    ```
    The *Quality of Service* (QoS) for the job determines the priority and some constraints of your job. The two primary QoS values will be `normal` and `standby`:

    * The `normal` QoS gives your job increased priority, but subtracts from your accounts available resources. You can think of this as the "Fast-Pass" entrance at the amusement park that lets you skip the line.
        * `normal` jobs can run for up to 2 weeks.

    * The `standby` QoS doesn't subtract from your accounts resources, but are given very low priority to run.
        * `standby` jobs are only allowed to run up to 4 hours

    ![An Image showing a long queue under a standby sign, and an empty line under a sign labeled normal](../_static/standby_vs_normal.png)

=== "Resources"
    ```bash linenums="1" hl_lines="5-7"
    #!/bin/bash
    #SBATCH  --account=hpcexc
    #SBATCH  --partition=cpu
    #SBATCH  --qos=normal
    #SBATCH  --time=0-1:00:00
    #SBATCH  --nodes=1
    #SBATCH  --ntasks-per-node=1
    ```

    We may also need to specify what resources we want to request, and for how long

    * `--time` is the maximum time your job will run. If your job has not yet finished in this amount of run time, it will be cancelled.

    * `--nodes` is the number of nodes you want to request. 

    * `--ntasks-per-node` is the number of CPUs

---

!!! note
    Required directives may vary by cluster and partition. For example, some clusters will require you to request memory with `--mem`, or to list how many GPUs you want access to with `--gres=gpu:`. See the user guide for the cluster you are using for more details, and the [sbatch documentation](https://slurm.schedmd.com/sbatch.html) for a complete list of options. 

    | Long Form |  Short Form | Description |
    |-----------|-------------|-------------|
    | --account | -A          | Which account to submit under |
    | --partition | -p  | Which partition to submit to|
    | --qos   | -q | quality of service for job| 
    | --nodes | -N | Number of nodes requested | 
    | --ntasks | -n | Number of tasks requested |
    | --ntasks-per-node | | Number of tasks requested per node |
    | --cpus-per-task | -c | CPUs to be allocated for each task  |
    | --cpus-per-gpu |  | Number of CPUs allocated per GPU |
    | --mem | | Amount of Memory to request|
    | --mem-per-cpu | | Memory requested per allocated CPU|
    | --time | -t | Length of time to run job for |
    | --gres=gpu:<count> | | Number of gpus requested
    | --gpus-per-node| | Number of gpus requested for each node


## Interactive Jobs
To get an interactive job (or essentially a shell on a compute node), use the `sinteractive` program (which is RCAC specific). You will need to specify the same parameters as with `sbatch` (e.g. account, partition, QoS, cores, nodes, time).


``` hl_lines="1 8"
username@login03.negishi:[~] $ sinteractive -A hpcexc -p cpu -q normal -n 1 -t 00:10:00
salloc: Pending job allocation 19809515
salloc: job 19809515 queued and waiting for resources
salloc: job 19809515 has been allocated resources
salloc: Granted job allocation 19809515
salloc: Waiting for resource configuration
salloc: Nodes a195 are ready for job
username@a195.negishi:[~] $
```


Notice that before the `sinteractive` program was run, we were on `login03.negishi` and after it was run, we are now on `a195.negishi`, this is a good way to tell if you are running on a compute node, or on a login node.

To get out of the interactive slurm job, simply run the `exit` command and you'll be returned to the login node you were on previously.


## Open OnDemand Interactive Apps
If you'd rather avoid running jobs on the command line entirely, RCAC offers Open OnDemand interactive apps that handle the submission to the compute backend for you. 


Most notably, we have an "Open OnDemand Desktop" application, which will give you a virtual desktop (running on a cluster backend node) available in your browser. This can be incredibly useful if you need to run graphical applications on RCAC, which don't run well over SSH on the command line.


![Open OnDemand Desktop](../_static/ood_desktop.png)



## Job Monitoring and Cancelling

You can use the `squeue` program to list currently scheduled (pending and running) jobs. By default it will show all jobs from all users on the cluster, which leads to a lot of output. You can limit this to just your jobs with the `--me` flag:

```bash
$ squeue --me
JOBID      USER     ACCOUNT      PART QOS     NAME       NODES TRES_PER_NODE   CPUS  TIME_LIMIT ST TIME
32541229   username hpcexc       cpu  normal  interactiv     1 N/A                8       30:00  R 0:09

```
This can give you important information such as the status of your job (`R` for running, `PD` for pending, and `CG` for cancelling), as well as the current run time. 


To learn more about the parameters of a single job, you can use the `jobinfo` program. To use `jobinfo`, the command would be `jobinfo JOB_ID`, where the `JOB_ID` is replaced with the job ID mentioned above (which you can also check with the `squeue` program).

```bash
$ jobinfo 32209880
Name : myjob.sh
User : username
Account : hpcexc
Partition : cpu
Nodes : a305
```
There are also `jobenv`, `jobcmd`, and `jobscript` programs that tell you more information about the job as it was submitted.

!!! Note
    These four commands: `jobinfo`, `jobenv`, `jobcmd`, and `jobscript` are all RCAC-specific. It is not guaranteed that other HPC centers will have these programs implemented.

To cancel a job, use the `scancel` program. It used by running `scancel JOB_ID`, where `JOB_ID` is replaced with the job ID mentioned before.

```bash
$ scancel 32209880
```

!!! warning
    Cancelling an application this way isn't very "nice", in that it immediately stops everything and can cause problems if in the middle of file operations.

## Good citizenship

Last, but not least, there are four main points to touch
on about good citizenship on HPC resources:

* Do not request for excessive resources knowingly
   (don't ask for a large memory node if it's not needed)
* Do not abuse file systems (heavy I/O for `/depot` space, use `/scratch` instead)
* Do not submit lots of tiny jobs, instead use the pilot-job pattern with a workflow tool
    * We'll tak about this in [Week 4: Workload Management](../week4/workload-management.md).
* Do not submit jobs and "camp" (don't submit a GPU job from the Gateway for 24 hours so it's ready for you in the afternoon and then forget about it)

<!-- 
Continue to [Week 3](../week3/index.md) -->

Next section: [File Storage and Transfer](./storage-transfer.md) 