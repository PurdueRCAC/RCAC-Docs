---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# How do I know Non-uniform Memory Access (NUMA) layout on ${resource.name}?

* You can learn about processor layout on ${resource.name} nodes using the following command:

  ```
  {::if resource.nodashnames == true}a003.${resource.hostname}{::else}${resource.hostname}-a003{::/}:~$ lstopo-no-graphics
  ```
* For detailed IO connectivity:

  ```
  {::if resource.nodashnames == true}a003.${resource.hostname}{::else}${resource.hostname}-a003{::/}:~$ lstopo-no-graphics --physical --whole-io
  ```
* Please note that NUMA information is useful for advanced MPI/OpenMP/GPU optimizations. For most users, using default NUMA settings in MPI or OpenMP would give you the best performance.