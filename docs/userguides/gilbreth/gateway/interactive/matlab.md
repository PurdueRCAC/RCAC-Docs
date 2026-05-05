---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# MATLAB

The MATLAB app will launch a MATLAB session on a compute node and allow you to connect directly to it in a web browser.

To launch a MATLAB session on a compute node, select the MATLAB app. From the submit form, select from the available options - the version of MATLAB you are interested in running, the queue to which you wish to submit, and the number of wallclock hours you wish to have job running. There is also a checkbox that enable a notification to your email when the job starts.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Launch noVNC in New Tab" button. The session will be terminated after the wallclock hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.

**NOTE:** There are known issues with running Matlab in this way and resizing your web browser. Graphical corruption may occur if you resize the browser. Fixes for this are being investigated.