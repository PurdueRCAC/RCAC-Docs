---
tags:
  - Hammer
authors:
  - jin456
resource: Hammer
search:
  boost: 2
---

# Hadoop

## HBase

[Apache HBase](http://hbase.apache.org/) is the Hadoop database, a distributed, scalable, big data store. HBase is an open-source, distributed, versioned, non-relational database modeled after Google's [Bigtable: A Distributed Storage System for Structured Data](http://research.google.com/archive/bigtable.html) by Chang et al. Just as Bigtable leverages the distributed data storage provided by the Google File System, Apache HBase provides Bigtable-like capabilities on top of Hadoop and HDFS.

## Hive

[Apache Hive](https://hive.apache.org/) is a data warehouse infrastructure built on top of Hadoop for providing data summarization, query, and analysis. Hive provides a mechanism to project structure onto this data and query the data using a SQL-like language called HiveQL. At the same time this language also allows traditional map/reduce programmers to plug in their custom mappers and reducers when it is inconvenient or inefficient to express this logic in HiveQL.

Load java module:

```
$ module load java
```

Export environment variables:

```
$ source /etc/default/hadoop
$ export HIVE_HOME=/apps/hathi/hive/
$ export PATH=$HIVE_HOME/bin:$HIVE_HOME/hcatalog/bin:$PATH
```

To access Hive:

```
$ hive
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.reduce.tasks is deprecated. Instead, use mapreduce.job.reduces
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.min.split.size is deprecated. Instead, use mapreduce.input.fileinputformat.split.minsize
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.reduce.tasks.speculative.execution is deprecated. Instead, use mapreduce.reduce.speculative
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.min.split.size.per.node is deprecated. Instead, use mapreduce.input.fileinputformat.split.minsize.per.node
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.input.dir.recursive is deprecated. Instead, use mapreduce.input.fileinputformat.input.dir.recursive
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.min.split.size.per.rack is deprecated. Instead, use mapreduce.input.fileinputformat.split.minsize.per.rack
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.max.split.size is deprecated. Instead, use mapreduce.input.fileinputformat.split.maxsize
15/09/10 15:14:16 INFO Configuration.deprecation: mapred.committer.job.setup.cleanup.needed is deprecated. Instead, use mapreduce.job.committer.setup.cleanup.needed

Logging initialized using configuration in jar:file:/apps/hathi/apache-hive-0.14.0-bin/lib/hive-common-0.14.0.jar!/hive-log4j.properties
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/lib/gphd/hadoop/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/apps/hathi/apache-hive-0.14.0-bin/lib/hive-jdbc-0.14.0-standalone.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
hive>
```

To create and browse Hive tables:

```
$ hive> CREATE TABLE pokes_user (foo INT, bar STRING);
OK
Time taken: 1.56 seconds
$ hive> CREATE TABLE invites_user (foo INT, bar STRING) PARTITIONED BY (ds STRING);
OK
Time taken: 0.125 seconds
$ hive> SHOW TABLES;
OK
invites_user
pokes_user
Time taken: 0.114 seconds, Fetched: 2 row(s)
```

To browse Hive tables from hdfs:

* Go to <http://hathi-adm.rcac.purdue.edu:50070>
* Click on "Browse the filesystem"
* Navigate to "/user/hive/warehouse"

To run the HCatalog Server from the command-line:

```
$ cd /apps/hathi/hive
$ hcatalog/bin/hcat
```

For more information, refer to [GettingStarted - Apache Hive - Apache Software Foundation.](https://cwiki.apache.org/confluence/display/Hive/GettingStarted#GettingStarted-SimpleExampleUseCases)

## Pig

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

[**Back to the Running Jobs section**](../index.md)
