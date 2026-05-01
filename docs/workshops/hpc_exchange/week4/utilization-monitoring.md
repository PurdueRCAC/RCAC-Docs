# Resource Utilization and Monitoring

[Back to Week 4](./index.md)

Now that we can check our job history, let's learn how we can check that we are utilizing our resources (CPUs, GPUs, memory) efficiently. There is no special way to infer usage other than to test directly.

## Checking Usage Directly

You can use the `jobinfo` program with the ID to see which node your job is on and `ssh` directly there. Let's run our job again 

```bash
$ sbatch --exclusive myjob.sh
Submitted batch job 19823415

$ squeue --me
JOBID     USER       ACCOUNT  NAME        NODES  CPUS  TIME_LIMIT  ST  TIME
19823415  username   lab_queue example.sh 1      8      10:00    R  0:05
```

!!! note
     The use of `--exclusive` (or similar) is important here to not get polluted by others' jobs on the node. `--exclusive` is just a restraint that ensures that we are the only person running a job on the node that gets allocated. 

Once you've done `jobinfo` to determine which node your job has landed on, you can `ssh` directly to the node. This is something you can do only if you have a Slurm job on the node. Once on the node, use a tool like `htop` to inspect CPU and memory activity (press `q` to quit).

```bash
username@login03.negishi:[~] $ jobinfo 19823415
...
Nodes               : a200
```
```bash
username@login03.negishi:[~] $ ssh a200

username@a200.negishi:[~] $ top -u username # Or htop
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                                   
2145269 username  21   1 3956692   2.3g  19384 R  62.5   0.9   0:17.66 python                                                                    
2145581 username  20   0  276372   7204   4128 R  25.0   0.0   0:00.29 top                                                                       
2145062 username  20   0   89956   9836   8060 S   0.0   0.0   0:00.09 systemd       
<press "q" to exit>
```

!!! note
     When using `ssh` within a cluster's subnet, there's no need to specify the subnet, or the username. Further, we don't allow users to `ssh` onto a node unless they have job running there.

## Monitor

However, just `ssh`ing onto the node isn't *real* telemetry. We want to collect and store the data. To do this, we can use the `monitor` utility (which is RCAC specific) to gather data on CPU and GPU metrics.

```bash
$ module load monitor
$ monitor cpu memory
DATE TIME HOSTNAME monitor.cpu.memory 15.7
DATE TIME HOSTNAME monitor.cpu.memory 15.7
DATE TIME HOSTNAME monitor.cpu.memory 15.7
DATE TIME HOSTNAME monitor.cpu.memory 15.7
...
```

This will run indefinitely, so we need to interrupt it with a keyboard interrupt. Windows and Linux users can press **`Ctrl+c`** to stop it. Mac users will use **`Cmd + .`**.

!!! note
     Use `--help` or `man monitor` to check for usage details. You can also check our user guides for more recommendations.

Now let's do this for an actual Slurm job. Lets edit our `example.sh` submission script to look like this:
```bash title="myjob.sh" linenums="1" hl_lines="14 22-23"
#!/bin/bash
#SBATCH  --account=hpcexc
#SBATCH  --partition=cpu
#SBATCH  --qos=normal
#SBATCH  --time=0-1:00:00
#SBATCH  --nodes=1
#SBATCH  --cpus-per-task=32
#SBATCH  --output="example.out"

module load conda
conda activate example
echo "Running with the python interpreter: $(which python)"

module load monitor

#Lets move to our scratch directory to do computational work
mkdir -p ${SCRATCH}/example
cd ${SCRATCH}/example


#Start background jobs for monitoring!
monitor cpu percent --csv > cpu_per.csv &
monitor cpu memory --csv > cpu_mem.csv &

#Lets run our python file from our Home directory, and write the output
python ~/example.py > results.out # Write the output into our current directory
echo "Python script done at $(date)!"
```


Be sure to ask for all the  (with `--exclusive`) on the node so you don't collect data on your neighbor's job! Start each monitoring task before starting your application.

??? question "Why do we need to use the `&` on each of these commands in the script?"
     The `&` puts the process into the background! If we didn't, the node would be stuck on the monitor command until the walltime ran out. Check out [Managing Processes](../week3/processes.md) from Week 3 if you need a refresher.

Now, let's run the new monitored submission file:
```bash
$ sbatch --exclusive example.sh
Submitted batch job 2095586
```

Once it's done, let's look at the output of the files:
```bash
$ cd $SCRATCH/example
$ cat cpu_mem.csv
DATE, TIME, HOSTNAME, monitor.cpu.memory, 15.7
DATE, TIME, HOSTNAME, monitor.cpu.memory, 15.7
DATE, TIME, HOSTNAME, monitor.cpu.memory, 15.7
DATE, TIME, HOSTNAME, monitor.cpu.memory, 15.7
...
$ cat cpu_per.csv
DATE, TIME, HOSTNAME, monitor.cpu.percent, 0.5
DATE, TIME, HOSTNAME, monitor.cpu.percent, 0.5
DATE, TIME, HOSTNAME, monitor.cpu.percent, 0.5
DATE, TIME, HOSTNAME, monitor.cpu.percent, 0.5
...
$ cd ~
```

??? question "Why is the CPU utilization so low around 0.5%?"
     Because currently, our workflow can only use a single CPU at a time, so the rest of the CPUs that we have allocated to our job are idle.

**Next Section:** [Managing Workloads and Jobs](workload-management.md)
