# uv

[Back to application catalog](../app_catalog.md)

## Description

uv is a fast Python package and project manager, written in Rust, that covers what pip, virtualenv, pipx and pyenv do in one tool. On RCAC clusters the uv module provides uv through the uv-manager wrapper: you run uv and uvx as usual, and each user gets their own copy of uv, with its download cache, tool environments and uv-managed Python interpreters kept on scratch rather than in the home directory, separated by CPU architecture. In batch jobs the module repairs files lost to the scratch purge before your command runs.

## Homepage

[https://docs.astral.sh/uv/](https://docs.astral.sh/uv/)

## Available Versions on RCAC Clusters

|Cluster|Versions|
|---|---|
**ANVIL**|0.7.0, 0.8.0 (D)
**GAUTSCHI**|0.7.0, 0.8.0 (D)
**GILBRETH**|0.7.0, 0.8.0 (D)
**NEGISHI**|0.7.0, 0.8.0 (D)
**SCHOLAR**|0.7.0, 0.8.0 (D)

(D): Default Module

## Module

You can load the module by:

```bash
module load uv
```

!!! note "Note for using `uv`"
    Run `module spider uv` beforehand to check if this version requires any prerequisite modules.
