---
tags:
  - Geddes
authors:
  - jin456
  - goughes
search:
  boost: 2
---

# Refreshing Your Kubectl Token

Before starting, it's a good idea to make a mental note of your current token so that you can verify if the token regenerated correctly. Once logged into Rancher, you can navigate to the Geddes cluster using the top left drop down and view your current token using the top right **Kubeconfig File** button.

1. Log in to the Rancher UI at [geddes.rcac.purdue.edu](https://geddes.rcac.purdue.edu)
2. Use the top right user dropdown and navigate to **API & Keys**
3. Locate and check the box labeled **kubeconfig-u\***
4. Click delete
5. From here log out and back into Rancher and your token will be regenerated
6. Using the method outlined at the top of this section, verify that your token has regenerated
