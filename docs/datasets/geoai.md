# GeoAI Datasets


[Back to all datasets](index.md)


GeoAI datasets combine remote sensing, environmental, and multimodal sources tailored for training and evaluating geospatial machine learning models (e.g., segmentation, classification, regression) across land cover, wildfire, disaster, and climate applications.

To access the datasets on RCAC clusters:
```bash
$ module avail
$ module load datasets
$ module avail geoai
```

## Tips:
- Use echo `$ENV_NAME` to check the environment value.
- To see all environment variables related to a dataset, you can load the module then use: env | grep `<DATASET_NAME>`
- To unload the module and remove the environment settings: module unload `<DATASET_NAME>`
- Each dataset module sets environment variables (e.g., `$<DATASET_NAME>_ROOTDIR`, `$<DATASET_NAME>_HOME`, `$RCAC_<DATASET_NAME>_ROOT`, and `$RCAC_<DATASET_NAME>_VERSION`) that simplify dataset access and version management within your jobs and workflows.

## GeoAI Datasets

| Dataset | Description |
|---------|-------------|
| [**BioMassters**](geoai/BioMassters.md) | Above Ground Biomass estimation dataset using multi-modal Sentinel-1 SAR and Sentinel-2 MSI satellite data |
| [**AerialImageDataset**](geoai/AerialImageDataset.md) | The Inria Aerial Image Labeling Dataset addresses the automatic pixelwise labeling of aerial imagery |
| [**burn_intensity**](geoai/burn_intensity.md) | This dataset contains burn scar intensity data and Harmonized Landsat and Sentinel-2 (HLS) images for burn scar analysis |
| [**geo-bench**](geoai/geo-bench.md) | GEO-Bench: Toward Foundation Models for Earth Monitoring |
| [**gravity-wave-parameterization**](geoai/gravity-wave-parameterization.md) | Data format description for the nonlocal gravity wave parameterization dataset |
| [**hls_burn_scars**](geoai/hls_burn_scars.md) | This dataset contains Harmonized Landsat and Sentinel-2 imagery of burn scars and the associated masks |
| [**hls_merra2_gppFlux**](geoai/hls_merra2_gppFlux.md) | This dataset consists of Harmonized Landsat and Sentinel-2 multispectral reflectance imagery and MERRA-2 observations |
| [**hurricane**](geoai/hurricane.md) | To evaluate the performance of Prithvi WxC on hurricanes, the surface and pressure data from the MERRA-2 dataset |
| [**Landslide4sense**](geoai/Landslide4sense.md) | This dataset contains multispectral and elevation data for landslide detection |
| [**multi-temporal-crop-classification**](geoai/multi-temporal-crop-classification.md) | This dataset contains temporal Harmonized Landsat-Sentinel (HLS) imagery of diverse land cover and crop type classes |
| [**TerraMesh**](geoai/TerraMesh.md) | TerraMesh is a planetary-scale, multimodal analysis-ready dataset for Earth Observation foundation models |
