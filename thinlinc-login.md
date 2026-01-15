---
date:
  created: 2026-01-14
draft: true
---

# Logging in to the community clusters via ThinLinc
<!-- more -->
!!! warning
    Placeholder for moving thinlinc local client install/login info from the accounts.md page on the cluster userguides.

RCAC provides Cendio's ThinLinc as an alternative to running an X11 server directly on your computer. It allows you to run graphical applications or graphical interactive jobs directly on gautschi through a persistent remote graphical desktop session.

ThinLinc is a service that allows you to connect to a persistent remote graphical desktop session. This service works very well over a high latency, low bandwidth, or off-campus connection compared to running an X11 server locally. It is also very helpful for Windows users who do not have an easy to use local X11 server, as little to no set up is required on your computer.

There are two ways in which to use ThinLinc: preferably through the native client or through a web browser.

Installing the ThinLinc native client¶
The native ThinLinc client will offer the best experience especially over off-campus connections and is the recommended method for using ThinLinc. It is compatible with Windows, Mac OS X, and Linux.

Download the ThinLinc client from the ThinLinc website.
Start the ThinLinc client on your computer.
In the client's login window, use desktop.gautschi.rcac.purdue.edu as the Server. Use your Purdue Career Account username and password, but append ",push" to your password.
Click the Connect button.
Your Purdue Login Duo will receive a notification to approve your login.
Continue to following section on connecting to gautschi from ThinLinc.
Using ThinLinc through your web browser¶
The ThinLinc service can be accessed from your web browser as a convenience to installing the native client. This option works with no set up and is a good option for those on computers where you do not have privileges to install software. All that is required is an up-to-date web browser. Older versions of Internet Explorer may not work.

Open a web browser and navigate to desktop.gautschi.rcac.purdue.edu..
Log in with your Purdue Career Account username and password, but append ",push" to your password.
You may safely proceed past any warning messages from your browser.
Your Purdue Login Duo will receive a notification to approve your login.
Continue to the following section on connecting to gautschi from ThinLinc.
Connecting to gautschi from ThinLinc¶
Once logged in, you will be presented with a remote Linux desktop running directly on a cluster front-end.
Open the terminal application on the remote desktop.
Once logged in to the gautschi head node, you may use graphical editors, debuggers, software like Matlab, or run graphical interactive jobs. For example, to test the X forwarding connection issue the following command to launch the graphical editor gedit:

$ gedit
This session will remain persistent even if you disconnect from the session. Any interactive jobs or applications you left running will continue running even if you are not connected to the session.
Tips for using ThinLinc native client¶
To exit a full screen ThinLinc session press the F8 key on your keyboard (fn + F8 key for Mac users) and click to disconnect or exit full screen.
Full screen mode can be disabled when connecting to a session by clicking the Options button and disabling full screen mode from the Screen tab.
Configure ThinLinc to use SSH Keys¶
The web client does NOT support public-key authentication.
ThinLinc native client supports the use of an SSH key pair. For help generating and uploading keys to the cluster, see SSH Keys section in our user guide for details.
To set up SSH key authentication on the ThinLinc client:

Open the Options panel, and select Public key as your authentication method on the Security tab.

ThinLinc Options window

The "Options..." button in the ThinLinc Client can be found towards the bottom left, above the "Connect" button.

In the options dialog, switch to the "Security" tab and select the "Public key" radio button:

ThinLinc's Security tab

The "Security" tab found in the options dialog, will be the last of available tabs. The "Public key" option can be found in the "Authentication method" options group.

Click OK to return to the ThinLinc Client login window. You should now see a Key field in place of the Password field.

In the Key field, type the path to your locally stored private key or click the ... button to locate and select the key on your local system. Note: If PuTTY is used to generate the SSH Key pairs, please choose the private key in the openssh format.

Thinlinc login with key

The ThinLinc Client login window will now display key field instead of a password field.
