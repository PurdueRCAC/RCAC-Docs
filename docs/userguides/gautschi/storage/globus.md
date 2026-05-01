---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

Globus, previously known as Globus Online, is a powerful and easy to use file transfer service for transferring files virtually anywhere. It works within RCAC's various research storage systems; it connects between RCAC and remote research sites running Globus; and it connects research systems to personal systems. You may use Globus to connect to your home, scratch, and Fortress storage directories. Since Globus is web-based, it works on any operating system that is connected to the internet. The Globus Personal client is available on Windows, Linux, and Mac OS X. It is primarily used as a graphical means of transfer but it can also be used over the command line.

## Globus Web

- Navigate to [https://transfer.rcac.purdue.edu](https://transfer.rcac.purdue.edu)
- Click "Proceed" to log in with your Purdue Career Account.
- On your first login it will ask to make a connection to a Globus account. Accept the conditions.
- Now you are at the main screen. Click "File Transfer" which will bring you to a two-panel interface (if you only see one panel, you can use selector in the top-right corner to switch the view).
- You will need to select one collection and file path on one side as the source, and the second collection on the other as the destination. This can be one of several Purdue endpoints, or another University, or even your personal computer (see Personal Client section below).

The RCAC collections are as follows. A search for "Purdue" will give you several suggested results you can choose from, or you can give a more specific search.

- **Home directory and Scratch storage**: "Gautschi Cluster Collection", however, you can start typing "gautschi" and it will suggest appropriate matches.
- **Research Data Depot**: "Purdue Research Computing - Data Depot", a search for "Depot" should provide appropriate matches to choose from.
- **Fortress**: "Purdue Fortress HPSS Archive", a search for "Fortress" should provide appropriate matches to choose from.

From here, select a file or folder in either side of the two-pane window, and then use the arrows in the top-middle of the interface to instruct Globus to move files from one side to the other. You can transfer files in either direction. You will receive an email once the transfer is completed.

## Globus Personal Client Setup

Globus Connect Personal is a small software tool you can install to make your own computer a Globus endpoint on its own. It is useful if you need to transfer files via Globus to and from your computer directly.

- On the "Collections" page from earlier, click "Get Globus Connect Personal" or download a version for your operating system it from here: [Globus Connect Personal](https://www.globus.org/globus-connect-personal)
- Name this particular personal system and follow the setup prompts to create your Globus Connect Personal endpoint.
- Your personal system is now available as a collection within the Globus transfer interface.

## Globus Command-line

Globus supports command line interface, allowing advanced automation of your transfers.

To use the recommended standalone Globus CLI application (the ```globus``` command):

- First time use: issue the ```globus login``` command and follow instructions for initial login.
- Commands for interfacing with the CLI can be found via [Using the Command Line Interface](https://docs.globus.org/cli/), as well as the [Globus CLI Examples](https://docs.globus.org/cli/examples/) pages.

## Sharing Data with External Collaborators

Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions. See the Globus documentation on how to share data:

[https://docs.globus.org/how-to/share-files/](https://docs.globus.org/how-to/share-files/)

For links to more information, please see [Globus Support](https://support.globus.org/home) page and [RCAC Globus presentation](https://www.rcac.purdue.edu/training/globus).

[**Back to the Storage section**](../storage.md)
