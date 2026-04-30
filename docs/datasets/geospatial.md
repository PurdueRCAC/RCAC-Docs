# Geospatial Datasets


[Back to all datasets](index.md)


Geospatial datasets provide land surface, environmental, and remote-sensing–based information used in mapping, modeling, and analysis of the Earth's physical characteristics. These datasets support research in land use, vegetation dynamics, soil properties, and surface hydrology.

To access the datasets on RCAC clusters:
```bash
$ module avail
$ module load datasets
$ module avail geospatial
```

## Tips:
- Use echo `$ENV_NAME` to check the environment value.
- To see all environment variables related to a dataset, you can load the module then use: env | grep `<DATASET_NAME>`
- To unload the module and remove the environment settings: module unload `<DATASET_NAME>`
- Each dataset module sets environment variables (e.g., `$<DATASET_NAME>_ROOTDIR`, `$<DATASET_NAME>_HOME`, `$RCAC_<DATASET_NAME>_ROOT`, and `$RCAC_<DATASET_NAME>_VERSION`) that simplify dataset access and version management within your jobs and workflows.

## Geospatial Datasets

| Dataset | Description |
|---------|-------------|
| [**MERIT_HYDRO**](geospatial/MERIT_HYDRO.md) | MERIT Hydro is a high-resolution global hydrography dataset developed to enhance the accuracy of river networks and watershed boundaries |
| [**MODIS_AQUA_EVAPOTRANSPIRATION_V61**](geospatial/MODIS_AQUA_EVAPOTRANSPIRATION_V61.md) | The MYD16A2.061 dataset provides 8-day evapotranspiration (ET) and potential evapotranspiration (PET) data derived from the Moderate Resolution Imaging Spectroradiometer (MODIS) aboard the Aqua satellite |
| [**MODIS_EVAPOTRANSPIRATION_V61**](geospatial/MODIS_EVAPOTRANSPIRATION_V61.md) | This dataset provides 8-day estimates of global terrestrial evapotranspiration and potential evapotranspiration |
| [**MODIS_EVAPOTRANSPIRATION_GAP_FILLED_V61**](geospatial/MODIS_EVAPOTRANSPIRATION_GAP_FILLED_V61.md) | A gap-filled version of the MOD16A2 dataset, it offers continuous 8-day global evapotranspiration data |
| [**MODIS_EVAPOTRANSPIRATION_GAP_FILLED_YEARLY_V61**](geospatial/MODIS_EVAPOTRANSPIRATION_GAP_FILLED_YEARLY_V61.md) | This dataset provides annual gap-filled global terrestrial evapotranspiration data |
| [**MODIS_LAND_COVER_V6**](geospatial/MODIS_LAND_COVER_V6.md) | This dataset provides annual land cover type data derived from the MODIS sensor |
| [**MODIS_LAND_COVER_V61**](geospatial/MODIS_LAND_COVER_V61.md) | An updated version of the MODIS land cover dataset, MCD12Q1.061 offers improved classification algorithms and data quality |
| [**NALCMS**](geospatial/NALCMS.md) | NALCMS offers land cover and land change data across North America |
| [**SOIL_GRIDS_V1**](geospatial/SOIL_GRIDS_V1.md) | Soil Grids v1 is a global dataset that maps soil properties at six standard depths |
