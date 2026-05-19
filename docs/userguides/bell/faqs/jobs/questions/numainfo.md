---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# How do I know Non-uniform Memory Access (NUMA) layout on Bell?

* You can learn about processor layout on Bell nodes using the following command:

  ```
  bell-a003:~$ lstopo-no-graphics
  ```

* For detailed IO connectivity:

  ```
  bell-a003:~$ lstopo-no-graphics --physical --whole-io
  ```
  
* Please note that NUMA information is useful for advanced MPI/OpenMP/GPU optimizations. For most users, using default NUMA settings in MPI or OpenMP would give you the best performance.
