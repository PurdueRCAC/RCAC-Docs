---
tags:
  - Gautschi
authors:
  - jin456
resource: Gautschi
search:
  boost: 2
---

Gautschi supports several methods for file sharing:

## Globus

Data on any RCAC resource can be shared with other users within Purdue or with collaborators at other institutions. Globus allows convenient sharing of data with outside collaborators. Data can be shared with collaborators' personal computers or directly with many other computing resources at other institutions.

To share files, login to [https://transfer.rcac.purdue.edu :octicons-link-external-16:](https://transfer.rcac.purdue.edu/), navigate to the endpoint (collection) of your choice, and follow instructions as described in Globus documentation on how to share data:

[https://docs.globus.org/how-to/share-files/ :octicons-link-external-16:](https://docs.globus.org/how-to/share-files/)

See also [RCAC Globus presentation :octicons-link-external-16:](https://rcac.purdue.edu/training/globus)

## WWW

Your research group can easily share static files (images, data, HTML) from your depot space via the WWW.

- Contact support to set up a "www" folder in your Data Depot space.
- Copy any files that you wish to share via the WWW into your Data Depot space's "www" folder.
- For example, ```cp /path/to/image.jpg /depot/mylab/www/```, where mylab is your research group name.
- or upload to ```smb://datadepot.rcac.purdue.edu/depot/mylab/www```, where mylab is your research group name.
- Your file is now accessible via your web browser at the URL ```https://www.datadepot.rcac.purdue.edu/mylab/image.jpg```

Note that it is not possible to run web sites, dynamic content, interpreters (PHP, Perl, Python), or CGI scripts from this web site.

[**Back to the Storage section**](../storage.md)