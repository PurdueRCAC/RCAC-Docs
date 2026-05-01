help([[
OpenJDK 8
]])

whatis("Java 8 (OpenJDK)")

local root = "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.472.b08-2.el9_7.x86_64"

setenv("JAVA_HOME", root)
prepend_path("PATH", pathJoin(root, "jre", "bin"))