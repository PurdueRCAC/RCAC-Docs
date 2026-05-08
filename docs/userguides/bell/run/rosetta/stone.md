---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Quick Guide

This table lists the most common command, environment variables, and job specification options used by the workload management systems and their equivalents (adapted from <http://www.schedmd.com/slurmdocs/rosetta.html>).

Common commands across workload management systems

| User Commands | PBS/Torque | Slurm |
| --- | --- | --- |
| Job submission | `qsub [script_file]` | `sbatch [script_file]` |
| Interactive Job | `qsub -I` | `sinteractive` |
| Job deletion | `qdel [job_id]` | `scancel [job_id]` |
| Job status (by job) | `qstat [job_id]` | `squeue [-j job_id]` |
| Job status (by user) | `qstat -u [user_name]` | `squeue [-u user_name]` |
| Job hold | `qhold [job_id]` | `scontrol hold [job_id]` |
| Job release | `qrls [job_id]` | `scontrol release [job_id]` |
| Queue info | `qstat -Q` | `squeue` |
| Queue access | `qlist` | `slist` |
| Node list | `pbsnodes -l` | `sinfo -N`  `scontrol show nodes` |
| Cluster status | `qstat -a` | `sinfo` |
| GUI | `xpbsmon` | `sview` |
| Environment | PBS/Torque | Slurm |
| --- | --- | --- |
| Job ID | `$PBS_JOBID` | `$SLURM_JOB_ID` |
| Job Name | `$PBS_JOBNAME` | `$SLURM_JOB_NAME` |
| Job Queue/Account | `$PBS_QUEUE` | `$SLURM_JOB_ACCOUNT` |
| Submit Directory | `$PBS_O_WORKDIR` | `$SLURM_SUBMIT_DIR` |
| Submit Host | `$PBS_O_HOST` | `$SLURM_SUBMIT_HOST` |
| Number of nodes | `$PBS_NUM_NODES` | `$SLURM_JOB_NUM_NODES` |
| Number of Tasks | `$PBS_NP` | `$SLURM_NTASKS` |
| Number of Tasks Per Node | `$PBS_NUM_PPN` | `$SLURM_NTASKS_PER_NODE` |
| Node List (Compact) | n/a | `$SLURM_JOB_NODELIST` |
| Node List (One Core Per Line) | `LIST=$(cat $PBS_NODEFILE)` | `LIST=$(srun hostname)` |
| Job Array Index | `$PBS_ARRAYID` | `$SLURM_ARRAY_TASK_ID` |
| Job Specification | PBS/Torque | Slurm |
| --- | --- | --- |
| Script directive | `#PBS` | `#SBATCH` |
| Queue | `-q [queue]` | `-A [queue]` |
| Node Count | `-l nodes=[count]` | `-N [min[-max]]` |
| CPU Count | `-l ppn=[count]` | `-n [count]`  Note: total, not per node |
| Wall Clock Limit | `-l walltime=[hh:mm:ss]` | `-t [min]` OR  `-t [hh:mm:ss]` OR  `-t [days-hh:mm:ss]` |
| Standard Output FIle | `-o [file_name]` | `-o [file_name]` |
| Standard Error File | `-e [file_name]` | `-e [file_name]` |
| Combine stdout/err | `-j oe` (both to stdout) OR  `-j eo` (both to stderr) | `(use -o without -e)` |
| Copy Environment | `-V` | `--export=[ALL | NONE | variables]`  Note: default behavior is `ALL` |
| Copy Specific Environment Variable | `-v myvar=somevalue` | `--export=NONE,myvar=somevalue` OR  `--export=ALL,myvar=somevalue` |
| Event Notification | `-m abe` | `--mail-type=[events]` |
| Email Address | `-M [address]` | `--mail-user=[address]` |
| Job Name | `-N [name]` | `--job-name=[name]` |
| Job Restart | `-r [y|n]` | `--requeue` OR  `--no-requeue` |
| Working Directory |  | `--workdir=[dir_name]` |
| Resource Sharing | `-l naccesspolicy=singlejob` | `--exclusive` OR  `--shared` |
| Memory Size | `-l mem=[MB]` | `--mem=[mem][M|G|T]` OR  `--mem-per-cpu=[mem][M|G|T]` |
| Account to charge | `-A [account]` | `-A [account]` |
| Tasks Per Node | `-l ppn=[count]` | `--tasks-per-node=[count]` |
| CPUs Per Task |  | `--cpus-per-task=[count]` |
| Job Dependency | `-W depend=[state:job_id]` | `--depend=[state:job_id]` |
| Job Arrays | `-t [array_spec]` | `--array=[array_spec]` |
| Generic Resources | `-l other=[resource_spec]` | `--gres=[resource_spec]` |
| Licenses |  | `--licenses=[license_spec]` |
| Begin Time | `-A "y-m-d h:m:s"` | `--begin=y-m-d[Th:m[:s]]` |

See the official [Slurm Documentation](http://slurm.schedmd.com/documentation.html) for further details.