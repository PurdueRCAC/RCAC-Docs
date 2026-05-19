# Ansys Fluent

[Ansys](https://www.ansys.com) is a CAE/multiphysics engineering simulation software that utilizes finite element analysis for numerically solving a wide variety of mechanical problems. The software contains a list of packages and can simulate many structural properties such as strength, toughness, elasticity, thermal expansion, fluid dynamics as well as acoustic and electromagnetic attributes.

Ansys Licensing
---------------

The Ansys licensing on our community clusters is maintained by Purdue ECN group. There are two types of licenses: teaching and research. For more information, please refer to [ECN Ansys licensing page](https://engineering.purdue.edu/ECN/Support/KB/Docs/ANSYSFLUENTLicensing). If you are interested in purchasing your own research license, please send email to **software@ecn.purdue.edu**.

Ansys Workflow
--------------

Ansys software consists of several sub-packages such as Workbench and Fluent. Most simulations are performed using the Ansys Workbench console, a GUI interface to manage and edit the simulation workflow. It requires X11 forwarding for remote display so a SSH client software with X11 support or a remote desktop portal is required. Please see [Logging In](../../../accounts.md#logging-in-to-bell) section for more details. To ensure preferred performance, [ThinLinc](../../../accounts.md#thinlinc) remote desktop connection is highly recommended.

Typically users break down larger structures into small components in geometry with each of them modeled and tested individually. A user may start by defining the dimensions of an object, adding weight, pressure, temperature, and other physical properties.

Ansys Fluent is a computational fluid dynamics (CFD) simulation software known for its advanced physics modeling capabilities and accuracy. Fluent offers unparalleled analysis capabilities and provides all the tools needed to design and optimize new equipment and to troubleshoot existing installations.

In the following sections, we provide step-by-step instructions to lead you through the process of using Fluent. We will create a classical elbow pipe model and simulate the fluid dynamics when water flows through the pipe. The project files have been generated and can be downloaded via [fluent\_tutorial.zip](https://www.rcac.purdue.edu/knowledge/run/examples/apps/ansys/fluent_tutorial.zip).

Loading Ansys Module
--------------------

Different versions of Ansys are installed on the clusters and can be listed with `module spider` or `module avail` command in the terminal.

```
$ module avail ansys/
---------------------- Core Applications -----------------------------
   ansys/2019R3    ansys/2020R1    ansys/2021R2    ansys/2022R1 (D)
```

Before launching Ansys Workbench, a specific version of Ansys module needs to be loaded. For example, you can `module load ansys/2021R2` to use the latest Ansys 2021R2. If no version is specified, the default module -> (D) (`ansys/2022R1` in this case) will be loaded. You can also check the loaded modules with `module list` command.

Launching Ansys Workbench
-------------------------

Open a terminal on Bell, enter `rcac-runwb2` to launch Ansys Workbench.

!!! Note
      You can also use `runwb2` to launch Ansys Workbench. The main difference between `runwb2`and `rcac-runwb2` is that the latter sets the project folder to be in your scratch space. Ansys has an known bug that it might crash when the project folder is set to `$HOME` on our systems.

## In This Section

- [Case Calculating with Fluent](ansysfluent/case_calculating_with_fluent.md)
- [Fluent Text User Interface and Journal File](ansysfluent/fluent_text_user_interface_and_journal_file.md)
- [Preparing Case Files for Fluent](ansysfluent/preparing_case_files_for_fluent.md)
- [Submitting Fluent jobs to SLURM](ansysfluent/submit_fluent_jobs_to_slurm.md)
