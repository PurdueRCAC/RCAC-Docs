---
tags:
  - REED Folder
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Frequently Asked Questions

Frequently asked questions about REED Folder.

## About REED Folder

### What is a Box Managed Account and REED Folder?

A Box Managed account is your Purdue managed Box account. A REED folder is a project folder created in secure folder structured within Box.

### What do I need to do before I access my REED Folder?

- Anyone with access to data in scope of HIPAA must complete the required [HIPAA training](https://www.purdue.edu/legalcounsel/HIPAA/Training.html) annually. A PI is responsible to ensure the training is completed annually.
- Ensure you are using Purdue Login via the Duo client.
- For limited data sets, a Data Security Plan and Data Use Agreement will be required. This process should be started by [Sponsored Program Services](https://www.purdue.edu/business/sps/).
- Ensure you understand the following [policies and procedures](https://www.purdue.edu/legalcounsel/HIPAA/FormsProcedures.html) specific to HIPAA.
- If you are working with the [IRB](https://www.irb.purdue.edu/), ensure the process is completed prior to requesting access to REED Folder.

### Does Purdue have a Business Associate Agreement with Box?

Box supports the HIPAA and HITECH regulations, as well as the ability to sign HIPAA Business Associate Agreements (BAAs) with customers. Customers who are required by law to comply with HIPAA, such as HIPAA Covered Entities and HIPAA Business Associates, must have an Enterprise or Elite account with Box and sign a HIPAA Business Associate Agreement (BAA).

- Purdue University signed a Business Associate Agreement with Box, and Box accounts are Enterprise.
- Box provides the ability to use O365 online office application to open and work with content. Purdue University has signed a Business Associate Agreement with Microsoft.
- All other third-party service providers with our instance of Box Enterprise are not covered by a Business Associate Agreement (BAA).

Do not use third-party applications to process data considered Restricted via your Purdue managed Box account. Purdue University does not maintain a contractual agreement with the vendor, and the required security controls are not in place.

A Box Managed account is your Purdue managed Box account. A REED folder is a project folder created in secure folder structure within Box.

### Who should I contact for an IT incident?

- The incident should be reported as soon as it is discovered. Submit an incident request to abuse@purdue.edu
- If you lost a device, your account can be logged out using a Box admin feature. Submit an incident request to abuse@purdue.edu

## Data

### How do I host sensitive or restricted data in Box?

Storage of restricted data in Box is subject to review from Purdue's IT Security and Policy group (ITSP). Access may also require approval from campus offices and committees responsible for contractual compliance and research regulatory affairs.

Purdue's managed Box environment can be used to store, de-identified data and limited data sets in scope of HIPAA for research. Fully identified data is subject to a security review and approval process.

All restricted data must be stored in a REED Folder. Do not use Box for an actual medical practice.

See the data map below for more details:

![HIPAA data map](/assets/images/userguides/storage/hipaa-dm.png)

### Can I integrate 3rd-Party Apps with my Box folder?

While official Box add-on applications are approved for use with Purdue Box.com folders, third-party apps have not been reviewed for impact to security and are not approved for use until a security review has been completed by IT Security and Policy. If the official Box apps cannot provide the functionality you need, you may request a security review of the third-party app you are considering by submitting an email including the app name and the functionality you are addressing with the app to itpolicyreq@purdue.edu.

### How should I monitor access to my REED Folder?

The PI or Project Owner's should follow the recommendations below:

- Review Sharing tab monthly, to ensure only authorized people have access to the data
- Review the Access Stats on files deemed restricted periodically to ensure the actions taken are appropriate.
- Maintain a log of your actions, the log can be a spreadsheet or word document. The log should be stored outside of Box.

### Can I use Unmanaged Box accounts, and other Cloud Storage Options?

Unmanaged (free and commercial) Box accounts and all other Cloud Storage options are not approved for storing or sharing sensitive or restricted data. Purdue University does not maintain a contractual agreement with the vendor, and the required security controls are not in place. Personal use of cloud storage can continue, however sensitive and restricted data must not be stored in the account. The table below will help you determine where to store your data.

| Classification | Personal Box Folder | REED Folder |
| --- | --- | --- |
| Individually Identifiable Health Information | No | Determined by Review |
| Limited Data Set | No | Yes |
| De-Identified Data | No | Yes |
| De-Identified Data with Contractual Requirements | No | Yes |

### What is De-identified Data?

De-identified data is created by removing all 18 elements that could be used to identify the individual or the individual's relatives, employers, or household members; these elements are enumerated in the Privacy Rule. The covered entity also must have no actual knowledge that the remaining information could be used alone or in combination with other information to identify the individual who is the subject of the information. De-identified health information, as described in the Privacy Rule, is not PHI, and thus is not protected by the Privacy Rule however it could be subject to contractual requirements. Requests to store additional data types within scope of HIPAA should be sent to ITSP for review prior to uploading to Box Enterprise.

### Should I use Box Drive if I work with Restricted Data?

Currently, Box Drive is not recommended for use to work with restricted data. However, if you have a business need for Box Drive, contact IT Security and Policy so we can help you understand the risk and ensure you have the appropriate controls in place to protect the data.

### Will Box Drive or Box Edit cache files on the local machine?

Box Drive does locally cache files that you have opened. Box Drive's cache size limit is based on your free disk space (50% of available space) and has a maximum limit of 25 GB. If you reach this limit, Box Drive begins removing files, starting with those files that have gone the longest without your accessing them. Also, if a cached file has a new version created on Box, Box Drive discards the locally cached version. Do not open data in Box Drive containing restricted data. More details: [Technical Information for Box Drive Administrators](https://community.box.com/t5/Deploying-Managing-Box-Drive/Technical-Information-for-Box-Drive-Administrators/ta-p/37454)

Box Edit does download the file to a cache when you are modifying a file. The cache can be cleared. See: [Clear Your Box Edit Cache](https://support.box.com/hc/en-us/articles/360043695814-Clear-Your-Box-Edit-Cache)

### Can I use File Level Encryption with a REED Folder?

The data stored in REED folder is encrypted at rest, however file level encryption is a responsibility of the individual. Files can be encrypted prior to upload for added security measures. Do not use Windows EFS, the data will be uploaded without the encryption. Currently, we recommend using VeraCrypt.

### Can I use FTP to access Box?

No, FTP is disabled.

### What are the requirements for a laptop or desktop if I am working with Restricted data?

- Encrypt hard drive using Whole Disk Encryption for all drives in the system
- Must be a Purdue managed laptop or desktop
- Must have software security updates applied every 30 days
- Install anti-virus, anti-spyware software and ensure definitions are up to date and run regular scans; utilize an endpoint protection solution.
- Require re-authentication after 15 minutes of inactivity
- Enable host based firewall
- Ensure only authorized software on systems is accessing, transmitting, storing sensitive or restricted information
- Require Authentication from remote devices
- Disable bluetooth on machines unless otherwise required.
- Avoid the use of removable media unless required, in which case removable media must be encrypted.
- Require Administrator privileges to install applications.

### What is a Limited Data Set?

A limited data set is a separate legal concept under the privacy rule and is considered identifiable data. Specifically, a limited data set refers to PHI that has had the following 16 unique identifiers removed. A data use agreement is how covered entities obtain satisfactory assurances that the recipient of the limited data set will use or disclose the PHI in the data set only for specified purposes. A Data Use Agreement will continue to be required when working with limited data sets in Box.

### Should I move restricted data to other folders outside of a REED Folder?

When storing data within scope of HIPAA, if must be stored in a REED Folder:

- Do not move and or store the data in a folder hosted directly in your personal Box account.
- Do not store the data outside of REED Folder unless you moving the data to a HIPAA aligned system and you have received approval from Purdue's IT Security and Policy group (ITSP).
- Moving data may also require approval from campus offices and committees responsible for contractual compliance and research regulatory affairs.

### What are the folder naming conventions and folder description requirements for a REED Folder?

All folders and subfolders must follow a naming convention. The text must be added manually. The folder name must begin with [L3 HIPAA]-Folder Name. The naming convention should be used on any folder hosted in REED Folder. This is important, to allow for auditing of the service. All folders containing restricted data, must add a banner to the folder by using the Box folder description.

"The folder contains restricted data in scope of HIPAA. Exercise caution when sharing restricted or sensitive data, individuals must be authorized to access the data. Never sync restricted or sensitive data to an unauthorized system."

It best that you project team work from root folder of the project. If you create a collaboration in a sub folder, be certain you add the banner text and naming convention to ensure the project team knows the folder contains restricted data.

As a best practice, you can add [P1 Public] to folder names that don't contain restricted or sensitive data, this will help you managed the various data types you generate.

### Can I delete my files permanently from Box?

Individuals can delete a file or folder, and the item will be placed in the Trash. Individuals will not be able to permanently delete the items. An automated process is in place to remove data older than 90 days. Once the item is purged, it can't be recovered using the built in Box tools.

### What are the recommended permission levels?

| Role | Permission Level |
| --- | --- |
| Project Team member who needs full control | Editor |
| Project Team members who just needs to work within Box | Viewer Uploader |
| Project Team member who needs Read/Download access | Viewer |
| Partner who needs Read access | Previewer |
| Partner who need to upload data | Uploader |

## Login

### Can I manage my Login Activity in Box?

In Box under your account settings, click the "Security" tab. You can review and remove sessions.
