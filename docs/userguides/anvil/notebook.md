---
tags:
  - Anvil
authors:
  - dane
  - Ibrahem
draft: true
---

## Anvil Notebook Classroom Resource

### What is the Anvil Notebook Service?
The **Anvil Notebook Service** is a JupyterHub instance tightly integrated with the Anvil ACCESS resource, providing a web-based environment for interactive computing, data analytics, and machine learning using Python, R, Julia, and widely used frameworks such as TensorFlow and PyTorch. Beyond its research value, the service has proven to be especially impactful in education: it supports classroom-scale interactive computing and has been used by more than **1,000 students** in Purdue’s **Data Mine** program. This broad adoption highlights the platform’s scalability, reliability, and maturity as one of the most tested and classroom-ready HPC-based web applications available to educators. For an example of how the service is used in practice, see [Data Mine Class and Projects :octicons-link-external-16:](https://the-examples-book.com/projects/).

### Key Features

- **Browser-based access:** No SSH is required. Sessions run on Anvil and display directly in the user's browser.
- **Interactive applications:** Launch interactive tools such as Jupyter Notebook and RStudio, and access GitHub repositories.
- **Resource selection:** The allocations drop-down menu reflects the user's available allocations and supports dynamic resource selection based on vRAM and CPU cores. The service provides access to 3rd-generation AMD EPYC CPUs and NVIDIA H100 GPUs.
- **Integrated storage:** Access home, scratch, and project file systems directly. Available datasets from multiple research domains can also be accessed, reducing the need for separate hosting or data transfers.

### Who can use this service?

Any ACCESS researcher with an allocation on the Anvil resource can use the Anvil Notebook Service

### How do I access the service?

* Go to the [Anvil Notebook login page :octicons-link-external-16:](https://notebook.anvilcloud.rcac.purdue.edu/hub/login?next=%2Fhub%2F).
* Log in with your ACCESS credentials.
* Choose the Anvil Notebook Server, select your allocation, and click **Start**.
* Wait for the server to start and for the notebook session to become active.
* To shut down the server, go to **File → Hub Control Panel → Stop My Server**.


### Video Walkthrough
<video controls width="100%">
  <source src="https://www.rcac.purdue.edu/files/Anvil%20Notebook%20Service-20260114_003328-Meeting%20Recording.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

### Questions?

Please file an [ACCESS help ticket :octicons-link-external-16:](https://support.access-ci.org/help-ticket)


## AnvilGPT integration

* Launch the Anvil Notebook
* Copy your API key from AnvilGPT
* Click the Jupyternaut extension
* Click Settings
* Select your completion model (Use llama3.3 for the best results)
* Put your Anvil GPT API key under "API Keys"

### Video Walkthrough
<video controls width="100%">
  <source src="https://www.rcac.purdue.edu/files/AnvilGPTAPIKey.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## Pegasus on Anvil

Documentation provided by
[Pegasus](http://access-ci.atlassian.net/wiki/spaces/ACCESSdocumentation/pages/564887553/Pegasus+Workflows) 
