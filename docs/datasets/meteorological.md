# Meteorological Datasets


[Back to all datasets](index.md)


Meteorological datasets provide gridded observations, reanalyses, and climate projections used for hydrology, weather forecasting, and climate research. These data support studies of precipitation, temperature, radiation, and related environmental processes.

To access the datasets on RCAC clusters:
```bash
$ module avail
$ module load datasets
$ module avail meteorological
```

## Tips:
- Use echo `$ENV_NAME` to check the environment value.
- To see all environment variables related to a dataset, you can load the module then use: env | grep `<DATASET_NAME>`
- To unload the module and remove the environment settings: module unload `<DATASET_NAME>`
- Each dataset module sets environment variables (e.g., `$<DATASET_NAME>_ROOTDIR`, `$<DATASET_NAME>_HOME`, `$RCAC_<DATASET_NAME>_ROOT`, and `$RCAC_<DATASET_NAME>_VERSION`) that simplify dataset access and version management within your jobs and workflows.

## Meteorological Datasets

| Dataset | Description |
|---------|-------------|
| [**DAYMET**](meteorological/DAYMET.md) | Daymet offers daily surface meteorological data for North America, including variables such as temperature, precipitation, and radiation |
| [**ECCC_RDRS**](meteorological/ECCC_RDRS.md) | The RDRSv2.1 dataset is a high-resolution atmospheric reanalysis produced by Environment and Climate Change Canada (ECCC) |
| [**EMDNA**](meteorological/EMDNA.md) | EMDNA provides high-resolution meteorological data for North America, offering hourly and daily variables from January 1979 to December 2018 |
| [**EME**](meteorological/EME.md) | EM-Earth is a global dataset offering hourly and daily meteorological variables from January 1950 to December 2019 |
| [**ERA5**](meteorological/ERA5.md) | ERA5 is a comprehensive reanalysis dataset produced by the European Centre for Medium-Range Weather Forecasts (ECMWF) |
| [**ERA5_HYDRO**](meteorological/ERA5_HYDRO.md) | This subset of ERA5 focuses on variables pertinent to hydrological modeling |
| [**NEXGDDP**](meteorological/NEXGDDP.md) | NEX-GDDP-CMIP6 provides global downscaled climate scenarios derived from CMIP6 models |
| [**OURANOS_ESPO**](meteorological/OURANOS_ESPO.md) | Developed by Ouranos, the ESPO-G6-R2 dataset comprises daily climate projections from January 1950 to December 2100 |
| [**SCDNA**](meteorological/SCDNA.md) | SCDNA is a point-based dataset offering daily surface climate variables across North America from January 1979 to December 2018 |
| [**SCE**](meteorological/SCE.md) | SC-Earth provides global point-based daily surface climate data from January 1950 to December 2019 |
