---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Storage Environment Variables

Several environment variables are automatically defined for you to help you manage your storage. Use environment variables instead of actual paths whenever possible to avoid problems if the specific paths to any of these change.

Some of the environment variables you should have are:

| Name | Description |
| --- | --- |
| HOME | /home/myusername |
| PWD | path to your current directory |
| RCAC\_SCRATCH | /scratch/bell/myusername |

By convention, environment variable names are all uppercase. You may use them on the command line or in any scripts in place of and in combination with hard-coded values:

```
$ ls $HOME
...

$ ls $RCAC_SCRATCH/myproject
...
```

To find the value of any environment variable:

```
$ echo $RCAC_SCRATCH
/scratch/bell/myusername 
```

To list the values of all environment variables:

```
$ env
USER=myusername
HOME=/home/myusername
RCAC_SCRATCH=/scratch/bell/myusername 
...
```

You may create or overwrite an environment variable. To pass (export) the value of a variable in bash:

```
$ export MYPROJECT=$RCAC_SCRATCH/myproject
```

To assign a value to an environment variable in either tcsh or csh:

```
$ setenv MYPROJECT value
```
