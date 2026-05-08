---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Does ${resource.name} have the same home directory as other clusters?

The ${resource.name} home directory and its contents are exclusive to ${resource.name} cluster front-end hosts and compute nodes. This home directory is not available on other RCAC machines but ${resource.name}. There is no automatic copying or synchronization between home directories.

{::if resource.name != Weber}

At your discretion you can manually copy all or parts of your main research computing home to ${resource.name} using one of the [suggested methods](/knowledge/${resource.hostname}/storage/transfer/copyhome).

If you plan to use `hsi` or `htar` commands to access Fortress tape archive from ${resource.name}, please see also the [keytab generation question](/knowledge/${resource.hostname}/faq/data/transferkeytab) for a temporary workaround to a potential caveat, while a permanent mitigation is being developed.

{::/}