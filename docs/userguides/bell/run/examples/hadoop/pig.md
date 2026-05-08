---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Pig

[Apache Pig](http://pig.apache.org/) is a platform for analyzing large data sets that consists of a high-level language for expressing data analysis programs, coupled with infrastructure for evaluating these programs.

Before to use Pig, setup environment variables:

```
$ module load java
$ export PATH=/apps/hathi/pig/bin:$PATH
```

The following steps walk through how to run Pig in interactive mode. Before to run, you should put the `/etc/passwd` file from you local system to `hdfs:///user/yourusername/`. These Pig Latin statements extract all user IDs from the `/etc/passwd` file.

First, invoke the Grunt shell:

```
$ pig -x mapreduce
15/10/06 16:32:01 INFO pig.ExecTypeProvider: Trying ExecType : LOCAL
15/10/06 16:32:01 INFO pig.ExecTypeProvider: Trying ExecType : MAPREDUCE
15/10/06 16:32:01 INFO pig.ExecTypeProvider: Picked MAPREDUCE as the ExecType
2015-10-06 16:32:01,856 [main] INFO  org.apache.pig.Main - Apache Pig version 0.15.0 (r1682971) compiled Jun 01 2015, 11:44:35
2015-10-06 16:32:01,857 [main] INFO  org.apache.pig.Main - Logging error messages to: /path/to/pig/pig_1444163521852.log
2015-10-06 16:32:01,908 [main] INFO  org.apache.pig.impl.util.Utils - Default bootup file /path/to/.pigbootup not found
2015-10-06 16:32:02,808 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
2015-10-06 16:32:02,808 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
2015-10-06 16:32:02,809 [main] INFO  org.apache.pig.backend.hadoop.executionengine.HExecutionEngine - Connecting to hadoop file system at: hdfs://hathi-adm.rcac.purdue.edu:8020
2015-10-06 16:32:02,816 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - mapred.used.genericoptionsparser is deprecated. Instead, use mapreduce.client.genericoptionsparser.used
2015-10-06 16:32:04,362 [main] INFO  org.apache.hadoop.conf.Configuration.deprecation - fs.default.name is deprecated. Instead, use fs.defaultFS
grunt> 
```

Then, enter the Pig Latin statements interactively at the grunt prompt:

```
$ grunt> A = load 'passwd' using PigStorage(':');
$ grunt> B = foreach A generate $0 as id;
$ grunt> dump B;
```

The following steps walk through how to run Pig in batch mode.

First, save the following statements in the Pig script (id.pig):

```
/* id.pig */

A = load 'passwd' using PigStorage(':');  -- load the passwd file 
B = foreach A generate $0 as id;  -- extract the user IDs 
store B into 'id.out';  -- write the results to a file name id.out
```

Then, run the Pig script in batch mode:

```
$ pig -x mapreduce id.pig
```

This is generate output in `hdfs:///user/yourusername/id.put/`.

To learn programming in Pig, refer to: [Pig Overview](http://pig.apache.org/docs/r0.15.0/)