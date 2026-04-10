# Control Flow

Back to [Week 3](./index.md)

This page continues the Bash scripting tutorial by introducing **conditionals**, **loops**, and common control-flow patterns. These constructs allow scripts to make decisions, repeat tasks, and automate complex workflows.

---

In Bash, **commands return an exit code**:

* `0` → success (true)
*  non-zero → failure (false)

```bash
ls /tmp        # success → exit code 0
ls /nope       # failure → exit code != 0
```

You can check the last exit code with:

```bash
echo $?
```
This is the foundation for conditionals in shell scripts.


## Conditionals

### Basic `if`/`else` statements

```bash
if command; then
  echo "Command succeeded"
else
  echo "Command Failed!"
fi
```

---

## Test Expressions

| Test | Meaning |
|-----|--------|
| `-f file` | Regular file exists |
| `-d dir`  | Directory exists |
| `-e path` | Path exists |
| `-r file` | Readable |
| `-w file` | Writable |
| `-x file` | Executable |


```bash
if [[ -d "$SCRATCH" ]]; then
  echo "Scratch directory exists"
fi
```

### String Tests

| Test | Meaning |
|-----|--------|
| `-z str` | String is empty |
| `-n str` | String is not empty |
| `str1 == str2` | Equal |
| `str1 != str2` | Not equal |

```bash
if [[ -z "$1" ]]; then
  echo "Usage: $0 <filename>"
  exit 1
fi
```

### Numeric Comparisons

| Operator | Meaning |
|---------|--------|
| `-eq` | equal |
| `-ne` | not equal |
| `-lt` | less than |
| `-le` | less or equal |
| `-gt` | greater than |
| `-ge` | greater or equal |

```bash
if [[ "$N" -gt 10 ]]; then
  echo "Large job"
fi
```

### Logical Operators

| Operator | Meaning |
|---------|--------|
| `&&` | AND |
| `||` | OR |
| `!`  | NOT |

```bash
if [[ -f input.dat && -d /path/to/data ]]; then
  echo "Input file and Data directory present!"
fi
```


## Loops

### Basic For loop

```bash
for x in a b c; do
  echo "$x"
done
```

### Loop Over Files

```bash
for f in *.py; do
  echo "Processing $f"
  python $f
done
```

### Numeric Loop

```bash
for i in {1..5}; do
  echo "Iteration $i"
done
```

Alternatively,

```bash
for ((i=1; i<=5; i++)); do
  echo "$i"
done
```

---

### `while` Loops

While loops are also available in bash. Note that this example uses an expression to increment `count`.

```bash
count=0
while [ "$count" -lt 5 ]; do
  echo "$count"
  ((count++))
done
```

### Reading files with `while`

One of the most common uses of a while loop is using a file. Note that this example uses a `<` to read input from a file. We'll talk more about this in the [pipes](./pipes.md) section!

```bash
while read -r line; do
  echo "$line"
done < input.txt
```


## Examples

```bash
#!/bin/bash

if [[ -z "$SLURM_JOB_ID" ]]; then
  echo "Must be run inside Slurm"
  exit 1
fi

for gpu in $(nvidia-smi --query-gpu=index --format=csv,noheader); do
  echo "GPU $gpu active"
done

for input in $(ls -d ./replicate*); do 
  sbatch myjob.sub $input
  sleep 0.1
done
```

## Common Pitfalls

!!! warning
    * Spaces matter: `[ "$x" = 1 ]`, not `["$x"=1]`
    * Use quotes to avoid word splitting
    * Remember: `0` means *success*
    * If a command fails, bash will continue to move on through the script!


Next Section: [Pipes](./pipes.md)