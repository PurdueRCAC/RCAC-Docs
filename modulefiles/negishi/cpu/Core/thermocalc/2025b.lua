whatis("invoke ThermoCalc-2025b")

help([[

To use TC-Python, you need to create an anaconda environment first. Please visit our user guide below for rcac-conda-env usage.

        https://www.rcac.purdue.edu/knowledge/brown/run/examples/apps/python/environment_example

Example commands to install TC_Python into your anaconda environment in $HOME.

        $ module load conda
        $ module load thermocalc/2025b

        $ conda-env-mod create -n tcpython
        $ module load use.own
        $ module load conda-env/tcpython-py3.12.11
        $ pip install $TC25B_HOME/SDK/TC-Python/TC_Python-2025.2-30-py3-none-any.whl




TC-Python user guide:

        https://www.thermocalc.com/media/55442/TC-Python-API-Programmer-Guide.pdf

]])

-- for Tcl script use only
local app = "thermocalc"
local version = "2025b"
local modroot = "/apps/external/apps/"..app.."/"..version

prepend_path("PATH",modroot)
setenv("TC25B_HOME",modroot)
setenv("TCPATH",modroot)

setenv("LSHOST","dock.ecn.purdue.edu")

if (mode() == "load") then
        LmodMessage('Run ThermoCalc with command "Thermo-Calc.sh".')
end
