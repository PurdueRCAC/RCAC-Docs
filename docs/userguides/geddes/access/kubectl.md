---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Kubectl

## Configuring local kubectl access with a Kubeconfig file

**kubectl** can be installed and run on your local machine
to perform various actions against the Kubernetes cluster using the API server.

These tools authenticate to Kubernetes using information stored in a
[**kubeconfig**](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) file.

!!! note
    A file that is used to configure access to a cluster is sometimes
    called a *kubeconfig* file. This is a generic way of referring to configuration
    files. It does not mean that there is a file named **kubeconfig**.

To begin accessing Geddes via **kubectl** you must first gather your rancher generated **Kubeconfig** file and set up your local `.kube` directory.

1. From anywhere in the Rancher UI navigate to the top right and click on either **Download KubeConfig** or **Copy KubeConfig to Clipboard**
   * Create a directory in your home directory (`$HOME`) called `.kube`
   * Change into the newly created directory and copy the file or contents of **KubeConfig** from earlier into a file called **config**
2. Test connections to the Geddes cluster
   * To look at the current config settings we just set use `kubectl config view`
   * Now let’s list the available resource types present in the API with `kubectl api-resources`

To see more options of kubectl, review the [Kubernetes' kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).

## Accessing kubectl in the Rancher web UI

You can launch a kubectl command window from within the Rancher UI by selecting
the **Kubectl Shell** button at the top right or using the hotkey (`` CTRL + ` ``).
This will deploy a container in the cluster with kubectl installed and give you
an interactive window to use the command from.
