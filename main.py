# main.py

def define_env(env):
    @env.macro
    def login_snippet(host,cluster):
        return f"""
**Logging In**

{cluster} accepts standard SSH connections with public keys-based authentication to {host} using your {cluster} username:

**SSH Login**
```bash
$ ssh -l my-username {host}
```
"""

    @env.macro
    def account_snippet(host,cluster):
        return f"""
**Get an account on {cluster} cluster**

Contact RCAC help to get your account set on `{host}`.
"""
    @env.macro
    def ssh_keys_snippet(resource):
        return f"""
### General overview

To connect to {resource} using SSH keys, you must follow three high-level steps:

1. Generate a key pair consisting of a private and a public key on your local machine.
2. Copy the public key to the cluster and append it to `$HOME/.ssh/authorized_keys` file in your account.
3. Test if you can ssh from your local computer to the cluster without using your Purdue password.

Detailed steps for different operating systems and specific SSH client softwares are give below.

### Mac and Linux:

1. Run `ssh-keygen` in a terminal on your local machine. You may supply a filename and a passphrase for protecting your private key, but it is not mandatory. To accept the default settings, press Enter without specifying a filename.

!!! note
    If you do not protect your private key with a passphrase, anyone with access to your computer could SSH to your account on {resource}.

2. By default, the key files will be stored in `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` on your local machine.

3. Copy the contents of the public key into `$HOME/.ssh/authorized_keys` on the cluster with the following command. When asked for a password, type your password followed by "`,push`". Your Purdue Duo client will receive a notification to approve the login.

   `ssh-copy-id -i ~/.ssh/id_rsa.pub username@{resource}.rcac.purdue.edu`

   Note: use your actual Purdue account user name.

   If your system does not have the `ssh-copy-id` command, use this instead:

   `cat ~/.ssh/id_rsa.pub | ssh username@{resource}.rcac.purdue.edu "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys"`

4. Test the new key by SSH-ing to the server. The login should now complete without asking for a password.

5. If the private key has a non-default name or location, you need to specify the key by

   `ssh -i my_private_key_name username@{resource}.rcac.purdue.edu`

### Windows:

Windows SSH Instructions

| Programs | Instructions |
| --- | --- |
| **MobaXterm** | Open a local terminal and follow Linux steps |
| **Git Bash** | Follow Linux steps |
| **Windows 10 PowerShell** | Follow Linux steps |
| **Windows 10 Subsystem for Linux** | Follow Linux steps |
| **PuTTY** | Follow steps below |

**PuTTY:**

1. Launch *PuTTYgen*, keep the default key type (RSA) and length (2048-bits) and click **Generate** button.

   ![PuTTYgen interface](/userguides/accounts/keygen1.png)


   The "Generate" button can be found under the "Actions" section of the PuTTY Key Generator interface.
2. Once the key pair is generated:

   Use the **Save public key** button to save the public key, e.g. `Documents\SSH_Keys\mylaptop_public_key.pub`

   Use the **Save private key** button to save the private key, e.g. `Documents\SSH_Keys\mylaptop_private_key.ppk`. When saving the private key, you can also choose a reminder comment, as well as an optional passphrase to protect your key, as shown in the image below. **Note**: If you do not protect your private key with a passphrase, anyone with access to your computer could SSH to your account on {resource}.

   ![PuTTY Key Generator form with the passphrase and comment fields highlighted](/userguides/accounts/keygen5.png)


   The PuTTY Key Generator form has inputs for the Key passphrase and optional reminder comment.

   From the menu of *PuTTYgen*, use the *"Conversion -> Export OpenSSH key"* tool to convert the private key into openssh format, e.g. `Documents\SSH_Keys\mylaptop_private_key.openssh` to be used later for Thinlinc.
3. Configure *PuTTY* to use key-based authentication:

   Launch *PuTTY* and navigate to *"Connection -> SSH ->Auth"* on the left panel, click **Browse** button under the *"Authentication parameters"* section and choose your private key, e.g. **mylaptop\_private\_key.ppk**

   ![PuTTY Auth panel](/userguides/accounts/keygen2.png)


   After clicking Connection -> SSH ->Auth panel, the "Browse" option can be found at the bottom of the resulting panel.

   Navigate back to *"Session"* on the left panel. Highlight *"Default Settings"* and click the "Save" button to ensure the change in place.
4. Connect to the cluster. When asked for a password, type your password followed by "`,push`". Your Purdue Duo client will receive a notification to approve the login. Copy the contents of public key from *PuTTYgen* as shown below and paste it into `$HOME/.ssh/authorized_keys`. Please double-check that your text editor did not wrap or fold the pasted value (it should be one very long line).

   ![PuTTY Key Generator form with the generated key highlighted](/userguides/accounts/keygen4.png)


   The "Public key" will look like a long string of random letters and numbers in a text box at the top of the window.
5. Test by connecting to the cluster. If successful, you will **not** be prompted for a password or receive a Duo notification. If you protected your private key with a passphrase in step 2, you **will** instead be prompted to enter your chosen passphrase when connecting.
"""
    
    @env.macro
    def ssh_x11_snippet(resource):
        return f"""
SSH supports tunneling of X11 (X-Windows). If you have an X11 server running on your local machine, you may use X11 applications on remote systems and have their graphical displays appear on your local machine. These X11 connections are tunneled and encrypted automatically by your SSH client.

### Installing an X11 Server

To use X11, you will need to have a local X11 server running on your personal machine. Both free and commercial X11 servers are available for various operating systems.

**Linux / Solaris / AIX / HP-UX / Unix:**

- An X11 server is at the core of all graphical sessions. If you are logged in to a graphical environment on these operating systems, you are already running an X11 server.
- [ThinLinc](/userguides/{resource}/accounts/#thinlinc) is an alternative to running an X11 server directly on your Linux computer. ThinLinc is a service that allows you to connect to a persistent remote graphical desktop session.

**Microsoft Windows:**

- [ThinLinc](/userguides/{resource}/accounts/#thinlinc) is an alternative to running an X11 server directly on your Windows computer. ThinLinc is a service that allows you to connect to a persistent remote graphical desktop session.
- [MobaXterm](https://mobaxterm.mobatek.net/download.html) is a small, easy to use, full-featured SSH client. It includes X11 support for remote displays, SFTP capabilities, and limited SSH authentication forwarding for keys.

**Mac OS X:**

- X11 is available as an optional install on the Mac OS X install disks prior to 10.7/Lion. Run the installer, select the X11 option, and follow the instructions. For 10.7+ please download [XQuartz](http://xquartz.macosforge.org/landing/).
- [ThinLinc](/userguides/{resource}/accounts/#thinlinc) is an alternative to running an X11 server directly on your Mac computer. ThinLinc is a service that allows you to connect to a persistent remote graphical desktop session.

### Enabling X11 Forwarding in your SSH Client

Once you are running an X11 server, you will need to enable X11 forwarding/tunneling in your SSH client:

- `ssh`: X11 tunneling should be enabled by default. To be certain it is enabled, you may use `ssh -Y`.
- MobaXterm: Select "New session" and "SSH." Under "Advanced SSH Settings" check the box for X11 Forwarding.

SSH will set the remote environment variable `$DISPLAY` to `"localhost:XX.YY"` when this is working correctly. If you had previously set your `$DISPLAY` environment variable to your local IP or hostname, you must remove any `set`/`export`/`setenv` of this variable from your login scripts. The environment variable `$DISPLAY` must be left as SSH sets it, which is to a random local port address. Setting `$DISPLAY` to an IP or hostname will not work.

"""

    @env.macro
    def thinlinc_snippet(resource):
        return f"""
RCAC provides [Cendio's *ThinLinc*](https://www.cendio.com/thinlinc/what-is-thinlinc) as an alternative to running an X11 server directly on your computer. It allows you to run graphical applications or graphical interactive jobs directly on {resource} through a persistent remote graphical desktop session.

ThinLinc is a service that allows you to connect to a persistent remote graphical desktop session. This service works very well over a high latency, low bandwidth, or off-campus connection compared to running an X11 server locally. It is also very helpful for Windows users who do not have an easy to use local X11 server, as little to no set up is required on your computer.

There are two ways in which to use ThinLinc: preferably through the native client or through a web browser.

### Installing the ThinLinc native client

The native ThinLinc client will offer the best experience especially over off-campus connections and is the recommended method for using ThinLinc. It is compatible with Windows, Mac OS X, and Linux.

* Download the ThinLinc client from the [ThinLinc website](https://www.cendio.com/thinlinc/download).
* Start the ThinLinc client on your computer.
* In the client's login window, use `desktop.{resource}.rcac.purdue.edu` as the Server. Use your Purdue Career Account username and password, but append "`,push`" to your password.
* Click the Connect button.
* Your Purdue Login Duo will receive a notification to approve your login.
* Continue to following section on connecting to {resource} from ThinLinc.

### Using ThinLinc through your web browser

The ThinLinc service can be accessed from your web browser as a convenience to installing the native client. This option works with no set up and is a good option for those on computers where you do not have privileges to install software. All that is required is an up-to-date web browser. Older versions of Internet Explorer may not work.

* Open a web browser and navigate to [`desktop.{resource}.rcac.purdue.edu`.](https://desktop.{resource}.rcac.purdue.edu).
* Log in with your Purdue Career Account username and password, but append "`,push`" to your password.
* You may safely proceed past any warning messages from your browser.
* Your Purdue Login Duo will receive a notification to approve your login.
* Continue to the following section on connecting to {resource} from ThinLinc.

### Connecting to {resource} from ThinLinc

* Once logged in, you will be presented with a remote Linux desktop running directly on a cluster front-end.
* Open the terminal application on the remote desktop.
* Once logged in to the {resource} head node, you may use graphical editors, debuggers, software like Matlab, or run graphical interactive jobs. For example, to test the X forwarding connection issue the following command to launch the graphical editor `gedit`:

  ```
  $ gedit
  ```

* This session will remain persistent even if you disconnect from the session. Any interactive jobs or applications you left running will continue running even if you are not connected to the session.

### Tips for using ThinLinc native client

* To exit a full screen ThinLinc session press the `F8` key on your keyboard (`fn + F8 key` for Mac users) and click to disconnect or exit full screen.
* Full screen mode can be disabled when connecting to a session by clicking the Options button and disabling full screen mode from the Screen tab.

### Configure ThinLinc to use SSH Keys

* The web client does **NOT** support public-key authentication.
* ThinLinc native client supports the use of an SSH key pair. For help generating and uploading keys to the cluster, see [SSH Keys](/userguides/{resource}/accounts/#sshkeys) section in our user guide for details.

  To set up SSH key authentication on the ThinLinc client:

  * Open the Options panel, and select Public key as your authentication method on the Security tab.

    ![ThinLinc Options window](/userguides/accounts/thinlinc1.png)


    The "Options..." button in the ThinLinc Client can be found towards the bottom left, above the "Connect" button.
  
  * In the options dialog, switch to the "Security" tab and select the "Public key" radio button:

    ![ThinLinc's Security tab](/userguides/accounts/thinlinc2.png)

    The "Security" tab found in the options dialog, will be the last of available tabs. The "Public key" option can be found in the "Authentication method" options group.

  * Click OK to return to the ThinLinc Client login window. You should now see a Key field in place of the Password field.
  * In the Key field, type the path to your locally stored private key or click the `...` button to locate and select the key on your local system. **Note:** If *PuTTY* is used to generate the SSH Key pairs, please choose the private key in the openssh format.

    ![Thinlinc login with key](/userguides/accounts/thinlinc3.png)

    The ThinLinc Client login window will now display key field instead of a password field.

"""
    
    @env.macro
    def slurm_general_overview(host, hostname):
        return f"""
## Overview / Slurm Basics

{hostname.title()} uses the [Slurm Workload Manager](https://slurm.schedmd.com/) for job scheduling and management. With Slurm, a user requests resources and submits a job to a queue. The system takes jobs from queues, allocates the necessary compute nodes, and executes them.

!!! note "SSHing into {hostname.title()} lands on login node"
    Users will typically SSH to {hostname.title()} (`<username>@{host}`) but note this lands you on a **login node**. Slurm should always be used to submit work as a job rather than running jobs directly on a login node.

On { hostname.title() }, you do not run programs directly on the system. Instead, you submit jobs to a queue. A queue is simply a waiting line for computing resources. When you submit a job, you tell the scheduler:

- How many resources you need (cores, GPUs, memory, etc.)
- How long the job will run
- What type of hardware you need

!!! warning "Running jobs on login node is against {hostname.title()} policy"
    All users share the login nodes, and running anything but the smallest test job will negatively impact everyone's ability to use {hostname.title()}.

The scheduler places your job in the appropriate queue and runs it when the requested resources become available. Different queues exist because different types of jobs have different needs. For example, some jobs need GPUs, some need large memory, and some only run for a short time. Separating these helps the system run efficiently and fairly for everyone.
"""
    
    @env.macro
    def slurm_general_jobs(host, hostname):
        return f"""

### Job Submission Script

To submit work to a Slurm queue, you must first create a job submission file. This job submission file is essentially a simple shell script. It will set any required environment variables, load any necessary modules, create or modify files and directories, and run any applications that you need:

```bash
#!/bin/sh -l

#SBATCH -A <account>
#SBATCH -p <partition>
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=1G
#SBATCH --job-name example-job
#SBATCH -t 01:30:00  # 1 hour 30 minutes

# Loads Matlab and sets the application up
module load matlab

# Change to the directory from which you originally submitted this job.
cd $SLURM_SUBMIT_DIR

# Runs a Matlab script named 'myscript'
matlab -nodisplay -singleCompThread -r myscript
```

!!! warning "Mandatory SBATCH fields"
    You must at a minimum specify:

    1. Account (-A or --account): this is your allocation account. Run `$ mybalance` to see allocation accounts.
    2. Partition (-p). Run `$ showpartitions` to view all available partitions.

Once your script is prepared, you are ready to submit your job.

The standard Slurm environment variables that can be used in the job submission file are listed in the table below:

**Job Script Environment Variables**

| Name | Description |
| --- | --- |
| SLURM\_SUBMIT\_DIR | Absolute path of the current working directory when you submitted this job |
| SLURM\_JOBID | Job ID number assigned to this job by the batch system |
| SLURM\_JOB\_NAME | Job name supplied by the user |
| SLURM\_JOB\_NODELIST | Names of nodes assigned to this job |
| SLURM\_SUBMIT\_HOST | Hostname of the system where you submitted this job |
| SLURM\_JOB\_PARTITION | Name of the original queue to which you submitted this job |

### Submitting a Job

Once you have a job submission file, you may submit this script to SLURM using the `$ sbatch` command. Slurm will find, or wait for, available resources matching your request and run your job there.

To submit your job to one compute node with one task:

```shell-session

$ sbatch --nodes=1 --ntasks=1 -t 1:30:00 myjobsubmissionfile
```

!!! warning "Overriding #SBATCH"
    If you use the command line to specify resources, such as `--nodes=1` above, that will override the `#SBATCH --nodes` configuration value in the job submission file.

**Job Defaults**

- **time:** 30 minutes of wall time, or clock time
- **nodes:** 1

**Multi-Node Jobs**

Each compute node in { hostname.title() } has 128 processor cores. In some cases, you may want to request multiple nodes. To utilize multiple nodes, you will need to have a program or code that is specifically programmed to use multiple nodes such as with MPI. Simply requesting more nodes will not make your work go faster. Your code must utilize all the cores to support this ability. To request 2 compute nodes with 256 tasks:

```shell-session

$ sbatch --nodes=2 --ntasks=256 myjobsubmissionfile
```

If more convenient, you may also specify any command line options to sbatch from within your job submission file, using the `#SBATCH` keyword:

```bash
#!/bin/sh -l
# FILENAME:  myjobsubmissionfile

#SBATCH -A myallocation
#SBATCH -p queue-name # the default queue is "shared" queue
#SBATCH --nodes=2
#SBATCH --ntasks=1 
#SBATCH --time=1:30:00
#SBATCH --job-name myjobname

module purge # Unload all loaded modules and reset everything to original state.
module load ...
...
module list # List currently loaded modules.
# Print the hostname of the compute node on which this job is running.
hostname
```

!!! note "Command-line vs. #SBATCH"
    If an option is present in both your job submission file and on the command line, the option on the command line will take precedence.

After you submit your job with `sbatch`, it may wait in the queue for minutes, hours, or even days.

!!! warning "Job queue times"
    How long it takes for a job to start depends on the specific queue, the available resources, and time requested, and other jobs that are already waiting in that queue. It is impossible to say for sure when any given job will start. For best results, request no more resources than your job requires.

Once your job is submitted, you can [monitor the job status, wait for the job to complete, and check the job output](#monitoring-jobs).

### Interactive jobs

In addition to the ThinLinc and OnDemand interfaces, users can also choose to run interactive jobs on compute nodes to obtain a shell that they can interact with. This gives users the ability to type commands or use a graphical interface as if they were on a login node.

To submit an interactive job, use `sinteractive` to run a login shell on allocated resources.

`sinteractive` accepts most of the same resource requests as sbatch, so to request a login shell in the compute queue while allocating 2 nodes and 256 total cores, you might do:

```
$ sinteractive -p wholenode -N 2 -n 256 -A oneofyourallocations
```

!!! note "Wait times"
    You can check the predicted wait time for a queued job by running `wait_time -j {your_job_id}`

To quit your interactive job:

`exit` or `Ctrl-D`

<hr style="border: 3px solid">

### Redirecting Job Output

It is possible to redirect job output to somewhere other than the default location with the `--error` and `--output` directives:

```bash
#! /bin/sh -l
#SBATCH --output=/path/myjob.out
#SBATCH --error=/path/myjob.out

# This job prints "Hello World" to output and exits
echo "Hello World"
```

### Holding a Job

Sometimes you may want to submit a job but not have it run just yet. You may be wanting to allow lab mates to cut in front of you in the queue - so hold the job until their jobs have started, and then release yours.

To place a hold on a job before it starts running, use the scontrol hold job command:

```shell-session
$ scontrol hold job <myjobid>
```

Once a job has started running it can not be placed on hold.

To release a hold on a job, use the scontrol release job command:

```shell-session
$ scontrol release job  myjobid
```

"""
    
    @env.macro
    def sftp_snippet(hostname):
        return f"""
*SFTP* (Secure File Transfer Protocol) is a reliable way of transferring files between two machines. SFTP is available as a protocol choice in some graphical file transfer programs and also as a command-line program on most Linux, Unix, and Mac OS X systems. SFTP has more features than SCP and allows for other operations on remote files, remote directory listing, and resuming interrupted transfers. Command-line SFTP cannot recursively copy directory contents; to do so, try using SCP or graphical SFTP client.

Command-line usage:

```

$ sftp -B buffersize USERNAME@{ hostname }.rcac.purdue.edu

      (to a remote system from local)
sftp> put sourcefile somedir/destinationfile
sftp> put -P sourcefile somedir/

      (from a remote system to local)
sftp> get sourcefile somedir/destinationfile
sftp> get -P sourcefile somedir/

sftp> exit
```

* **-B**: optional, specify buffer size for transfer; larger may increase speed, but costs memory
* **-P**: optional, preserve file attributes and permissions

Linux / Solaris / AIX / HP-UX / Unix:

* The "sftp" command-line program should already be installed.

Microsoft Windows:

* [MobaXterm](https://mobaxterm.mobatek.net/download.html)  
  Free, full-featured, graphical Windows SSH, SCP, and SFTP client.

Mac OS X:

* The "sftp" command-line program should already be installed. You may start a local terminal window from "Applications->Utilities".
* [Cyberduck](https://cyberduck.io/) is a full-featured and free graphical SFTP and SCP client.
"""
    
    @env.macro
    def scp_snippet(hostname):
        return f"""
**SCP (Secure CoPy)** is a simple way of transferring files between two machines that use the SSH protocol. SCP is available
as a protocol choice in some graphical file transfer programs and also as a command line program on most Linux, Unix, and Mac OS X
systems. SCP can copy single files, but will also recursively copy directory contents if given a directory name. An SSH key is
required for SCP. Following is an example of transferring `test.txt` file from { hostname.title() } home directory to your local
machine, make sure to use your username `USERNAME`:

```
localhost> scp USERNAME@{ hostname }.rcac.purdue.edu:/home/USERNAME/test.txt .
Warning: Permanently added the xxxxxxx host key for IP address 'xxx.xxx.xxx.xxx' to the list of known hosts.
test.txt                                                                    100%    0     0.0KB/s   00:00
```
"""
    
    @env.macro
    def accounts_md_snippet(host,cluster):
        return f"""
# Accounts on {cluster}
### Obtaining an Account

To obtain an account, you must be part of a research group which has purchased access to {cluster}. Refer to the [Accounts / Access](https://www.rcac.purdue.edu/account/request) page for more details on how to request access.

!!! note
    External (non-Purdue) collaborators can be granted access to {cluster}, provided the collaborator has a valid Purdue career account. If the collaborator does not have a Purdue career account, a current Purdue faculty or staff member must file a [Request for Privileges (R4P)](https://www.purdue.edu/apps/account/r4p) to have the career account created.

## Logging In To {cluster}
There are several ways to login to {cluster}:

### Thinlinc web client
One can login to the {cluster} front-end with a full desktop environment via the [Thinlinc web client](https://desktop.{host}).

!!! important
    Your full password,push Duo passphrase is needed to trigger the Duo notification that is sent to your phone for approval.

### Gateway / OnDemand
One can login to {cluster}'s [Gateway](https://gateway.{host}) to manage files in your home/scratch/depot directories and start Slurm jobs for supported OnDemand applications.

### SSH
*Secure Shell* or *SSH* is a way of establishing a secure connection between two computers. It uses public-key cryptography to authenticate the user with the remote computer and to establish a secure connection. Its usual function involves logging in to a remote machine and executing commands. There are many SSH clients available for all operating systems.

!!! note
    {cluster} supports either Purdue's Duo two-factor authentication or SSH keys.

#### SSH Client Software
Linux / Solaris / AIX / HP-UX / Unix:

- The `ssh` command is pre-installed. Log in using `ssh username@gautschi.rcac.purdue.edu` from a terminal.

Microsoft Windows:

- [MobaXterm](https://mobaxterm.mobatek.net/download.html) is a small, easy to use, full-featured SSH client. It includes X11 support for remote displays, SFTP capabilities, and limited SSH authentication forwarding for keys.

Mac OS X:

- The `ssh` command is pre-installed. You may start a local terminal window from "Applications->Utilities". Log in by typing the command `ssh username@{host}`.

!!! important
    When prompted to enter a password, enter your Purdue career account password **followed by "**`,push` **"**. Your Duo app will then receive a notification to approve the login.

### SSH Keys
SSH keys can be used in lieu of the Duo passphrase "password,push" for password-less logins. Refer to the blog post [here](../../blog/posts/ssh_key_creation.md) for more information.


### ThinLinc
It's possible to login to {cluster} using the ThinLinc desktop app. Refer to the blog post [here](../../blog/posts/thinlinc-login.md) for more information on the installation and login steps.
"""
    
    @env.macro
    def todo_file_recovery_snippet(host, hostname):
        return f"""
"""