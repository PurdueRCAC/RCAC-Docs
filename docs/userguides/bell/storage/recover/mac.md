---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Mac OS X

Mac OS X does not provide any way to access the Bell snapshots directly. To access the snapshots there are two options: browse the snapshots by hand through a network drive mount or use an automated command-line based tool.


To browse the snapshots by hand, follow the directions outlined in the [Manual Browsing](manual.md) section.

To use the automated command-line tool, log into a compute cluster or into the host `bell.rcac.purdue.edu` (which is available to all Bell users) and use the [flost](flost.md) tool. On Mac OS X you can use the built-in SSH terminal application to connect.


* Open the Applications folder from Finder.
* Navigate to the Utilities folder.
* Double click the Terminal application to open it.
* Type the following command when the terminal opens.

    ```
    $ ssh myusername@bell.rcac.purdue.edu
    ```

  Replace `myusername` with your Purdue career account username and provide your password when prompted.


Once logged in use the [flost](flost.md) tool as described above. The tool will guide you through the process and show you the commands necessary to retrieve your lost file.

