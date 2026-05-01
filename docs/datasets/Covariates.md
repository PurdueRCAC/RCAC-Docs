# Covariate Datasets


[Back to all datasets](index.md)


Covariate datasets provide environmental, ecological, and anthropogenic variables that serve as inputs for modeling, analysis, and prediction across disciplines such as ecology, climate science, and land management. These include bioclimatic layers, vegetation structure, soil attributes, and human influence indicators.

To access the datasets on RCAC clusters:
```bash
$ module avail
$ module load datasets
$ module avail Covariates
```

## Tips:
- Use echo `$ENV_NAME` to check the environment value.
- To see all environment variables related to a dataset, you can load the module then use: env | grep `<DATASET_NAME>`
- To unload the module and remove the environment settings: module unload `<DATASET_NAME>`
- Each dataset module sets environment variables (e.g., `$<DATASET_NAME>_ROOTDIR`, `$<DATASET_NAME>_HOME`, `$RCAC_<DATASET_NAME>_ROOT`, and `$RCAC_<DATASET_NAME>_VERSION`) that simplify dataset access and version management within your jobs and workflows.

## Covariate Datasets

| Dataset | Description |
|---------|-------------|
| [**Cattle**](Covariates/Cattle.md) | Distribution of cattle in 2010 expressed in total number of cattle per pixel (5 min of arc) |
| [**CHELSA_Present_bio**](Covariates/CHELSA_Present_bio.md) | High-resolution climatic data for present-day bioclimatic analysis |
| [**CHELSA_2011-2040**](Covariates/CHELSA_2011-2040.md) | Climatic data projections for analysis and modeling |
| [**CHELSA_2041-2070**](Covariates/CHELSA_2041-2070.md) | Climatic data projections for mid-century climate modeling |
| [**CHELSA_2071-2100**](Covariates/CHELSA_2071-2100.md) | End-of-century climate projections |
| [**ForestAge**](Covariates/ForestAge.md) | Mapped global forest age from inventories, biomass, and climate data |
| [**ForestHeight2020**](Covariates/ForestHeight2020.md) | Integration of GEDI and Landsat data for global forest canopy height |
| [**ForestManagement**](Covariates/ForestManagement.md) | Detailed forest management data at a 100m resolution |
| [**GEDI**](Covariates/GEDI.md) | Gridded land surface metrics from GEDI data |
| [**HumanFootprint**](Covariates/HumanFootprint.md) | Global human footprint analysis at 1km resolution |
| [**PBCOR_V1.0**](Covariates/PBCOR_V1.0.md) | Corrected global high-resolution precipitation climatologies |
| [**PlantedYear**](Covariates/PlantedYear.md) | Year of planting for global plantation areas |
| [**Roadless**](Covariates/Roadless.md) | A global map of roadless areas for conservation purposes |
| [**Soil_WISE30sec**](Covariates/Soil_WISE30sec.md) | Harmonized global soil property database for modeling applications |
| [**Tree_Species_Richness**](Covariates/Tree_Species_Richness.md) | Dataset on global tree species diversity and richness |
| [**WorldClim_Historical_bio**](Covariates/WorldClim_Historical_bio.md) | Historical climate data for global land areas |
