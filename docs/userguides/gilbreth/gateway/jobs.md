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

# Jobs

There are four apps under the Jobs apps: Active Jobs and Job Composer. These are detailed below.

## Active Jobs

This shows you active SLURM jobs currently on the cluster. The default view will show you your current jobs, similar to `squeue --me`. Using the button labeled "Your Jobs" in the upper right allows you to select different filters by queue (account). All accounts output by `slist` will appear for you here. Using the arrow on the left hand side will expand the full job details.

![A table of active jobs](../../../assets/images/userguides/gilbreth/Gilbreth-ood-active-jobs.png)

The table of active jobs shows useful information such as queue, status, cluster, and ID. It can be sorted by clicking the headers of each column or searched with the "Filter" box above it.

## Job Composer

The Job Composer app allows you to create and submit jobs to the cluster. You can select from pre-defined templates (most of these are taken from the User Guide examples) or you can create your own templates for frequently used workflows.

![An image of job composer](../../../assets/images/userguides/gilbreth/Gilbreth-ood-job-composer.png)

<!-- 
### Creating Job from Existing Template

Click "New Job" menu, then select "From Template":

![The job composer interface](/knowledge/gateway/jobcomposer1.png)


When clicking the 'New Job' button a drop-down will show a few options. "From Template" is usually the second item in the list.

Then select from one of the available templates.

{::if resource.name != Gilbreth}
![A sortable data table containing a list of all the available templates.](/knowledge/gateway/job-template.png)


Select one of the templates by clicking its row in the table of available templates.

{::else}
![Table of templates](/knowledge/gateway/jobcomposer2.png)


A sortable data table containing a list of all the available templates.

{::/}

Click 'Create New Job' in second pane.

{::if resource.name != Gilbreth}
![The 'Create New Job' pane](/knowledge/gateway/create-simple-job.png)


The "Create New Job" pane will show form options for "Job Name", "Cluster", and "Script Name" with the "Create New Job" button below.

{::else}
!['Create New Job' pane](/knowledge/gateway/jobcomposer3.png)


The "Create New Job" pane will show form options for "Job Name", "Cluster", and "Script Name" with the "Create New Job" button below.

{::/}

Your new job should be selected in your list of jobs. In the 'Submit Script' pane you can see the job script that was generated with an 'Open Editor' link to open the script in the built-in editor. Open the file in the editor and edit the script as necessary. By default the job will specify standby queue - this should be changed as appropriate, along with the node and walltime requests.

{::if resource.name != Gilbreth}
![The 'Submit Script' pane](/knowledge/gateway/job-script.png)


The "Submit Script" pane will show a preview of the contents of the script file and action buttons below.

{::else}
!['Submit Script' pane](/knowledge/gateway/Gilbreth-ood-simple-jobs.png)


The "Submit Script" pane will show a preview of the contents of the script file and action buttons below.

{::/}

When you are finished with editing the job and are ready to submit, click the green 'Submit' button at the top of the job list. You can monitor progress from here or from the Active Jobs app. Once completed, you should see the output files appear:

![A list of files found in the output folder](/knowledge/gateway/jobcomposer5.png)


The folder contents will be listed, showing the resulting output files from running the submitted script.

Clicking on one of the output files will open it in the file editor for your viewing.

### Creating New Template

First, prepare a template directory containing a template submission script along with any input files. Then, to import the job into the Job Composer app, click the 'Create New Template' button. Fill in the directory containing your template job script and files in the first box. Give it an appropriate name and notes.

{::if resource.name != Gilbreth}
![The 'Create New Template' form](/knowledge/gateway/new-template.png)


The "Create New Template" form has inputs for "Path", "Name", "Cluster", and "Notes". If "Path" is left blank, a default job script will be added to the new template.

{::else}
![The 'Create New Template' form](/knowledge/gateway/jobcomposer6.png)


The "Create New Template" form has inputs for "Path", "Name", "Cluster", and "Notes". If "Path" is left blank, a default job script will be added to the new template.

{::/}

This template will now appear in your list of templates to choose from when composing jobs. You can now go create and submit a job from this new template. -->

## Job Performance Metrics

The job performance metrics dropdown provides an overview of your jobs within a specific time range. It reports the total jobs, wait time, average job duration, and total wall time of your jobs within the specified range. Memory, time, and CPU efficiency are also reported. 

![An image of job performance metrics](../../../assets/images/userguides/gilbreth/Gilbreth-ood-perf_metrics.png)

## My Jobs

My Jobs provides you with an overview of the state of your jobs. You can filter, by date, account, partition, QoS, and state. For any job, you can click the expand button to see job details. 

![A summary of a users jobs](../../../assets/images/userguides/gilbreth/Gilbreth-ood-my-jobs.png)

[Back to Gateway](../gateway.md)