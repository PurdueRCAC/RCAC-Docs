---
title: Install perl libraries
tags:
  - Life Sciences
  - Guides
---

This guide explains how to install Perl modules in a non-system location (e.g., project or group directory) using `cpanm` and `local::lib`.
This is ideal for environments where you cannot modify system Perl without root access, such as on RCAC clusters (Gautschi, Negishi, Bell).

1.  **Create the required directory in your desired location (e.g., home or project space).**

    ```bash
    mkdir -p /depot/gcore/localperl
    cd /depot/gcore/localperl
    ```

    You can substitute this path to any location you want (`~` or even `$SCRATCH`) .

2.  **Set up the environment to install Perl modules locally:**

    ```bash
    nano /depot/gcore/localperl/env.sh
    ```

    Paste the following into `env.sh`:

    ```bash title="env.sh"
    export PERL_LOCAL_LIB_ROOT=/depot/gcore/localperl
    export PERL_MB_OPT="--install_base /depot/gcore/localperl"
    export PERL_MM_OPT="INSTALL_BASE=/depot/gcore/localperl"
    export PERL5LIB=/depot/gcore/localperl/lib/perl5:$PERL5LIB
    export PATH=/depot/gcore/localperl/bin:$PATH
    ```

    Then activate it:

    ```bash
    source /depot/gcore/localperl/env.sh
    ```

    !!! note
        You can check which Perl is in use and where it looks for libraries by running `which perl` and `perl -V` commands.
        Make sure it points to `/usr/bin/perl` and includes `/depot/gcore/localperl/lib/perl5` in `@INC` after activating your environment.

3.  **Install `cpanm` (Perl module installer) into the custom location:**

    !!! warning
        Make sure you've already run `source /depot/gcore/localperl/env.sh` before installing modules with `cpanm`, or they will be installed in the wrong location.

    ```bash
    curl -L https://cpanmin.us | perl - --local-lib=/depot/gcore/localperl App::cpanminus
    ```

    Confirm that it worked:

    ```bash
    which cpanm
    # should return: /depot/gcore/localperl/bin/cpanm
    ```

4.  **Install the required Perl modules:**

    ```bash
    cpanm DateTime namespace::autoclean Sub::Name \
          JSON Getopt::Long Pod::Usage JSON::XS Mojolicious
    ```

    You can add more modules as needed.

5.  **(Optional) Automatically load your environment in future sessions:**

    ```bash
    echo 'source /depot/gcore/localperl/env.sh' >> ~/.bashrc
    ```

    If you prefer not to modify your `~/.bashrc`, you can manually source the environment script each time you start a new session.

    !!! warning
        Remember to run `source /depot/gcore/localperl/env.sh` in any new shell before running scripts that depend on these local modules.

## Testing the installation

To verify that the installation was successful, you can run a simple Perl script that uses one of the installed modules:

```perl title="test_perl_modules.pl"
#!/usr/bin/perl
use strict;
use warnings;
use DateTime;
use JSON;

print "Local Perl modules are working!\n";
```

Run the script:

```bash
perl test_perl_modules.pl
```

If you see the message "Local Perl modules are working!", your installation is successful.

## FAQs

??? note "How can I get a list of all installed perl modules?"
    You can use the following command to list all installed Perl modules:

    ```bash
    perldoc perllocal
    ```

    or

    ```bash
    find /depot/gcore/localperl/lib/perl5 -name '*.pm'
    ```
