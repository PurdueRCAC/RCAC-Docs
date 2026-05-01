whatis("invoke Gurobi 13.0.1")

-- for Tcl script use only
local version = "13.0.1"
local modroot = "/apps/external/gurobi/"..version

setenv("GUROBI_HOME",modroot)
setenv("GRB_LICENSE_FILE",modroot.."/licenses/gurobi.lic")

prepend_path("PATH",modroot.."/bin")
prepend_path("LD_LIBRARY_PATH",modroot.."/lib")
prepend_path("MATLABPATH",modroot.."/matlab")
