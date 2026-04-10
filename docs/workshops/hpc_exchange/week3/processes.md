# Managing Processes

[Back to Week 3](./index.md)

There are many things we can do to manage processes in the shell:

* Run more than one program by placing it in the background
* Query running processes
* Interrupt or re-attach to background processes
* Wait nicely for background processes to finish

To run programs in the background, add
a single trailing ampersand (`&`) to the
command.

```bash
$ sleep 600 &
[1] 1298141

$ echo "I still have control of my shell!"
I still have control of my shell!
```
Output from these "background-ed"
programs is still streamed to the shell.
But you can still interact with the
shell while the background processes
are going.

After the program is put in the
background, the shell tells you
two numbers. The first number is
the relative job ID,
relative to the number of child
processes. The second number is
the system process ID (PID).

You can check on your shell's
child processes with the `jobs`
program.
```
$ jobs
[1]+  Running      sleep 600 &
```
You can also check on ALL
running processes with the `ps`
command.
```
$ ps -u username
PID     TTY     TIME   CMD
221965 ?      00:00:00 systemd
221967 ?      00:00:00 (sd-pam)
221972 ?      00:00:00 sshd
221973 pts/10 00:00:00 bash
222170 pts/10 00:00:00 sleep
222182 pts/10 00:00:00 ps
```
<!-- Quiz: What does the `-u` option
do?

.. admonition:: Answer
   :collapsible: closed

   It restricts the output to only
   show jobs from that one user. -->

You can wait nicely for all jobs
in the background to complete with
the `wait` program. 

```bash
$ wait
```

You can also
re-attach to background processes
with the `fg` program. This code will bring the `sleep 600`
program back to the foreground and
will wait for it to finish before
giving you back control of the
command line.

```bash
$ sleep 600 &
[1] 1240872
$ fg
sleep 600
```

You can also use `ctrl+z` to pause a job actively running in the shell, and then `bg` to resume it in the background:

```bash
$ sleep 600
[ctrl+z]
[1]+  Stopped                 sleep 600
$ bg
[1]+ sleep 600 &
$ jobs
[1]+  Running                 sleep 600 &
```

Lastly, you
can interrupt processes with the
`kill` command (using `%` for the
relative PID).

```bash
$ sleep 600 &
[1] 222728

$ kill -s int %1
```

The `kill` program can technically
send *any* signal to a program (despite
its ominous name). In the example above,
we have sent the `int` signal to the
first child process. This interrupts
the process and tries to stop it.

!!! tip "Signals"
    The UNIX *signal interrupt* mechanism is an important concept to understand in software programming. You should know about the **SIGINT**, **SIGTERM**, and **SIGKILL** signals, which are all interrupt signals with increasing amounts of force to the program.

    Slurm understands signals and can send desired signals to your job script or steps at predefined times (e.g. 10 minutes before the walltime limit).

### Program reference

| Program | Action |
|---|---|
| `ps` | List all running processes |
| `jobs` | List running background child processes |
| `kill` | Send a signal to a processes (usually to stop) |
| `wait` | Wait for running background child processes to complete |
| `fg` | Reattach to background process |


Next section: [Managing Files and Directories](./files-directories.md)