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

Mac OS X does not provide any way to access the ${resource.name} snapshots directly. To access the snapshots there are two options: browse the snapshots by hand through a network drive mount or use an automated command-line based tool.

{::if resource.type == storage}

To browse the snapshots by hand, follow the directions outlined in the [Manual Browsing](/knowledge/${resource.dir}/recover/manual) section.

To use the automated command-line tool, log into a compute cluster or into the host `${resource.hostname}.rcac.purdue.edu` (which is available to all ${resource.name} users) and use the [flost](/knowledge/${resource.dir}/recover/flost) tool. On Mac OS X you can use the built-in SSH terminal application to connect.

{::else}

To browse the snapshots by hand, follow the directions outlined in the [Manual Browsing](/knowledge/${resource.dir}/storage/recover/manual) section.

To use the automated command-line tool, log into a compute cluster or into the host `${resource.hostname}.rcac.purdue.edu` (which is available to all ${resource.name} users) and use the [flost](/knowledge/${resource.dir}/storage/recover/flost) tool. On Mac OS X you can use the built-in SSH terminal application to connect.

{::/}

* Open the Applications folder from Finder.
* Navigate to the Utilities folder.
* Double click the Terminal application to open it.
* Type the following command when the terminal opens.

  ```
  $ ssh ${user.username}@${resource.hostname}.rcac.purdue.edu
  ```

  Replace `${user.username}` with your Purdue career account username and provide your password when prompted.

{::if resource.type == storage}

Once logged in use the [flost](/knowledge/${resource.dir}/recover/flost) tool as described above. The tool will guide you through the process and show you the commands necessary to retrieve your lost file.

{::else}

Once logged in use the [flost](/knowledge/${resource.dir}/storage/recover/flost) tool as described above. The tool will guide you through the process and show you the commands necessary to retrieve your lost file.

{::/}