--
-- Pelican v7.25.0 modulefile
--
-- "URL: https://pelicanplatform.org"
-- "Category: Data Federation"
-- "Description: Pelican is an open-source software platform for building data federations that works by connecting a broad range of data repositories under a unified architecture. Whether data lives on a POSIX filesystem, in S3, or behind an HTTP server, Pelican aims to bring this data together and simplify its access by abstracting away the need to know where it comes from."
-- "Keywords: data federation"

whatis("Name: Pelican")
whatis("Version: 7.25.0")
whatis("Category: Data Federation")
whatis("URL: https://pelicanplatform.org")
whatis("Description: Pelican is an open-source software platform for building data federations that works by connecting a broad range of data repositories under a unified architecture. Whether data lives on a POSIX filesystem, in S3, or behind an HTTP server, Pelican aims to bring this data together and simplify its access by abstracting away the need to know where it comes from.")

help([[Pelican 7.25.0
-------------

Description
-------------
Pelican is an open-source software platform for building data federations that works by connecting a broad range of data repositories under a unified architecture.

Whether data lives on a POSIX filesystem, in S3, or behind an HTTP server, Pelican aims to bring this data together and simplify its access by abstracting away the need to know where it comes from.

]])

local package = "Pelican"
local version = "7.25.0"
local base    = pathJoin("/apps/anvil/external/apps/pelican/")
local ver_base = pathJoin(base,version)

prepend_path("PATH",ver_base)





