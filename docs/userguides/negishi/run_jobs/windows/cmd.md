---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Command line

If you wish to work with Windows VMs on the command line or work into scripted workflows you can interact directly with the Windows system:

Copy a Windows 2016 Server VM image to your storage. Scratch or Research Data Depot are good locations to save a VM image. If you are using scratch, remember that **scratch spaces are temporary**, and be sure to safely back up your disk image somewhere permanent, such as Research Data Depot or Fortress. To copy a basic image:

```
$ cp /apps/external/apps/windows/images/latest.qcow2  $RCAC_SCRATCH/windows.qcow2
```

To copy a GIS image:

```
$ cp /depot/itap/windows/gis/2k16.qcow2 $RCAC_SCRATCH/windows.qcow2
```

To launch a virtual machine in a batch job, use the "windows" script, specifying the path to your Windows virtual machine image. With no other command-line arguments, the `windows` script will autodetect a number cores and memory for the Windows VM. A Windows network connection will be made to your home directory. To launch:

```
$ windows  -i $RCAC_SCRATCH/windows.qcow2
```

## Command line options:

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
The Windows 2016 server desktop will open, and automatically log in as an administrator, so that you can install any software into the Windows virtual machine that your research requires. Changes to the image will be stored in the file specified with the `-i` option.
 

[**Back to the Running Jobs section**](../../run_jobs/index.md)
