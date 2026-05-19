---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Jupyter Notebook

The Notebook app will launch a Notebook session on a compute node and allow you to connect directly to it in a web browser.

To launch a Notebook session on a compute node, select the Notebook app. From the submit form, select from the available options:

1. **Queue:**This is a dropdown menu from which you can select a queue from all of the queues to which you have permission to submit.
2. **Walltime:**This is a field which expects a number and represents how many hours you want to keep the session running. Note that this value should not exceed the maximum value given next to the selected queue name from the queue dropdown menu.
3. **Number of Cores/GPUs:** This is a field which expects a number and represents the number of your resources your session is requesting. Note that the amount of memory allocated for your session is proportional to the number of cores or GPUs that you request for your job, so if your session is running out of memory, consider increasing this value.
4. **Use Jupyter Lab:**This is a checkbox which, when checked, will run Jupyter Lab instead of Jupyter Notebook. Both of these applications are interfaces to Jupyter, and you can launch Jupyter notebooks from within Jupyter Lab. Jupyter Notebook is more "barebones" while Jupyter Lab has additional features such as the ability to interact with additional file types.
5. **E-mail Notice:**This is a checkbox which, when checked, will send you an e-mail notification to your Purdue e-mail that your session is ready when the scheduler has found resources to dedicate to your session.

After the interactive job is submitted you will be taken to your list of active interactive app sessions. You can monitor the status of the job from here until it starts, or if you enabled the email notification, watch your Purdue email for the notification the job has started.

Once it is indicated the job has started you can connect to the desktop with the "Connect to Jupyter" button. Once connected, you can create new notebooks, selecting the currently available Anaconda versions available as modules, and any personally created Notebook kernels.

Often times you may want to use one of your existing Anaconda environments within your Jupyter session to use libraries specific to your workflow. In order to do so, you must ensure that the Anaconda environment you want to use contains the Python packages "IPyKernel" and "IPython" which are packages that are required by Jupyter. When you create a Jupyter session, Open OnDemand will check through your existing Anaconda environments and create a Jupyter kernel for any Anaconda environment that contains these two packages, and you will be able to select to use that kernel from within the application.

The session will be terminated after the number of hours you specified have elapsed or you terminate the session early with the "Delete" button from the list of sessions. Deleting the session when you are finished will free up queue resources for your lab mates and other users on the system.
