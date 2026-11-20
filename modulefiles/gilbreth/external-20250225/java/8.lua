help([[
OpenJDK 8 (headless JRE, no javac)
]])

whatis("Java 8 (OpenJDK headless JRE)")

-- Unversioned alternatives symlink; survives openjdk package updates
local root = "/usr/lib/jvm/jre-1.8.0"

if not isDir(root) then
  LmodError("java/8: ", root, " not found. Please report to rcac-help.\n")
end

setenv("JAVA_HOME", root)
prepend_path("PATH", pathJoin(root, "bin"))
