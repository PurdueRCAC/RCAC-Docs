# RCAC Datasets

Browse public datasets available on Purdue RCAC clusters. This page links to the main dataset categories and shows how to discover datasets on the system.

## Browse Dataset Categories

- [AI Datasets](ai.md)
- [Hydrological Datasets](hydrological.md)
- [Meteorological Datasets](meteorological.md)
- [Geospatial Datasets](geospatial.md)
- [Covariates Datasets](Covariates.md)
- [GeoAI Datasets](geoai.md)

## Getting Started

To see which datasets are available on the system, run:

```bash
$ module avail
$ module load datasets
```

After loading the module, you can check the datasets available in a specific category such as `ai`, `hydrological`, or `meteorological`:

```bash
$ module avail datasets/<category>
```

!!! note "Dataset locations"
    Public datasets are accessible at the following paths:

    - **Anvil:** `/anvil/datasets`
    - **Community clusters** (Gilbreth, Negishi, Bell, Gautschi, and others): `/depot/datasets`

    These paths are accessible to all cluster users with read-only permissions.

!!! tip "Use the `DATASETS_DIR` environment variable"
    After running `module load datasets`, the base dataset path is automatically stored in the `DATASETS_DIR` environment variable for convenient access in your shell, jobs, and workflows.
