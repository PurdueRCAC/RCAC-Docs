---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# PBS

This section walks through how to submit and run a Spark job using PBS on the compute nodes of ${resource.name}.

`pbs-spark-submit` launches an Apache Spark program within a PBS job, including starting the Spark master and worker processes in standalone mode, running a user supplied Spark job, and stopping the Spark master and worker processes. The Spark program and its associated services will be constrained by the resource limits of the job and will be killed off when the job ends. This effectively allows PBS to act as a Spark cluster manager.

The following steps assume that you have a Spark program that can run without errors.

To use Spark and pbs-spark-submit, you need to load the following two modules to setup SPARK\_HOME and PBS\_SPARK\_HOME environment variables.

```

module load spark
module load pbs-spark-submit
```

The following example submission script serves as a template to build your customized, more complex Spark job submission. This job requests 2 whole compute nodes for 10 minutes, and submits to the default queue.

```

#PBS -N spark-pi
#PBS -l nodes=2:ppn=${resource.nodecores}

#PBS -l walltime=00:10:00
#PBS -q ${resource.queue}
#PBS -o spark-pi.out
#PBS -e spark-pi.err

cd $PBS_O_WORKDIR
module load spark
module load pbs-spark-submit
pbs-spark-submit $SPARK_HOME/examples/src/main/python/pi.py 1000
```

In the submission script above, this command submits the `pi.py` program to the nodes that are allocated to your job.

```

pbs-spark-submit $SPARK_HOME/examples/src/main/python/pi.py 1000
```

You can set various environment variables in your submission script to change the setting of Spark program. For example, the following line sets the SPARK\_LOG\_DIR to $HOME/log. The default value is current working directory.

```

export SPARK_LOG_DIR=$HOME/log
```

The same environment variables can be set via the pbs-spark-submit command line argument. For example, the following line sets the SPARK\_LOG\_DIR to $HOME/log2.

```

pbs-spark-submit --log-dir $HOME/log2
```

The following table summarizes the environment variables that can be set. Please note that setting them from the command line arguments overwrites the ones that are set via shell export. Setting them from shell export overwrites the system default values.

| Environment Variable | Default | Shell Export | Command Line Args |
| --- | --- | --- | --- |
| SPAKR\_CONF\_DIR | $SPARK\_HOME/conf | export SPARK\_CONF\_DIR=$HOME/conf | --conf-dir  or -C |
| SPAKR\_LOG\_DIR | Current Working Directory | export SPARK\_LOG\_DIR=$HOME/log | --log-dir  or -L |
| SPAKR\_LOCAL\_DIR | /tmp | export SPARK\_LOCAL\_DIR=$RCAC\_SCRATCH/local | NA |
| SCRATCHDIR | Current Working Directory | export SCRATCHDIR=$RCAC\_SCRATCH/scratch | --work-dir  or -d |
| SPARK\_MASTER\_PORT | 7077 | export SPARK\_MASTER\_PORT=7078 | NA |
| SPARK\_DAEMON\_JAVA\_OPTS | None | export SPARK\_DAEMON\_JAVA\_OPTS="-Dkey=value" | -D key=value |

Note that SCRATCHDIR must be a shared scratch directory across all nodes of a job.

In addition, `pbs-spark-submit` supports command line arguments to change the properties of the Spark daemons and the Spark jobs. For example, the --no-stop argument tells Spark to not stop the master and worker daemons after the Spark application is finished, and the --no-init argument tells Spark to not initialize the Spark master and worker processes. This is intended for use in a sequence of invocations of Spark programs within the same job.

```

pbs-spark-submit --no-stop   $SPARK_HOME/examples/src/main/python/pi.py 800
pbs-spark-submit --no-init   $SPARK_HOME/examples/src/main/python/pi.py 1000
```

Use the following command to see the complete list of command line arguments.

```

pbs-spark-submit -h
```

To learn programming in Spark, refer to [Spark Programming Guide](http://spark.apache.org/docs/latest/programming-guide.html)

To learn submitting Spark applications, refer to [Submitting Applications](http://spark.apache.org/docs/latest/submitting-applications.html)