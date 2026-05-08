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

# Profile Manager

MATLAB offers two kinds of profiles for parallel execution: the `local` profile and user-defined cluster profiles. The 'local' profile runs a MATLAB job on the processor core(s) of the same compute node, or front-end, that is running the client. To run a MATLAB job on compute node(s) different from the node running the client, you must define a Cluster Profile using the `Cluster Profile Manager`.

To prepare a user-defined cluster profile, use the `Cluster Profile Manager` in the `Parallel` menu. This profile contains the scheduler details (queue, nodes, processors, walltime, etc.) of your job submission. Ultimately, your cluster profile will be an argument to MATLAB functions like `batch()`.

For your convenience, a generic cluster profile is provided that can be downloaded: [`myslurmprofile.settings`](../../../../assets/images/userguides/gilbreth/matlab/myslurmprofile.settings)

Please note that modifications are very likely to be required to make `myslurmprofile.settings` work. You may need to change values for number of nodes, number of workers, walltime, and submission queue specified in the file. As well, the generic profile itself depends on the particular job scheduler on the cluster, so you may need to download or create two or more generic profiles under different names. Each time you run a job using a Cluster Profile, make sure the specific profile you are using is appropriate for the job and the cluster.

To import the profile, start a MATLAB session and select `Manage Cluster Profiles...` from the Parallel menu. In the Cluster Profile Manager, select `Import`, navigate to the folder containing the profile, select `myslurmprofile.settings` and click `OK`. Remember that the profile will need to be customized for your specific needs. If you have any questions, please contact us.

For detailed information about MATLAB's Parallel Computing Toolbox, examples, demos, and tutorials:

* [MATLAB - Parallel Computing Toolbox](http://www.mathworks.com/help/distcomp/index.html)
* [MATLAB Parallel Computing Toolbox: Introduction to Parallel Solutions](http://www.mathworks.com/help/distcomp/introduction-to-parallel-solutions.html)
* [MATLAB Parallel Computing Toolbox: Clusters and Cluster Profiles](https://www.mathworks.com/help/parallel-computing/discover-clusters-and-use-cluster-profiles.html)

[**Back to Matlab**](../matlab_example.md)