---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Logging In

{::if resource.name == Negishi or resource.name == Gautschi}

To submit jobs on ${resource.name}, log in to the submission host `${resource.frontend}.rcac.purdue.edu` via SSH. This submission host is actually ${resource.frontends} front-end hosts: `login00.${resource.hostname}` through `login0${resource.frontends-1}.${resource.hostname}`. {::if resource.frontends > 1}The login process randomly assigns one of these front-ends to each login to `${resource.frontend}.rcac.purdue.edu`.

{::/} {::else}

To submit jobs on ${resource.name}, log in to the submission host `${resource.frontend}.rcac.purdue.edu` via SSH. {::if resource.frontends > 2} This submission host is actually ${resource.frontends} front-end hosts: `${resource.frontend}-fe00` through `${resource.frontend}-fe0${resource.frontends-1}` {::elseif resource.frontends == 2} This submission host is actually 2 front-end hosts: `${resource.frontend}-fe00` and `${resource.frontend}-fe01`. {::/} {::if resource.frontends > 1} The login process randomly assigns one of these front-ends to each login to `${resource.frontend}.rcac.purdue.edu`. {::/}

{::/} {::if resource.seq == 129}

To submit jobs on ${resource.name} front ends with local GPUs, log in to `${resource.gpu}.rcac.purdue.edu` via SSH.

{::/}