local appname = "hypershell"
local version = "develop"
local appsdir = "/apps/external"
local modroot = pathJoin(appsdir, appname, version)

whatis("Name: HyperShell")
whatis("Version: " .. version)
whatis([[Description:
A cross-platform, high-throughput computing utility for processing
shell commands over a distributed, asynchronous queue.]])

prepend_path("PATH", pathJoin(modroot, "bin"))
prepend_path("MANPATH", pathJoin(modroot, "share", "man"))
prepend_path("HYPERSHELL_PYTHONPATH", pathJoin(modroot, "frozen-python.path"))

if myShellName() == "bash" then
	source_sh("bash", pathJoin(modroot, "share", "bash_completion.d", "hs"))
elseif myShellName() == "zsh" then
	prepend_path("FPATH", pathJoin(modroot, "share", "zsh", "site-functions"))
	execute({ cmd = "autoload -Uz compinit && compinit", modeA = { "load" } })
end
