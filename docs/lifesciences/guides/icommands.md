---
title: Transfer data with iRODS
tags:
  - Life Sciences
  - Guides
---

CyVerse provides a cloud-based data store accessible via iRODS, allowing researchers to manage and transfer large datasets. From RCAC clusters (Negishi, Bell, Anvil), you can authenticate with your CyVerse account and use iCommands to list, upload, or download files efficiently.

!!! note
    If you don't have a CyVerse account, you can sign up for a free account at [CyVerse User Registration](https://user.cyverse.org/).

## Setting up iRODS access to CyVerse

1.  **Load the necessary modules**

    ```bash
    module --force purge
    module load biocontainers
    module load irods
    ```

2.  **Initialize your iRODS session**

    ```bash
    iinit
    ```

    You will be prompted to enter the following:

    ```yaml
    Enter the host name (DNS) of the server to connect to: data.cyverse.org
    Enter the port number: 1247
    Enter your irods user name: <CyVerse-Username>
    Enter your irods zone: iplant
    Enter your irods password: <CyVerse-Password>
    ```

    Enter your CyVerse password when prompted. The password is not displayed (you won't see `*` or `.` either). If successful, this creates or updates a configuration file (usually at `~/.irods/irods_environment.json`), enabling seamless use of other iCommands.

3.  **Verify your iRODS connection**

    ```bash
    ipwd
    ```

    This should return a path like:

    ```bash
    /iplant/home/<CyVerse-Username>
    ```

    If these commands work and return expected output, your connection to CyVerse is successful and you're ready to transfer files.

## Transferring files between RCAC clusters and CyVerse

Once connected, you can use iRODS commands to move files between your RCAC environment (e.g., Anvil) and CyVerse Data Store. Below are the most common operations:

### List files and directories in your Data Store

```bash
ils
```

You should see a listing of your CyVerse files and folders. Example output:

```
/iplant/home/<CyVerse-Username>:
  C- /iplant/home/<CyVerse-Username>/project1
  C- /iplant/home/<CyVerse-Username>/raw_data
    data_summary.txt
```

### Upload a file from RCAC to CyVerse

```bash
iput results.txt /iplant/home/<CyVerse-Username>/
```

This command uploads the local file `results.txt` to your CyVerse home directory.

### Upload a directory (recursively)

```bash
iput -r analysis_folder /iplant/home/<CyVerse-Username>/
```

The `-r` flag allows you to upload entire directories.

### Download a file from CyVerse to RCAC

```bash
iget /iplant/home/<CyVerse-Username>/raw_data.fastq .
```

This downloads the file into your current working directory on the cluster.

### Download a directory (recursively)

```bash
iget -r /iplant/home/<CyVerse-Username>/project_folder .
```

This downloads an entire directory and its contents.

### Create a new directory (collection) in CyVerse

```bash
imkdir /iplant/home/<CyVerse-Username>/new_project
```

Organize your files by creating collections before uploading.

### Rename or move files within CyVerse

```bash
imv /iplant/home/<CyVerse-Username>/old.txt /iplant/home/<CyVerse-Username>/archived.txt
```

This renames `old.txt` to `archived.txt` in place.

### Delete files or directories from CyVerse

```bash
irm /iplant/home/<CyVerse-Username>/unnecessary.txt
irm -r /iplant/home/<CyVerse-Username>/old_project
```

Use `-r` to delete directories. These operations are permanent unless your account uses trash recovery.

## Commonly used iRODS commands

| Command     | Description                                             | Example Usage                                                                 |
|-------------|---------------------------------------------------------|--------------------------------------------------------------------------------|
| `iinit`     | Authenticate and start an iRODS session                 | `iinit` (follow prompts: hostname = `data.cyverse.org`, port = `1247`, etc.)  |
| `ils`       | List current files and directories                      | `ils` / `ils /iplant/home/your_username`                                     |
| `ipwd`      | Show current iRODS working directory                    | `ipwd`                                                                         |
| `icd`       | Change directory (collection) in iRODS                  | `icd /iplant/home/your_username/project1`                                     |
| `iget`      | Download a file or directory from iRODS to local system | `iget data.txt` / `iget -r project_folder`                                   |
| `iput`      | Upload a file or directory from local system to iRODS   | `iput results.txt /iplant/home/your_username/` / `iput -r output_dir`        |
| `imkdir`    | Create a new directory (collection) in iRODS            | `imkdir /iplant/home/your_username/new_project`                               |
| `irm`       | Delete files or directories from iRODS                  | `irm old.txt` / `irm -r old_project`                                         |
| `imv`       | Move or rename files/directories within iRODS           | `imv oldname.txt newname.txt` / `imv old_dir/ new_dir/`                      |
| `icp`       | Copy a file or directory within iRODS                   | `icp file1.txt file2.txt` / `icp -r project1/ project2/`                     |
| `ichksum`   | Compute or verify file checksums                        | `ichksum results.txt`                                                         |
| `ienv`      | Display current iRODS session environment               | `ienv`                                                                         |
| `ihelp`     | Show list of available iCommands                        | `ihelp`                                                                        |
| `iexit`     | Log out and clear iRODS session                         | `iexit full`                                                                   |

## References

- [iRODS Documentation](https://irods.org/documentation/)
- [CyVerse iRODS Documentation](https://learning.cyverse.org/ds/icommands/)
