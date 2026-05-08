---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# How is my Data Secured on ${resource.name}?

{::if resource.name != Weber}

${resource.name} is operated in line with policies, standards, and best practices as described within [Secure Purdue](https://www.purdue.edu/securepurdue), and specific to [RCAC Resources](/policies).

Security controls for ${resource.name} are based on ones defined in NIST cybersecurity standards.

${resource.name} supports research at the L1 fundamental and L2 sensitive levels.
${resource.name} is not approved for storing data at the L3 restricted (covered by HIPAA) or L4 Export Controlled (ITAR), or any Controlled Unclassified Information (CUI).

For resources designed to support research with heightened security requirements, please look for resources within the [REED+ Ecosystem](/services/reedplus).

{::else}

${resource.name} is operated in line with policies, standards, and best practices as described within [Secure Purdue](https://www.purdue.edu/securepurdue), and specific to [RCAC Resources](/policies). In addition, L4 Export Controlled (ITAR) or Controlled Unclassfied Information (CUI) stored within ${resource.name} are compliant with EAR, ITAR, or NIST SP 800-171 regulations.

{::/}
{::if user.username != myusername}

### High Level Data Security Diagram

![System Security Diagram](/resources/${resource.hostname}/secdiagram.png)

### Notes on Data Security Configuration

* Only research groups that have purchased access may access ${resource.name}.
* All access to ${resource.name} is through [Purdue Career Accounts](https://www.purdue.edu/securepurdue/iamoServices/index.php), managed by Purdue's identity and access management office.
* Scratch storage on ${resource.name} is private only to the individual user, using POSIX file permissions.
* Scratch storage on ${resource.name} is not encrypted at rest or in flight.
* Scratch storage on ${resource.name} is not backed up. We recommend using Fortress and the Data Depot as part of your lab's data management strategy.
* Access to the PI's Data Depot space is only possible from HPC systems, or with the use of the Purdue VPN.
* Access to the PI's Data Depot space is directly controlled by the PI via UNIX groups, POSIX file permissions and ACLs.
* [Globus](https://transfer.rcac.purdue.edu) is provided as a tool for secure, high-performance file transfer and sharing.
* All compute nodes on ${resource.name} are firewalled and accessible only from within the boundaries of research computing resources.
* Access to a compute node is limited to the specific user assigned to the node via the job scheduler. No more than 1 user may access any one compute node at a time.
* The Purdue research network is monitored with an intrustion detection system.
* Purdue system administrators use two-factor authentication for administrative access to research systems.
* All research systems are manged with version control, configuration management software and patched at regular intervals.
* Usage, access, system, and application data is centrally logged and reviewed.
* Physical access to data center facilties is restricted by swipe card access to data center and systems staff.

{::else}

### For additional information

[Log in](/login) with your Purdue Career Account.

{::/}