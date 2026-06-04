whatis([[
        Description: ModuleTree or modtree helps users naviagate between different application stacks
        and sets up a default compiler and mpi environment.

	Note that by default, 'modtree' will initialize your environment with a default set of modules
	such as gcc and openmpi. If you want a different compiler/mpi environment or a different version,
	please load the relevant modules explicitly.

	The default gcc version in 'modtree/cpu' is 11.2.0. This has been selected to enable AMD Milan
	specific optimizations in the compiler.
	]])

local version = "20240922"
local app = "rcac"
local contact = "rcac-help"
local license_type = "null"

if (mode() == "load") then
   local current_modpath = os.getenv('MODULEPATH')
   if not string.find(current_modpath,'/opt/scholar-dgx-modulefiles/dgx') then
       setenv('MODULEPATH','/opt/scholar-dgx-modulefiles/dgx/Core')
   end
end

load("gcc/12.5.0")
load("openmpi/5.0.5")
load("cuda/13.1")