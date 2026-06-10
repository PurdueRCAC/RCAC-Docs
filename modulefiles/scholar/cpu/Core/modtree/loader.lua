-- Load modtree based on architechture

local arch = capture("uname -m"):gsub("%s+", "")

if arch == "x86_64" then
    -- load x86 modtree
    setenv('RCAC_SPACK_MODROOT', '/opt/spack/modulefiles')
    setenv('MODULEPATH','/opt/spack/modulefiles/Core')
    -- load modtree/all
    load("modtree/all") -- rcac module aliases to this from rc file
elseif arch == "aarch64" then
   -- load aarch64 modtree
    setenv('RCAC_SPACK_MODROOT', '/opt/scholar-dgx-modulefiles/dgx')
    setenv('MODULEPATH','/opt/scholar-dgx-modulefiles/dgx/Core')
    -- load modtree/spark
    load("modtree/spark")
end