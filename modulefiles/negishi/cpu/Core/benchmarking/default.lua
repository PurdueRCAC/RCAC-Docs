local app = "benchmarking"
local version = "null"
local contact = "rderue"
local license_type = "null	"

whatis("This module enables a collection of benchmark applications alongside sample input.")

help([[
        biocontainers - Load this first to make benchmark application modules available.
]])

-- All set
prepend_path("MODULEPATH", "/opt/spack/benchmarks")

