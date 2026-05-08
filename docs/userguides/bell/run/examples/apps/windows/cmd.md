---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Command line

If you wish to work with Windows VMs on the command line or work into scripted workflows you can interact directly with the Windows system:

{::if resource.qsub\_needs\_gpu == 1}

* Submit an interactive PBS job, with the appropriate walltime and queue:

  ```
  $ sbatch -time=8:00:00 --nodes=1 --ntasks-per-node=1 --gres=gpu:1
  ```
* Load the "qemu" module:

  ```
  $ module load qemu
  ```

{::elseif resource.batchsystem == pbs}

* Submit an interactive PBS job, with the appropriate walltime and queue:

  ```
  $ qsub -X -I -l walltime=8:00:00 -l nodes=1:ppn=${resource.nodecores}
  ```
* Load the "qemu" module:

  ```
  $ module load qemu
  ```

{::/} {::if resource.name != Weber}

Copy a Windows 2016 Server VM image to your storage. Scratch or Research Data Depot are good locations to save a VM image. If you are using scratch, remember that [scratch spaces are temporary](/policies/scratchpurge), and be sure to safely back up your disk image somewhere permanent, such as Research Data Depot or Fortress. To copy a basic image:

`$ cp /apps/external/apps/windows/images/latest.qcow2  $RCAC_SCRATCH/windows.qcow2`

To copy a GIS image:

```
$ cp /depot/itap/windows/gis/2k16.qcow2 $RCAC_SCRATCH/windows.qcow2
```

{::/}

To launch a virtual machine in a batch job, use the "windows" script, specifying the path to your Windows virtual machine image. With no other command-line arguments, the `windows` script will autodetect a number cores and memory for the Windows VM. {::if resource.batchsystem == pbs} A Windows network connection will be made to your cluster scratch directory. {::else} A Windows network connection will be made to your home directory. {::/} To launch:

```
{::if resource.name != Weber}
$ windows  -i $RCAC_SCRATCH/windows.qcow2
{::else}
$ /depot/windows/weberwin.sh
{::/}
```

{::if resource.name != Weber}

### Command line options:

```
-i <path to qcow image file> (For example, $RCAC_SCRATCH/windows-2k16.qcow2)
-m <RAM>G (For example, 32G)
-c <cores> (For example, 20)
-s <smbpath> (UNIX Path to map as a drive, for example, $RCAC_SCRATCH)
-b  (If present, launches VM in background. Use VNC to connect to Windows.)
```

To launch a virtual machine with 32GB of RAM, 20 cores, and a network mapping to your home directory:

```
$ windows -i /path/to/image.qcow2  -m 32G -c 20 -s $HOME
```

To launch a virtual machine with 16GB of RAM, 10 cores, and a network mapping to your Data Depot space:

```
$ windows -i /path/to/image.qcow2  -m 16G -c 10 -s /depot/mylab
```

{::/} {::if resource.batchsystem == pbs}

To launch a background virtual machine with 16GB of RAM, 10 cores, and a network mapping to your cluster scratch, connecting via VNC:

```
$ windows -i /path/to/image.qcow2  -m 16G -c 10 -s $RCAC_SCRATCH -b
$ vncviewer `hostname`:1
```

You can use VNC to connect to this background virtual machine from the cluster node assigned by PBS, or from the login nodes.

{::/}

{::if resource.name != Weber} The Windows 2016 server desktop will open, and automatically log in as an administrator, so that you can install any software into the Windows virtual machine that your research requires. Changes to the image will be stored in the file specified with the `-i` option. {::else} The Windows desktop will open, and automatically log in as a temporary user. No changes to the VM will be preserved. {::/}