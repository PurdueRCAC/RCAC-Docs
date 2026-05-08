---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# I worked on ${resource.name} after I graduated/left Purdue, but can not access it anymore

### Problem

You have graduated or left Purdue but continue collaboration with your Purdue colleagues. You find that your access to Purdue resources has suddenly stopped and your password is no longer accepted.

### Solution

Access to all resources depends on having a valid Purdue Career Account. Expired Career Accounts are removed twice a year, during Spring and October breaks (more details at the [official page](https://www.purdue.edu/apps/account/IAMO/Purdue_CareerAccount_Expiration.jsp)). If your Career Account was purged due to expiration, you will not be be able to access the resources.

To provide remote collaborators with valid Purdue credentials, the University provides a special procedure called [Request for Privileges (R4P)](https://www.purdue.edu/apps/account/r4p). If you need to continue your collaboration with your Purdue PI, the PI will have to submit or renew an R4P request on your behalf.

After your R4P is completed and Career Account is restored, please note two additional necessary steps:

* **Access:** Restored Career Accounts by default do **not** have any RCAC resources enabled for them. **Your PI will have to login to the [Manage Users](/account/groups) tool and explicitly re-enable your access by un-checking and then ticking back checkboxes for desired queues/Unix groups resources.**
* **Email:** Restored Career Accounts by default do **not** have their *@purdue.edu* email service enabled. While this does not preclude you from using RCAC resources, any email messages (be that generated on the clusters, or any service announcements) would not be delivered - which may cause inconvenience or loss of compute jobs. To avoid this, we recommend setting your restored *@purdue.edu* email service to "Forward" (to an actual address you read). The easiest way to ensure it is to go through the [Account Setup process](https://www.purdue.edu/apps/account/AccountSetup).

{::if user.staff == 1}

### Staff Notes

1. Potentially confusing elements here are:

   * The error message looks like an incorrect password, because SSH does not divulge any indications about account validity.
   * The user still exists in our LDAP (so `ldapsearch` happily shows all the hosts).
   * The expired career account still exists in RCAC database (so [Manage Users](/account/groups) web tool happily shows the user with all the checkboxes in place).
2. Dead giveaway clues:

   * *"No role"* shows for all resources in the the [User Search tool](/admin/users/).
   * *"User not found"* in [Purdue Directory](https://www.purdue.edu/directory/).
3. **The *"uncheck, then check back"* trick is required**. Yes, for every queue and Unix group.

{::/}