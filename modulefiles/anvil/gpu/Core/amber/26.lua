-- -*- lua -*---
-- amber/26.lua
help([[Amber26 pmemd - high-performance MD engine]])
whatis("Name: amber")
whatis("Version: 26")

depends_on('cuda/12.8.0')
depends_on('plumed/2.10.0')

local pmemd_root = "/apps/anvil/external/apps/amber/26/pmemd26"
setenv("PMEMDHOME", pmemd_root)
prepend_path("PATH", pathJoin(pmemd_root,"bin"))