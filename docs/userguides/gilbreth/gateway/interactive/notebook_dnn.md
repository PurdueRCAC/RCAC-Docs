---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# Jupyter Notebook - Deep Neural Networks Demo (GPU)

The Notebook app will launch a Notebook session on a compute node and allow you to connect directly to it in a web browser. It can be used to run GPU applications such as Tensorflow and Keras. Below is a demo of this to get you started.

* [Download the demo notebook](/files/knowledge/gateway/notebooks/dnn.ipynb) to your computer.
* Launch a Notebook session from the Gateway Interactive Apps menu:

![Open OnDemand launch page for Jupyter Notebooks](knowledge/gateway/Gilbreth-ood-jupyter.png)


"Jupyter Notebook" can be found under "GUIs" in the "Interactive Apps" menu. This takes you to the launch page, with options for selecting the 'Queue', 'Number of hours', and email notifications.

* Select the queue to which you wish to submit and enter the number of wallclock hours you require. Your notebook will be terminated after this number of hours elapses.
* Click Launch.
* Wait for your interactive session to change to Running state. This may take some time depending on how busy the queue and system is.
* Click on 'Connect to Jupyter' once the button appears.

![Active Jupiter Notebook session in Open OnDemand](knowledge/gateway/dnn2.png)


When ready, the session will show a "Running state" with details about the session such as "Host", "Created at", "Time Remaining", and "Session ID". The "Connect to Jupyter" button will also become available.

* Once in Jupyter, select 'Upload' in the upper right corner. You may wish to create a folder or change into a different directory to put the demo notebook first.

![Upload button in a Jupyter Notebook](knowledge/gateway/dnn3.png)


The 'Upload' button in a Notebook can be found in the upper right corner next to a directory selector and refresh button.

* Select the demo notebook file you downloaded earlier. Click the blue Upload button to complete the upload. Then click the `dnn.ipynb` item from the file list to launch the notebook.
* You should now have the notebook loaded and you should be able to re-execute the code cells, or modify them to your needs.

![A running Jupyter Notebook](knowledge/gateway/dnn4.png)


A running Notebook will have a main menu and toolbar buttons across the top with individually marked code and text cells below.