---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Does Bell have the same home directory as other clusters?

The Bell home directory and its contents are exclusive to Bell cluster front-end hosts and compute nodes. This home directory is not available on other RCAC machines but Bell. There is no automatic copying or synchronization between home directories.

At your discretion you can manually copy all or parts of your main research computing home to Bell using one of the [suggested methods](../../storage/transfer/copyhome.md).

If you plan to use `hsi` or `htar` commands to access Fortress tape archive from Bell, please see also the [keytab generation question](transferkeytab.md) for a temporary workaround to a potential caveat, while a permanent mitigation is being developed.
