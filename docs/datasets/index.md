# RCAC Datasets

Browse datasets available on Purdue RCAC clusters. This page links to the main dataset categories and shows how to discover datasets on the system.

## Getting Started

To see which datasets are available on the system, run:

```bash
$ module avail
$ module load datasets
```

After loading the module, you can check the datasets available in a specific category such as `ai`, `hydrological`, or `meteorological`:

```bash
$ module avail <category>
```

!!! note "Dataset locations"
    Public datasets are accessible at the following paths:

    - **Anvil:** `/anvil/datasets`
    - **Community clusters** (Gilbreth, Negishi, Bell, Gautschi, and others): `/depot/datasets`

    These paths are accessible to all cluster users with read-only permissions.

!!! tip "Use the `DATASETS_DIR` environment variable"
    After running `module load datasets`, the base dataset path is automatically stored in the `DATASETS_DIR` environment variable for convenient access in your shell, jobs, and workflows.

## Browse Dataset Categories

- [AI Datasets](ai.md)
- [Climate Model Datasets](climateModel.md)
- [Covariates Datasets](Covariates.md)
- [GeoAI Datasets](geoai.md)
- [Geospatial Datasets](geospatial.md)
- [Hydrological Datasets](hydrological.md)
- [Meteorological Datasets](meteorological.md)

## Complete Dataset Catalog

For a filterable table of all datasets, see the [Complete Dataset Catalog](dataset_catalog.md).

## Requesting New Datasets

!!! question "Can't find the dataset you need?"
    If you need a dataset that is not currently hosted, submit a request through the appropriate support channel below. We welcome suggestions for new datasets that would benefit the RCAC research community.
    
    === "Purdue Community Cluster"
        :material-server: **For Gautschi, Gilbreth, Negishi, Bell, and other Purdue clusters**

        [Submit a ticket to RCAC](https://service.purdue.edu/TDClient/32/Purdue/Requests/TicketRequests/NewForm?ID=WT~8y8Nl8Ks_&RequestorType=ServiceOffering){ .md-button }

    === "ACCESS Allocations (Anvil)"
        :material-cloud: **For Anvil's ACCESS allocations**

        [Submit a ticket to ACCESS support](https://support.access-ci.org/open-a-ticket){ .md-button }

    === "NAIRR Allocation (Anvil)"
        :material-robot: **For Anvil's NAIRR Pilot allocations**

        [Submit a ticket to NAIRR support](https://nairrpilot.org/open-support-request){ .md-button }

    **What to include in your request**

    Providing complete information helps us evaluate and process your request efficiently:

    | Information | Why it's needed |
    |-------------|---------------|
    | **Justification** | Explain why you need this dataset and how it supports your research |
    | **Public availability** | Is the dataset publicly accessible? Are there license restrictions? |
    | **Research description** | Brief summary of your research project and goals |
    | **Dataset link** | URL or reference to access or download the dataset |
    | **Publication reference** | Citations or publications describing the dataset (if available) |
    | **Dataset size** | Total size (GB/TB) for storage capacity planning


