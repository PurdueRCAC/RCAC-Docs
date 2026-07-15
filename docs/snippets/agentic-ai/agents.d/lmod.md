# Software Modules — Lmod (Gautschi)

Software on Gautschi is provided through **environment modules** (Lmod), not the
system package manager.

## Finding and loading software

- `module avail` — list available modules.
- `module spider <name>` — search for a package and see its versions and
  prerequisites.
- `module load <name>/<version>` — load a specific version; `(D)` marks the default.
- `module list` — show what is currently loaded; `module purge` clears everything.

Load the same modules inside your job scripts that you used interactively, so batch
jobs run in the environment you tested.

## Recommended toolchain

The recommended compiler and MPI stack is **GCC 14.1.0 with OpenMPI**. Check
`module avail` for the exact versions available.

## Prohibitions

- **Do NOT** install software with `apt`, `yum`, `dnf`, or `sudo` — you do not have
  root, and system package managers are not the mechanism here. Use modules, or install
  into user space.
- **Do NOT invent module names or versions.** Verify a package and version exist with
  `module spider` (or `module avail`) before claiming it is available or writing it
  into a job script.
- For Python, prefer the `anaconda` modules and user environments rather than modifying
  a base installation.
