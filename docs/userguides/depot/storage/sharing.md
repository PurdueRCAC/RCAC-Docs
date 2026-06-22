---
tags:
  - Data Depot
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Sharing

Data Depot supports several methods for file sharing.

## Globus

--8<-- "docs/snippets/sharing_globus.md"

## WWW

Your research group can easily share static files (images, data, HTML) from your depot space via the WWW.

- [Contact support](mailto:rcac-help@purdue.edu) to set up a "www" folder in your Data Depot space.
- Copy any files that you wish to share via the WWW into your Data Depot space's "www" folder.
    - For example, `cp /path/to/image.jpg /depot/mylab/www/`, where `mylab` is your research group name.
    - Or upload to `smb://datadepot.rcac.purdue.edu/depot/mylab/www`, where `mylab` is your research group name.
- Your file is now accessible via your web browser at the URL `https://www.datadepot.rcac.purdue.edu/mylab/image.jpg`.

Note that it is not possible to run web sites, dynamic content, interpreters (PHP, Perl, Python), or CGI scripts from this web site.
