# imagenet-1k-ILSVRC-2012

[Back to ai datasets](../ai.md)

!!! warning "Restricted dataset"
    This dataset is on the Depot and Anvil file systems and in Anvil Object Storage (S3), in the `restricted-ai-datasets` bucket, but only approved users can read it. You must accept the ImageNet Terms of Access and be approved by RCAC before you can access it.

| Field | Value |
|--------|-------|
| **Description** | The ILSVRC 2012 image classification dataset, commonly called ImageNet-1k. It spans 1,000 object classes, with 1,281,167 training images and 50,000 validation images. The 100,000-image test set is not included. It is provided both as a single SquashFS image and as extracted train/ and val/ folders, together with a class index (ImageNet_class_index.json) and the validation labels (ImageNet_val_label.txt). |
| **Access** | **Restricted**: requires accepting the [ImageNet Terms of Access](https://image-net.org/) and an approved ticket. See [How to get access](#how-to-get-access). |
| **Folder** | Depot: `/depot/datasets/restricted_datasets/ai/imagenet-1k/imagenet-1k-ILSVRC-2012`<br>Anvil: `/anvil/datasets/restricted_datasets/ai/imagenet-1k/imagenet-1k-ILSVRC-2012` |
| **S3 Location** | `s3://restricted-ai-datasets/imagenet-1k/imagenet-1k-ILSVRC-2012` |
| **Discipline** | AI / Computer Vision / Image Classification |
| **DOI** | [10.1007/s11263-015-0816-y](https://doi.org/10.1007/s11263-015-0816-y) |
| **Link** | [Dataset page](https://image-net.org/) |
| **Publication Date** | 2012 |
| **Downloaded** | 2025-08-22 |
| **Data Type** | SquashFS<br>Extracted files on Ceph |
| **Dataset Size** | 143G |
| **Number of Files** | 1331171 |
| **Usage** | <pre>&#36; module avail<br>&#36; module load datasets<br>&#36; module load ai/imagenet-1k/imagenet-1k-ILSVRC-2012</pre> |
| **Usage Policy Link** | https://image-net.org/ |
| **Usage Policy** | ImageNet Terms of Access. The database may be used only for non-commercial research and educational purposes. The researcher accepts full responsibility for their use of the database, may share access with research associates and colleagues only if they first agree to the same terms, and, if employed by a for-profit company, the employer is also bound by the terms. Access can be terminated at any time. |
| **Citation** | Russakovsky, O., Deng, J., Su, H., Krause, J., Satheesh, S., Ma, S., Huang, Z., Karpathy, A., Khosla, A., Bernstein, M., Berg, A. C., & Fei-Fei, L. (2015). ImageNet Large Scale Visual Recognition Challenge. International Journal of Computer Vision, 115(3), 211-252. https://doi.org/10.1007/s11263-015-0816-y |
| **BibTeX** | <details><summary>📜 View BibTeX citation</summary><pre>@article{Russakovsky_2015,<br>  title     = {ImageNet Large Scale Visual Recognition Challenge},<br>  author    = {Russakovsky, Olga and Deng, Jia and Su, Hao and Krause, Jonathan and Satheesh, Sanjeev and Ma, Sean and Huang, Zhiheng and Karpathy, Andrej and Khosla, Aditya and Bernstein, Michael and Berg, Alexander C. and Fei-Fei, Li},<br>  journal   = {International Journal of Computer Vision},<br>  volume    = {115},<br>  number    = {3},<br>  pages     = {211--252},<br>  year      = {2015},<br>  publisher = {Springer},<br>  doi       = {10.1007/s11263-015-0816-y}<br>}</pre></details> |

## How to get access

1. **Accept the agreement.** Sign in at [https://image-net.org/](https://image-net.org/) and accept the ImageNet Terms of Access. Take a screenshot that shows you have accepted it.
2. **Send us a ticket** with the dataset name (`imagenet-1k-ILSVRC-2012`) and the screenshot attached, through one of these portals:
    - [RCAC support ticket](https://service.purdue.edu/TDClient/32/Purdue/Requests/TicketRequests/NewForm?ID=WT~8y8Nl8Ks_&RequestorType=ServiceOffering)
    - [ACCESS support ticket](https://support.access-ci.org/open-a-ticket)
    - [NAIRR support ticket](https://nairrpilot.org/open-support-request)

    Approval gives you read access to the files on Depot and Anvil. For S3 access you also need Anvil Object Storage access; if you do not have it yet, ask for it in the same ticket (see [Getting access to Object Storage](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/access/)).
3. **Use the files on the clusters.** After we approve your request, load the module and use the paths it sets (see [File system access](#file-system-access)). Before approval you will get "Permission denied".
4. **Or use S3.** Run `mykeys` on any Anvil login node to get your access key and secret key (see [Security and Access Control](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/acl/)), then use the endpoint and bucket below.

## File system access

| Cluster | Path |
|---------|------|
| **Depot** | `/depot/datasets/restricted_datasets/ai/imagenet-1k/imagenet-1k-ILSVRC-2012` |
| **Anvil** | `/anvil/datasets/restricted_datasets/ai/imagenet-1k/imagenet-1k-ILSVRC-2012` |

```bash
$ module load datasets
$ module load ai/imagenet-1k/imagenet-1k-ILSVRC-2012
```

The module sets `$imagenet_1k_ILSVRC_2012_HOME` and `$imagenet_1k_ILSVRC_2012_ROOTDIR` to the dataset folder, plus a variable for each subfolder and metadata file (run `module help ai/imagenet-1k/imagenet-1k-ILSVRC-2012` to see them).

## S3 access

| Parameter | Value |
|-----------|-------|
| **Endpoint** | `https://s3.anvil.rcac.purdue.edu` |
| **Bucket** | `restricted-ai-datasets` |
| **Path** | `s3://restricted-ai-datasets/imagenet-1k/imagenet-1k-ILSVRC-2012` |
| **Access** | Restricted: approved users only, with their own keys |

With rclone configured with your keys (see the [User Tools guide](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/usertools/)):

```bash
$ module load rclone
$ rclone lsd <your-remote>:restricted-ai-datasets/imagenet-1k/imagenet-1k-ILSVRC-2012
```

For more on object storage, see the [Anvil Object Storage documentation](https://docs.rcac.purdue.edu/userguides/anvil/objectstorage/). For other datasets, see [RCAC datasets](https://docs.rcac.purdue.edu/datasets/).
