---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Default Configuration

This is what a default configuration looks like for a research group called "mylab":

```
/depot/mylab/
            +--apps/
            |
            +--data/
            |
            +--etc/
            |     +--bashrc
            |     +--cshrc
            |
 (other subdirectories)
```

The `/depot/mylab/` directory is the main top-level directory for all your research group storage. All files are to be kept within one of the subdirectories of this, based on your specific access requirements. These subdirectories will be created after consulting with you as to exactly what you need.

By default, the following subdirectories, with the following access and use models, will be created. All of these details can be changed to suit the particular needs of your research group.

- **`data/`**
    
    Intended for read and write use by a limited set of people chosen by the research group's managers. Restricted to not be readable or writable by anyone else.
    
    !!!info
        This is frequently used as **an open space for storage of shared research data**.

- `apps/`

    Intended for write use by a limited set of people chosen by the research group's managers.

    Restricted to not be writable by anyone else.

    Allows read and execute by anyone who has access to any cluster queues owned by the research group and anyone who has other file permissions granted by the research group (such as "data" access above).

    !!!info
        This is frequently used as **a space for central management of shared research applications**.

- `etc/`
    
    Intended for write use by a limited set of people chosen by the research group's managers (by default, the same as for "apps" above).
    
    Restricted to not be writable by anyone else.
    
    Allows read and execute by anyone who has access to any cluster queues owned by the research group and anyone who has other file permissions granted by the research group (such as "data" access above).
    
    !!!info
        This is frequently used as **a space for central management of shared startup/login scripts, environment settings, aliases, etc**.

- `etc/bashrc` and `etc/cshrc`
    
    Examples of group-wide shell startup files. Group members can source these from their own `$HOME/.bashrc` or `$HOME/.cshrc` files so they would automatically pick up changes to their environment needed to work with applications and data for the research group.

- Additional subdirectories can be created as needed in the top and/or any of the lower levels. Just [contact support](mailto:rcac-help@purdue.edu) and we will be happy to figure out what will work best for your needs.
