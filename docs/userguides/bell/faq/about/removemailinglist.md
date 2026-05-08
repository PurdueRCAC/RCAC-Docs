---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Can you remove me from the ${resource.name} mailing list?

{::if resource.name == Anvil }

Your subscription in the ${resource.name} mailing list is tied to your account on ${resource.name} which was granted to you through an ACCESS allocation. If you are no longer using your account on ${resource.name}, you can contact your PI or allocation manager to remove you from their ${resource.name} allocation.

{::else}

Your subscription in the ${resource.name} mailing list is tied to your account on ${resource.name}. If you are no longer using your account on ${resource.name}, your account can be deleted from the [My Accounts](/account/myinfo) page. Hover over the resource you wish to remove yourself from and click the red 'X' button. Your account and mailing list subscription will be removed overnight. Be sure to make a copy of any data you wish to keep first.

{::/} {::if user.staff == 1}

### Staff Notes

If someone is asking to remove them from the Fortress list, they can do so from the above link or we can do it ourselves. Search the user from [Search Users](/admin/users), select the edit icon next to their Fortress entry. Find them in the long list and remove them.

{::/}