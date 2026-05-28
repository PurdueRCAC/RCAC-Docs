---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

# Interactive Apps

There are several interactive apps available through Gateway that can be accessed through the Interactive Apps dropdown menu. These apps are provided with a basic node and software configuration as a 'quick-launch' option to get your work up and running quickly. For simplicity, minimal options are provided - these apps are not intended for complex configuration/customization scenarios.

After you a submit an interactive app to the queue, Gateway will track and manage the session. Once it starts, you may connect and disconnect from the session in your browser, leaving the job running while you log out of your browser.

## Compute Node Desktop

The Compute Node Desktop app will launch a graphical desktop session on a compute node. This is similar to using [Thinlinc](../accounts.md/#thinlinc), however, this gives you a desktop directly on a compute node instead on a front-end. This app is useful if you have a custom application or application not directly available as an interactive app you would like to run inside Gateway.

To launch a desktop session on a compute node, select the {{ resource }} Compute Desktop app. From the submit form, select from the available options - the queue to which you wish to submit and the number of wallclock hours you wish to have job running. There is also a checkbox that enable a notification to your email when the job starts.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Launch noVNC in New Tab" button. The session will be terminated after the wallclock hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.

## MATLAB

The MATLAB app will launch a MATLAB session on a compute node and allow you to connect directly to it in a web browser.

To launch a MATLAB session on a compute node, select the MATLAB app. From the submit form, select from the available options - the version of MATLAB you are interested in running, the queue to which you wish to submit, and the number of wallclock hours you wish to have job running. There is also a checkbox that enable a notification to your email when the job starts.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Launch noVNC in New Tab" button. The session will be terminated after the wallclock hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.

!!! note
    There are known issues with running Matlab in this way and resizing your web browser. Graphical corruption may occur if you resize the browser. Fixes for this are being investigated.

## Jupyter Notebook

The Notebook app will launch a Notebook session on a compute node and allow you to connect directly to it in a web browser.

To launch a Notebook session on a compute node, select the Notebook app. From the submit form, select from the available options:

1. **Queue:** This is a dropdown menu from which you can select a queue from all of the queues to which you have permission to submit.
2. **Walltime:** This is a field which expects a number and represents how many hours you want to keep the session running. Note that this value should not exceed the maximum value given next to the selected queue name from the queue dropdown menu.
3. **Number of Cores/GPUs:** This is a field which expects a number and represents the number of your resources your session is requesting. Note that the amount of memory allocated for your session is proportional to the number of cores or GPUs that you request for your job, so if your session is running out of memory, consider increasing this value.
4. **Use Jupyter Lab:** This is a checkbox which, when checked, will run Jupyter Lab instead of Jupyter Notebook. Both of these applications are interfaces to Jupyter, and you can launch Jupyter notebooks from within Jupyter Lab. Jupyter Notebook is more "barebones" while Jupyter Lab has additional features such as the ability to interact with additional file types.
5. **E-mail Notice:** This is a checkbox which, when checked, will send you an e-mail notification to your Purdue e-mail that your session is ready when the scheduler has found resources to dedicate to your session.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Connect to Jupyter" button. Once connected, you can create new notebooks, selecting the currently available Anaconda versions available as modules, and any personally created Notebook kernels.

Often times you may want to use one of your existing Anaconda environments within your Jupyter session to use libraries specific to your workflow. In order to do so, you must ensure that the Anaconda environment you want to use contains the Python packages "IPyKernel" and "IPython" which are packages that are required by Jupyter. When you create a Jupyter session, Open OnDemand will check through your existing Anaconda environments and create a Jupyter kernel for any Anaconda environment that contains these two packages, and you will be able to select to use that kernel from within the application.

The session will be terminated after the number of hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.

## RStudio Server

The RStudio app will launch a RStudio session on a compute node and allow you to connect directly to it in a web browser.

To launch a RStudio session on a compute node, select the RStudio app. From the submit form, select from the available options - the queue to which you wish to submit, and the number of wallclock hours you wish to have job running. There is also a checkbox that enable a notification to your email when the job starts.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Connect to RStudio Server" button. The session will be terminated after the wallclock hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.

## Windows Desktop

The Windows Desktop app will launch a Windows desktop session on a compute node. This is similar to using the Windows menu launcher through [Thinlinc](../accounts.md/#thinlinc), however, this gives you a Windows desktop directly on a compute node instead on a front-end.

To launch a Windows session on a compute node, select the Windows Desktop app. From the submit form, select from the available options - choose from the basic Windows configuration or the GIS configured image, the queue to which you wish to submit, and the number of wallclock hours you wish to have job running. There is also a checkbox that enable a notification to your email when the job starts.

This will create a file in your scratch space called `windows-base.qcow2` or `windows-gis.qcow2`. If the file already exists, the existing image will be restarted. You can delete or rename the image at any time through the [Files App](../gateway/files.md) to generate a fresh image. You can only have one instance of the image running at a time or corruption will occur. There are lock files to prevent this, but be mindful of this restriction. It is also recommended you make periodic backups of the image if you are making any modifications to it.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Launch noVNC in New Tab" button. The session will be terminated after the wallclock hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.

[**Return to the Gateway / OnDemand section**](../gateway.md)
