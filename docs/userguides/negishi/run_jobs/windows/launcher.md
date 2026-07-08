---
tags:
  - Negishi
authors:
  - hkashgar
resource: Negishi
search:
  boost: 2
---

# Menu Launcher

Windows VMs can be easily launched through the [thinlinc](../../../accounts/#thinlinc) remote desktop environment.

* Log in via [thinlinc](../../../accounts/#thinlinc).
* Click on Applications menu in the upper left corner.
* Look under the Cluster Software menu.
* The "Windows 10" launcher will launch a VM directly on the front-end.
* Follow the dialogs to set up your VM.

![Thinlinc Applications list](../../../../../assets/images/userguides/examples/windows.png)

*Find Windows 10 under the 'Cluster Software' option in the list of Applications.*

The dialog menus will walk you through setting up and loading your VM.

* You can choose to create a new image or load a saved image.
* New VMs should be saved on Scratch or Research Data Depot as they are too large for Home Directories.
* If you are using scratch, remember that **scratch spaces are temporary**, and be sure to safely back up your disk image somewhere permanent, such as Research Data Depot or Fortress.

You will also be prompted to select a storage space to mount on your image (Home, Scratch, or Data Depot). You can only choose one to be mounted. It will appear on a shortcut on the desktop once the VM loads.

## Notes

Using the menu launcher will launch automatically select reasonable CPU and memory values. If you wish to choose other options or work Windows VMs into scripted workflows see the section on [using the command line](cmd.md).



[**Back to the Running Jobs section**](../../run_jobs/index.md)
