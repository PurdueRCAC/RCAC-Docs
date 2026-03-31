---
tags:
  - Anvil
  - Help
authors:
  - dane
draft: true
---

 <p style="font-size: 1.75em; font-weight: bold;">Anvil Resources</p>

!!! info "Anvil Resources"

    **[ACCESS Support Hub](https://support.access-ci.org/)**
    ACCESS-specific support if you do not see your question/issue here.

    **[ACCESS Ticket Portal](https://support.access-ci.org/help-ticket)**
    Submit a help ticket if you cannot find an answer to your question.

    **[Anvil Support Hour](https://purdue.ca1.qualtrics.com/jfe/form/SV_0c7EMtiyOWjuG0K)**
    Meet with our support staff for a 20-minute help session.

    **[NAIRR Ticket Portal](https://nairrpilot.org/open-support-request)**
    For NAIRR users to submit support tickets.

    **[Anvil Publication](https://dl.acm.org/doi/10.1145/3491418.3530766)** Original Anvil publication from 2022 by Song et. al.

<hr style="border: 3px solid">

<span style="font-size: 1.75em; font-weight: bold;">Frequently Asked Questions</span>

## **Common Issues**

!!! tip "Tip"
    If you are having trouble accessing the system, make sure to check if maintenance is happening ([Anvil News](https://www.rcac.purdue.edu/news))

### File or data quota limit reached

Try compressing your files (zipping, tarring, etc). You should also go through your data to determine what can be deleted or transferred to your own external device.

If necessary, we can provide file count or total storage quota increases with justification. If you need this, please create a ticket with [Anvil Support](https://support.access-ci.org/help-ticket)

### I cannot see my PROJECT directory

If you are new, try waiting for 1 day after you receive notice of getting your allocation. If you still cannot see your $PROJECT directory, contact your PI and ensure they added you to the project. Once you get an Anvil account, the PI must add all scientists to the project themselves.

### My password is not working to login to Anvil

On the terminal, Anvil does not support password-based login. You must use a SSH key or a multi-factor authentication method. All usernames start with `x-`, which is different from your ACCESS username. Ensure you are using the correct username and have an SSH key setup.

### What are reasonable wait times?

Different queues and partitions may experience variable waittimes. This is most often due to large numbers of jobs in the wait queue and the cluster getting high-use. You can use the command `showpartitions` to see the current usage of all the partitions.

### My job is Squeued but won't run

- Ensure your resources are below the limit for your account
- Ensure you have enough SUs for your job
- Check the maintenance schedule
  - If maintenance is currently happening, jobs may be paused until it is completed
  - If you have a job requiring 24 hours of time and maintenance is scheduled for any time under 24 hours, your job will not start. This is to ensure your job doesn't get started and then fails during maintenance. Once the maintenance window is closed, your job will be queued as normal.

### I cannot find the module I need on Anvil

You can search all modules using `$ module spider`. Some modules require you to first load in a module. For example:
- `$ module load biocontainers` - once you load this in, you will have access to more modules when you type `$ module spider`
- `$ module load modtree/gpu` - this will allow you to see all GPU-compatable modules
- `$ module load modtree/cpu` - this will allow you to see all CPU-compatable modules (this is loaded in by default at login)

### Common Open OnDemand Errors

* Error -- failed to map user (\<username\>@access-ci.org)

### How to cite Anvil

To acknowledge the use of Anvil for papers, presentations, or other publications, please use the following citation:

* X. Carol Song, Preston Smith, Rajesh Kalyanam, Xiao Zhu, Eric Adams, Kevin Colby, Patrick Finnegan, Erik Gough, Elizabett Hillery, Rick Irvine, Amiya Maji, and Jason St. John. 2022. Anvil - System Architecture and Experiences from Deployment and Early User Operations. In Practice and Experience in Advanced Research Computing (PEARC '22). Association for Computing Machinery, New York, NY, USA, Article 23, 1–9. https://doi.org/10.1145/3491418.3530766

<hr style="border: 3px solid">

## **AI- / GPU-Specific FAQs**

### Placeholder 1

Placeholder answer 1