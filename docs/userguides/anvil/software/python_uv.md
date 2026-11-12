---
tags:
  - Anvil
  - Python
authors:
  - glentner
search:
  boost: 2
---

# Python Packages with uv on Anvil

The `uv` module provides [uv](https://docs.astral.sh/uv/), a fast Python package and project manager,
on Anvil. See its [software catalog entry](../../../software/apps_md/uv.md) for the versions available.

!!! warning "Anvil scratch is purged after 30 days"
    By default the module keeps uv and everything it stores under `$SCRATCH/.uv`. Anvil purges
    scratch files that go unused for 30 days, sooner than most RCAC clusters. To keep your uv state
    on project storage instead, create a directory of your own under `$PROJECT` and point
    `UVM_ROOT` at it before loading the module:

    ```bash
    $ mkdir -p $PROJECT/$USER
    $ export UVM_ROOT=$PROJECT/$USER/.uv
    $ module load uv
    ```

    Use a directory of your own, never the top of `$PROJECT` itself: that space is shared by
    everyone on your allocation, and uv's files are meant to be yours alone. Add the `export` line
    to your `~/.bashrc` to make the choice permanent.

--8<-- "docs/snippets/examples/apps/python/uv.md"

[**Back to Anvil Software**](../anvil-software.md)
