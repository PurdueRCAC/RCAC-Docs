# PhysicalAI-Autonomous-Vehicles

[Back to AI datasets](../ai.md)

!!! warning "Restricted dataset"
    This dataset is only available in Anvil Object Storage (S3), in the `restricted-ai-datasets` bucket. You must accept the NVIDIA Autonomous Vehicle Dataset License Agreement and be approved by RCAC before you can access it.

| Field | Value |
|--------|-------|
| **Description** | PhysicalAI-Autonomous-Vehicles is NVIDIA's multi-sensor driving dataset for autonomous vehicle research. It contains 1,700 hours of driving from planned data-collection drives in 25 countries and more than 2,500 cities, split into 306,152 clips of 20 seconds each. Every clip has 7 cameras; 298,326 clips also have LiDAR and 160,761 clips have up to 10 radars. Ego motion, sensor calibration and automatically generated (non-ground-truth) labels are included. The data covers a wide range of traffic densities, road types, weather, road surface conditions and times of day. |
| **Access** | **Restricted**: requires accepting the [NVIDIA Autonomous Vehicle Dataset License Agreement](https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles) and an approved ticket. See [How to get access](#how-to-get-access). |
| **S3 Location** | `s3://restricted-ai-datasets/PhysicalAI-Autonomous-Vehicles` |
| **Discipline** | AI / PhysicalAI / Autonomous Vehicles |
| **DOI** |  |
| **Link** | [Dataset page](https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles) |
| **Publication Date** | 2026-09-12 |
| **Downloaded** | 2026-10-05 |
| **Data Type** | Camera: MP4 (1080p, 30 fps) in zip chunks<br>LiDAR and radar: Parquet<br>Calibration, ego motion, labels, metadata: Parquet |
| **Dataset Size** | 121T |
| **Number of Files** | 73941 |
| **Usage Policy Link** | https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles/blob/main/LICENSE.pdf |
| **Usage Policy** | NVIDIA Autonomous Vehicle Dataset License Agreement. Use is limited to autonomous vehicle and automated driving development (commercial or non-commercial) under the license terms. Among other restrictions, the license prohibits surveillance, identifying individuals or license plates, and redistributing the dataset. The agreement expires 12 months after the initial download. Read the full license before use. |
| **Citation** | NVIDIA Corporation. (2026). PhysicalAI-Autonomous-Vehicles (Version 26.09) [Dataset]. Hugging Face. https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles |
| **BibTeX** | <details><summary>📜 View BibTeX citation</summary><pre>@misc{nvidia_physicalai_autonomous_vehicles,<br>  author    = &#123;{NVIDIA Corporation}},<br>  title     = &#123;{PhysicalAI-Autonomous-Vehicles}},<br>  year      = {2026},<br>  version   = {26.09},<br>  publisher = {Hugging Face},<br>  howpublished = {\url{https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles}},<br>  note      = {Dataset}<br>}</pre></details> |

## How to get access

1. **Accept the agreement.** Sign in at [https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles](https://huggingface.co/datasets/nvidia/PhysicalAI-Autonomous-Vehicles) and accept the NVIDIA Autonomous Vehicle Dataset License Agreement. Take a screenshot that shows you have accepted it.
2. **Send us a ticket** with the dataset name (`PhysicalAI-Autonomous-Vehicles`) and the screenshot attached, through one of these portals:
    - [RCAC support ticket](https://service.purdue.edu/TDClient/32/Purdue/Requests/TicketRequests/NewForm?ID=WT~8y8Nl8Ks_&RequestorType=ServiceOffering)
    - [ACCESS support ticket](https://support.access-ci.org/open-a-ticket)
    - [NAIRR support ticket](https://nairrpilot.org/open-support-request)

    You also need Anvil Object Storage access. If you do not have it yet, ask for it in the same ticket (see [Getting access to Object Storage](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/access/)).
3. **Get your keys.** After we approve your request, run `mykeys` on any Anvil login node to get your access key and secret key (see [Security and Access Control](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/acl/)).
4. **Access the data in S3.** The dataset is only in object storage, at the endpoint and bucket below. It is not on the cluster file systems and has no module with data paths.

## S3 access

| Parameter | Value |
|-----------|-------|
| **Endpoint** | `https://s3.anvil.rcac.purdue.edu` |
| **Bucket** | `restricted-ai-datasets` |
| **Path** | `s3://restricted-ai-datasets/PhysicalAI-Autonomous-Vehicles` |
| **Access** | Restricted: approved users only, with their own keys |

With rclone configured with your keys (see the [User Tools guide](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/usertools/)):

```bash
$ module load rclone
$ rclone lsd <your-remote>:restricted-ai-datasets/PhysicalAI-Autonomous-Vehicles
```

For more on object storage, see the [Anvil Object Storage documentation](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/). For other datasets, see [RCAC datasets](https://docs.rcac.purdue.edu/datasets/).
