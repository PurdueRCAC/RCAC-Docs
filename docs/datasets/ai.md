# AI Datasets

[Back to all datasets](index.md)

AI datasets in this collection cover computer vision, physicalAI, and robotics. They support tasks such as detection, segmentation, tracking, control, reinforcement learning, and large-scale model pretraining and evaluation across domains including everyday objects, smart spaces, and embodied PhysicalAI.

This page provides access to curated AI datasets available on RCAC clusters through two storage options: 

- compressed formats on the POSIX file system, and 
- raw/extracted data on S3-compatible object storage.

A few restricted datasets (marked 🔒 below) are available only on S3-compatible object storage, after you accept the dataset's license agreement and we approve your request.

## Accessing AI Datasets

Choose your preferred access method based on your workflow needs.

!!! tip "Which option should I choose?"
    - **Use POSIX** if you are running training jobs on RCAC clusters and need maximum I/O performance with compressed formats.
    - **Use S3** if you need to browse or download individual files, or stream data without downloading entire archives.


=== "POSIX File System (Compressed Formats)"
    Compressed formats like LMDB and SquashFS are optimized for high-performance access on RCAC clusters. These are ideal for training jobs that need fast, local access to preprocessed data.
    
    **Quick Start:**
    
    ```bash
    $ module avail
    $ module load datasets
    $ module avail ai
    $ module load ai/<dataset-name>
    ```
    
    ## Working with Datasets

    Once you have loaded a dataset module, the following environment variables are automatically set to simplify access:

    | Variable | Description |
    |----------|-------------|
    | `$<DATASET_NAME>_ROOTDIR` | Root directory of the dataset |
    | `$<DATASET_NAME>_HOME` | Dataset home path |
    | `$RCAC_<DATASET_NAME>_ROOT` | RCAC-specific root path |
    | `$RCAC_<DATASET_NAME>_VERSION` | Dataset version |



=== "Anvil Object Storage (S3) (Raw/Extracted Format)"
    Raw and extracted datasets are available via S3-compatible object storage. This is useful for workflows that need direct access to individual files without decompressing archives, or for transferring data to other systems.
    
    | Parameter | Value |
    |-----------|-------|
    | **Endpoint** | `https://s3.anvil.rcac.purdue.edu` |
    | **Bucket** | `ai-datasets` |
    | **Access** | Public read-only |
    
    **Tools:** You can use any S3-compatible tool such as **rclone**, **s3cmd**, or **Python boto3**.
    
    ```bash
    $ module load rclone   # rclone requires module load; s3cmd is available by default
    ```
    
    For detailed instructions, see the [Anvil Object Storage documentation](../../userguides/anvil/objectstorage) and [User Tools guide](../../userguides/anvil/objectstorage/usertools).

=== "🔒 Restricted Datasets (S3 only)"
    Restricted datasets are available only in Anvil Object Storage, not on the cluster file systems. You need an approved request before you can access them.

    | Parameter | Value |
    |-----------|-------|
    | **Endpoint** | `https://s3.anvil.rcac.purdue.edu` |
    | **Bucket** | `restricted-ai-datasets` |
    | **Access** | Approved users only, with their own Object Storage keys |

    **How to get access:**

    1. Accept the dataset's license agreement on its source page and take a screenshot that shows you accepted it.
    2. Send us a ticket ([RCAC](https://service.purdue.edu/TDClient/32/Purdue/Requests/TicketRequests/NewForm?ID=WT~8y8Nl8Ks_&RequestorType=ServiceOffering), [ACCESS](https://support.access-ci.org/open-a-ticket) or [NAIRR](https://nairrpilot.org/open-support-request)) with the dataset name and the screenshot. If you do not have Anvil Object Storage access yet, ask for it in the same ticket (see [Getting access](../../userguides/anvil/objectstorage/access)).
    3. After we approve your request, run `mykeys` on any Anvil login node to get your keys (see [Security and Access Control](../../userguides/anvil/objectstorage/acl)).
    4. Access the data in the `restricted-ai-datasets` bucket with your keys (see the [User Tools guide](../../userguides/anvil/objectstorage/usertools)).

    Each restricted dataset's page lists its agreement and exact S3 path.


## Available AI Datasets

| Dataset | Description |
|---------|-------------|
| [**COCO**](ai/COCO.md) | Common Objects in Context - object detection, segmentation, and captioning |
| [**DROID**](ai/droid.md) | A Large-Scale In-the-Wild Robot Manipulation Dataset |
| [**Oxford Robot Car**](ai/oxfordrobotcar.md) | Large-scale autonomous driving dataset with camera, LiDAR, GPS/INS, and vehicle sensor data |
| [**LVIS**](ai/LVIS.md) | Large Vocabulary Instance Segmentation |
| [**VisualGenome**](ai/visualgenome.md) | Visual knowledge base with structured image annotations |
| [**commoncrawl**](ai/commoncrawl.md) | Web crawl data for pretraining language models |
| [**fast.ai**](ai/fast.ai.md) | Practical deep learning datasets and models |
| [**PhysicalAI-Robotics-GR00T-Teleop-Sim**](ai/PhysicalAI-Robotics-GR00T-Teleop-Sim.md) | GR00T teleoperation simulation data |
| [**PhysicalAI-Robotics-GR00T-X-Embodiment-Sim**](ai/PhysicalAI-Robotics-GR00T-X-Embodiment-Sim.md) | GR00T cross-embodiment simulation |
| [**PhysicalAI-Robotics-Manipulation-SingleArm**](ai/PhysicalAI-Robotics-Manipulation-SingleArm.md) | Single-arm manipulation datasets |
| [**PhysicalAI-SmartSpaces**](ai/PhysicalAI-SmartSpaces.md) | Smart environment interaction data |
| [**PhysicalAI-Autonomous-Vehicles**](ai/PhysicalAI-Autonomous-Vehicles.md) 🔒 | Multi-sensor autonomous driving data (7 cameras, LiDAR, radar) from 25 countries. **Restricted:** S3 only, requires the NVIDIA agreement and an approved ticket |


