# Command reference and Practice
[Back to Week 1](./index.md)

## Command Reference

| Command | Description |
|--------|-------------|
| `pwd`  | Prints the current working directory |
| `ls`   | Lists the contents of a directory |
| `cd`   | Changes the current working directory |
| `man`  | Shows the manual page for the specified program |
| `mkdir`| Makes directories |
| `nano` | Opens the `nano` command-line editor |
| `vim`  | Opens the `vim` command-line editor |
| `mv`   | Moves or renames files and directories |
| `cp`   | Copies files and directories |
| `rm`   | **PERMANENTLY** deletes files and directories |

## Practice

> Tip: If you get stuck, use `man <command>` or `--help` to explore command options.

### Exercise 1


1) Open a terminal and make  a directory on your Desktop called "`practice1`"

??? tip "solution"
     ```bash
     [~]$ mkdir ~/Desktop/practice1
     ```

2) Change your directory to `practice1`, and print your directory.
??? tip "solution"
     ```bash
     [~]$ cd ~/Desktop/practice1
     [~/Desktop/practice1]$ pwd
     /home/username/Desktop/practice1
     ```

3) Create a file called `test1.txt` in the `practice1` containing the text "This is super important!" using `vim` or `nano`

??? tip "solution"
     ```bash
     [~/Desktop/practice1]$ vim test1.txt
     ```

     * `a` to enter insert mode
     * `This is super important!`
     * `esc` to exit insert mode
     * `:wq` + `enter` to write and quit 


4) Create another file called `test2.txt` with the text  "This is not important" in the `practice1` folder.

??? tip "solution"
     ```bash
     [~/Desktop/practice1]$ vim test2.txt
     ```

     * `a` to enter insert mode
     * `This is not important`
     * `esc` to exit insert mode
     * `:wq` + `enter` to write and quit 


5) Without changing directories, make a different folder on your desktop called `practice2`, and copy both of your text files into that folder. 

??? tip "solution"
     ```bash
     [~/Desktop/practice1]$ mkdir ../practice2
     [~/Desktop/practice1]$ cp *.txt ../practice2
     ```

6) Now change directories into practice2, and rename `test1.txt` to a file called `.hidden`.

??? tip "solution"
     ```bash
     [~/Desktop/practice1]$ cd ../practice2
     [~/Desktop/practice2]$ mv test1.txt .hidden
     ```

7) List *all* of the files in this folder, and show their permissions


??? tip "solution"
     ```bash
     [~/Desktop/practice2]$ ls -la
     drwxrwxr-x 2 username groupname 4096 Jan 29 14:23 .
     drwxr-xr-x 7 username groupname 4096 Jan 29 14:21 ..
     -rw-rw-r-- 1 username groupname   25 Jan 29 14:23 .hidden
     -rw-rw-r-- 1 username groupname   22 Jan 29 14:23 test2.txt
     ```


7) Switch back to `practice1` using the shortcut for "previous working directory"

??? tip "solution"
     ```bash
     [~/Desktop/practice2]$ cd -
     
     ```

8) In a single command, move the entire `practice2` directory *into* `practice1`

??? tip "solution"
     ```bash
     [~/Desktop/practice1]$ mv ../practice2 .
     ```

9) move back to your desktop using the notation for "parent directory"

??? tip "solution"
     ```bash
     [~/Desktop/practice1]$ cd ..
     [~/Desktop]$
     ```

10) remove the `practice1` directory, and show the files that are being removed.

??? tip "solution"
     ```bash
     [~/Desktop]$ rm -r --verbose ./practice1
     ```

<!-- ### Exercise 2 -->








Continue to [Week 2](../week2/index.md)