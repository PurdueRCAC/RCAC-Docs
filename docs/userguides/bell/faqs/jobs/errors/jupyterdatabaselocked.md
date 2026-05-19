---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Jupyter:  database is locked / can not load notebook format

### Problem

You receive the following message after trying to load existing Jupyter notebooks inside your JupyterHub session:

```

Error loading notebook

An unknown error occurred while loading this notebook.  This version can load notebook formats or earlier. See the server log for details.
```

Alternatively, the notebook may open but present an error when creating or saving a notebook:

```

Autosave Failed!

Unexpected error while saving file:  MyNotebookName.ipynb database is locked
```

### Solution

When Jupyter notebooks are opened, the server keeps track of their state in an internal database (located inside `~/.local/share/jupyter/` folder in your home directory). If a Jupyter process gets terminated abruptly (e.g. due to an out-of-memory error or a host reboot), the database lock is not cleared properly, and future instances of Jupyter detect the lock and complain.

Please follow these steps to resolve:

1. Fully exit from your existing Jupyter session (close all notebooks, terminate Jupyter, log out from JupyterHub or JupyterLab, terminate OnDemand gateway's Jupyter app, etc).
2. In a terminal window (SSH, ThinLinc or OnDemand gateway's terminal app) use the following command to clean up stale database locks:

    ```
    $ unlock-jupyter
    ```

3. Start a new Jupyter session as usual.
