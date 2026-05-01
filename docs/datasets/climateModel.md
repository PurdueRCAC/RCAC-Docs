# Climate Model Datasets

[Back to all datasets](index.md)

Climate model datasets provide comprehensive Earth system simulation data used in climate research, atmospheric chemistry modeling, and global climate projections. These datasets include input data, forcing files, and configuration datasets for running and validating global climate and Earth system models.

To access the datasets on RCAC clusters:
```bash
$ module avail
$ module load datasets
$ module avail climateModel
```

## Tips:
- Use echo `$ENV_NAME` to check the environment value.
- To see all environment variables related to a dataset, you can load the module then use: env | grep `<DATASET_NAME>`
- To unload the module and remove the environment settings: module unload `<DATASET_NAME>`
- Each dataset module sets environment variables (e.g., `$<DATASET_NAME>_ROOTDIR`, `$<DATASET_NAME>_HOME`, `$RCAC_<DATASET_NAME>_ROOT`, and `$RCAC_<DATASET_NAME>_VERSION`) that simplify dataset access and version management within your jobs and workflows.

## Climate Model Datasets

| Dataset | Description |
|---------|-------------|
| [**CESM2**](climateModel/CESM2.md) | The Community Earth System Model Version 2 (CESM2) is a fully-coupled global climate model developed by NCAR for simulating Earth's climate system |
| [**GEOS-Chem**](climateModel/GEOS-Chem.md) | Global 3-D atmospheric chemistry model input data including GEOS meteorological fields, HEMCO emissions inventories, and chemistry inputs |
