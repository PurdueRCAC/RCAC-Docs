# droid

[Back to AI datasets](../ai.md)

| Field | Value |
|--------|-------|
| **Description** | DROID (Distributed Robot Interaction Dataset) is a large-scale, open-source dataset for robot manipulation collected across diverse real-world environments. It comprises 76k demonstration trajectories (~350 hours of interaction) collected over 12 months using Franka Panda arms across 564 scenes and 86 tasks, supporting generalist robot policy training. |
| **Folder** | `/datasets/ai/droid` |
| **Discipline** | AI / Robotics / PhysicalAI |
| **DOI** | [10.15607/RSS.2024.XX.120](https://doi.org/10.15607/RSS.2024.XX.120) |
| **Link** | [Access Data](https://droid-dataset.github.io/) |
| **Public** | `True` |
| **Publication Date** | 2024 |
| **Downloaded** | 2026-07-10 |
| **Data Type** | TFRecords |
| **Dataset Size** | Approx. 1.7TB per version (v1.0.0, v1.0.1; 3.4TB total) |
| **Number of Files** | 76k trajectories, 2050 TFRecords |
| **Usage** | <pre>&#36; module avail<br>&#36; module load datasets<br>&#36; module load ai/droid/2024</pre> |
| **Usage Policy Link** | https://creativecommons.org/licenses/by/4.0/ |
| **Usage Policy** | Creative Commons Attribution 4.0 International (CC BY 4.0) |
| **Citation** | Khazatsky, A., Pertsch, K., Nair, S., Balakrishna, A., Dasari, S., Singh, S., et al. (2024). DROID: A Large-Scale In-The-Wild Robot Manipulation Dataset. In Proceedings of Robotics: Science and Systems (RSS 2024). |
| **BibTeX** | <details><summary>📜 View BibTeX citation</summary><pre>@inproceedings{Khazatsky-RSS-24,<br>  author    = {Alexander Khazatsky and Karl Pertsch and Suraj Nair and Ashwin Balakrishna and Sudeep Dasari and Siddharth Singh and Sicheng Liu and Anurag Ajay and Kota Kawaharazuka and Christian Zhang and others},<br>  title     = {DROID: A Large-Scale In-The-Wild Robot Manipulation Dataset},<br>  booktitle = {Proceedings of Robotics: Science and Systems (RSS)},<br>  year      = {2024},<br>  month     = {July},<br>  address   = {Delft, Netherlands},<br>  doi       = {10.15607/RSS.2024.XX.120},<br>  url       = {https://www.roboticsproceedings.org/rss20/p120.html}<br>}</pre></details> |

## Ceph access

This dataset is also available in raw/extracted form on RCAC Ceph/S3-compatible object storage.

| Parameter | Value |
|-----------|-------|
| **Endpoint** | `https://s3.anvil.rcac.purdue.edu` |
| **Bucket** | `ai-datasets` |
| **Access** | Public read-only |

For detailed instructions, see the [AI datasets overview](../ai.md).
