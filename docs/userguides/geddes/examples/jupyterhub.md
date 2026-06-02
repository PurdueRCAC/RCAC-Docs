---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Deploy JupyterHub

Guidelines for installing JupyterHub via Helm.

If you encounter errors related to privileges:

```
"message": "pods \"jupyter-username-xxxxx\" is forbidden: PodSecurityPolicy: unable to admit pod: [spec.initContainers[0].securityContext.privileged: Invalid value: true: Privileged containers are not allowed spec.initContainers[0].securityContext.capabilities.add: Invalid value: \"NET_ADMIN\": capability may not be added]",
```

add the following to your Helm values:

```
singleuser:
  cloudMetadata:
    blockWithIptables: false
```
