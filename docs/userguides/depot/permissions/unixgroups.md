---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Storage Access Unix Groups

To enable a wide variety of access permissions, users are assigned one or more auxiliary Unix groups. It is the combination of this Unix group membership and the r/w/x permission bits on subdirectories that allow fine-tuning who can and cannot do what within specific areas of your Data Depot. These Unix groups will generally closely match the name of your Data Depot root directory and the name of the subdirectory to which write access is being given. For example, write access to `/depot/mylab/data/` is controlled by membership in the `mylab-data` Unix group.

There is also one Unix group which has the name of the base directory of your Data Depot, `mylab`. This group serves to limit read/execute access to your base `/depot/mylab/` directory and also helps to define the read/execute permissions of some of the subdirectories within. This Unix group is composed of the union of the following:

- all members of your more specific Unix groups
- all users authorized to access any of your research group's cluster queues
- any other specific individuals you may have approved

Research group faculty and their designees may directly manage membership in these Unix groups, and by extension, the storage access permissions they grant, through the online web application.

- [User Management](https://www.rcac.purdue.edu/account/groups)

## Checking Your Group Membership

As a user you can check which groups you are a member of by issuing the `groups` command while logged into any RCAC resource. You can also look on the website at [https://www.rcac.purdue.edu/account/groups](https://www.rcac.purdue.edu/account/groups).

```
$ groups
mylab mylab-apps mylab-data
```

If you have recently been added to a group you need to log out and then back in again before the permissions changes take effect.
