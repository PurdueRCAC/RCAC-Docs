-- -*- lua -*---
-- amber/26.lua
help([[Amber26 pmemd - high-performance MD engine]])
whatis("Name: amber")
whatis("Version: 26")

depends_on('cuda')
-- depends_on('plumed')

local pmemd_root = "/apps/anvil/external/apps/amber/26/pmemd26"
setenv("PMEMDHOME", pmemd_root)
prepend_path("PATH", pathJoin(pmemd_root,"bin"))