---
title: Year-End Productivity Toolkit
tags:
  - Life Sciences
  - Guides
---

# Year-End Productivity Toolkit


### 1. Zero-Friction Access

#### A. SSH Keys
**Goal:** Enable password-less login to run automated scripts and transfer files seamlessly.

1. **Generate a Key Pair**

    Run this on your **local computer** (Terminal or PowerShell). Press `Enter` to accept defaults (file location and no passphrase).

    ```bash
    ssh-keygen -t ed25519
    ```

2. **Copy Public Key to Cluster**

    Send your public key to the cluster. Replace `boilerid` with your actual username.

    !!! tip "Duo Auth Tip"
        When prompted for your password, type your password followed by `,push` (e.g., `password,push`) to approve the Duo request.

    === "Mac / Linux / Git Bash"

        ```bash
        ssh-copy-id boilerid@bell.rcac.purdue.edu
        ```

    === "Windows (PowerShell)"

        ```powershell
        type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh boilerid@bell.rcac.purdue.edu "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
        ```

3. **Test Connection**

    You should now be able to log in without typing a password:

    ```bash
    ssh boilerid@bell.rcac.purdue.edu
    ```


#### B. SSH Configuration

**Goal:** Simplify login commands (e.g., type `ssh bell` instead of `ssh user@bell.rcac.purdue.edu`).

1. **Create/Edit the Config File**

    Open `~/.ssh/config` on your local computer using a text editor (VS Code, Nano, Notepad, etc.).

2. **Paste the Configuration**

    Copy the block below. Be sure to replace `boilerid` with your specific username.

    ```bash title="~/.ssh/config"
    # --- GLOBAL RCAC DEFAULTS ---
    # Applies to all RCAC clusters automatically
    Host *.rcac.purdue.edu
        User boilerid                 # <--- REPLACE THIS with your username
        IdentityFile ~/.ssh/id_ed25519
        Port 22
        ForwardAgent yes
        ForwardX11 yes

        # Keep connection alive to prevent timeouts
        ServerAliveInterval 300
        ServerAliveCountMax 2

        # Multiplexing & Persistence (Speed boost for multiple windows)
        ControlMaster auto
        ControlPath ~/.ssh/cm-%r@%h:%p
        ControlPersist 10m

    # --- CLUSTER SHORTCUTS ---

    Host bell
        HostName bell.rcac.purdue.edu

    Host negishi
        HostName negishi.rcac.purdue.edu

    Host anvil
        HostName anvil.rcac.purdue.edu
        # User x-boilerid           # Uncomment and update if Anvil username differs
    ```

3. **Usage**

    You can now connect instantly using the short names:

    ```bash
    ssh bell
    ssh negishi
    ssh anvil
    rsync -av ~/localfolder/ bell:/depot/project/remote_folder/
    ```

### 2. Shell Aliases & Dotfiles

**Goal:** Save keystrokes on repetitive commands and prevent home directory quota issues.

#### A. The Setup

Instead of cluttering your main `.bashrc` file, create a separate file for shortcuts.

1. **Create the file:**

    ```bash
    nano ~/.bash_aliases
    ```

2. **Paste the content below** (Customize the `APPTAINER_CACHEDIR` path!).

3. **Activate it:**

    Open your `.bashrc` (`nano ~/.bashrc`) and ensure this block exists (it usually does by default):

    ```bash
    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi
    ```

4. **Reload:**

    Run `source ~/.bashrc` to apply changes immediately.

#### B. Recommended Aliases

Copy this into your `~/.bash_aliases` file.

```bash title="~/.bash_aliases"
# --- 1. ENVIRONMENT VARIABLES ---
# CRITICAL: Point Apptainer cache to Depot/Scratch to avoid filling up Home
export APPTAINER_CACHEDIR="/depot/itap/$USER/apptainer"

# --- 2. LISTING & NAVIGATION ---
alias pwd='pwd -P'                # Show physical path (resolves symlinks)
alias ls='ls --color=auto -v'     # Colorized output
alias ll='ls -l'                  # Standard long list
alias la='ls -Al'                 # Show hidden files
alias lt='ls -ltr'                # Sort by date (newest at bottom) - GREAT for checking logs
alias lk='ls -lSr'                # Sort by size (biggest at bottom)
alias ld='ls -d */'               # List directories only

# Advanced Listing (Requires 'exa' if you use 'lr')
# alias lr='exa --long --color-scale --tree --level=3'

# --- 3. DISK USAGE ---
alias du='du -kh'                 # Human readable sizes
alias dd='du -sch *'              # Summary of current directory sizes

# --- 4. SAFETY ---
alias rm='rm -i'                  # Ask before deleting
alias cp='cp -i'                  # Ask before overwriting
alias mv='mv -i'                  # Ask before overwriting

# --- 5. SLURM (JOB MANAGEMENT) ---

# Check MY jobs (Formatted for readability)
alias myq='squeue -o "%12i %20j %2t %8u %10q %10a %10P %10Q %5D %5C %11l %11L %R" -u $USER'

# Check ALL jobs
alias qs='squeue -a -o "%12i %20j %2t %8u %10q %10a %10P %10Q %5D %5C %11l %11L %R"'

# Check Node Status (Idle, Mixed, Allocated, etc.)
alias ql='sinfo -o "%20P %5D %14F %8z %10m %10d %11l %N"'

# Quick Interactive Job (Customize allocation/time as needed)
alias interact='sinteractive -A <YOUR_ALLOCATION> -t 04:00:00 -N 1 -n 16'
```

#### C. Dotfiles Management

Version control your configuration to keep clusters and local machines in sync.

1. Create a **private** GitHub repository named `dotfiles`.

2. Move your config files there and symlink them back.

    ```bash
    # Example workflow
    mkdir ~/dotfiles
    mv ~/.bash_aliases ~/dotfiles/
    ln -s ~/dotfiles/.bash_aliases ~/.bash_aliases
    ```


### 3. VS Code Remote SSH

**Goal:** Edit cluster files with a full graphical interface, syntax highlighting, and integrated terminals.

**Setup Steps**

1. **Install:** Download [VS Code](https://code.visualstudio.com/) locally.

2. **Extension:** Open VS Code, go to Extensions (square icon on left), and install **Remote - SSH**.

3. **Connect:** Click the green **"><"** icon (bottom-left corner) -> **Connect to Host...** -> Select `bell` (or your target cluster).

**Essential Extensions (Install on Remote)**
Once connected, install these in the "SSH: bell" section of your extensions pane:

<div class="grid cards" markdown>

-   :material-language-python: **Python & Pylance**

    ---

    For code completion and debugging.

-   :material-bash: **ShellCheck**

    ---

    To catch errors in your bash scripts automatically.

-   :material-git: **GitLens**

    ---

    To visualize who edited code and when.

-   :material-language-r: **R**

    ---

    For R language support (requires extra config).

</div>

**Editing Tips**

  * **Integrated Terminal:** Press `Ctrl + `` to open a terminal. It opens automatically in your current remote folder.
  * **Consistency:** If your config uses a specific node (e.g., `bell-fe02`), stick to it. Connecting to different nodes launches multiple VS Code server instances, which wastes resources.
  * **Drag & Drop:** Drag files from your local computer into the VS Code file explorer to upload them instantly.

!!! note "Reference"
    **[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/vscode-remote-ssh.pdf)** *Includes configurations for Jupyter Kernels and R paths.*



### 4. Conda Environment Management

**Goal:** Isolate software dependencies per project and avoid "works on my machine" issues.

**Setup: Avoid Quota Issues**
Conda environments are large. Configure them to store data in your Depot space, not your Home directory (which has strict limits).

1. Create the directory: `mkdir -p /depot/your_lab/user/conda_envs`

2. Edit your config: `nano ~/.condarc`

3. Add this text:

    ```yaml title="~/.condarc"
    envs_dirs:
      - /depot/your_lab/user/conda_envs
      - ~/.conda/envs
    pkgs_dirs:
      - /depot/your_lab/user/conda_pkgs
      - ~/.conda/pkgs
    ```

**Quick Commands (Use `mamba` for speed)**
The RCAC conda module includes `mamba`, which is faster than standard conda.

| Action | Command |
| :--- | :--- |
| **Start** | `module load conda` |
| **Create** | `mamba create -n my_env python=3.10` |
| **Activate** | `conda activate my_env` |
| **Install** | `mamba install bioconda::samtools` |
| **List Envs** | `conda env list` |
| **Remove** | `conda env remove -n my_env` |

**Reproducibility: The "Time Capsule"**
Before you finish a project, save a snapshot of your environment. This guarantees reproducibility.

1. **Export (Save):**

    ```bash
    # Saves only the packages you explicitly asked for (cleaner)
    conda env export --from-history > environment.yml

    # Saves EXACT versions of everything (safest for immediate reproduction)
    conda list --explicit > spec.txt
    ```

2. **Import (Load):**

    ```bash
    mamba env create -f environment.yml
    ```

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/RCAC_conda-package-management.pdf)** *Includes visual workflows for creating vs. using environments and version pinning examples.*


### 5. Containers & Overlays

**Goal:** Use software that runs the same way everywhere, without installation headaches or file quota (inode) issues.

**Why Apptainer (Singularity)?**

  * **Speed:** A container is a single file (`.sif`). It loads faster than a Conda environment with 30,000 tiny files.
  * **Portability:** Build it on your laptop, run it on Bell, run it on Anvil. It always works.

**Quick Commands**

```bash
# Pull a container from Docker Hub
apptainer pull fastqc.sif docker://biocontainers/fastqc:v0.11.9_cv8

# Run a tool inside the container
apptainer exec fastqc.sif fastqc input.fq

# Run on GPU (Bell/Gilbreth only)
apptainer exec --nv deepvariant.sif run_deepvariant ...
```

**The "Inode Saver" (Overlays)**

!!! tip "Use Overlays for High File Counts"
    Some tools (like `maker` or `trinity`) create millions of small temporary files, which hits your file count limit (quota) even if you have storage space left.

    **Solution:** Create an overlay file. The tool writes its temp files *inside* this single file, hiding them from the file system.

```bash
# 1. Create a 5GB overlay file
apptainer overlay create --size 5120 my_overlay.img

# 2. Run your tool with the overlay attached
apptainer exec --overlay my_overlay.img maker.sif maker ...
```

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/RCAC_apptainers-for-software-management.pdf)** *Includes recipes for building your own containers and advanced bind-mount usage.*



### 6. Custom Bin Directory

**Goal:** Standardize your tools and run complex commands with a single word.

**Setup**

1. Create the directory: `mkdir -p ~/bin`

2. Add to your `$PATH` (if not already there):

    ```bash
    # Add this to your ~/.bashrc
    export PATH="$HOME/bin:$PATH"
    ```

3. Reload: `source ~/.bashrc`

**Recommended Wrapper Scripts**
*Save these files in `~/bin`, then run `chmod +x ~/bin/*` to make them executable.*

=== "sam2bam"

    #### The "Sam to Sorted Bam" Converter
    Converts SAM to BAM, sorts it, and indexes it in one go.

    ```bash title="~/bin/sam2bam"
    #!/bin/bash
    # Usage: sam2bam input.sam
    # Output: input.sorted.bam and input.sorted.bam.bai

    if [ -z "$1" ]; then
        echo "Usage: sam2bam <input.sam>"
        exit 1
    fi

    BASE="${1%.sam}"
    THREADS=4

    echo "Converting $1 -> $BASE.sorted.bam..."

    # Pipe view directly to sort to save disk I/O
    samtools view -uS -@ $THREADS "$1" | \
    samtools sort -@ $THREADS -o "$BASE.sorted.bam"

    # Index immediately
    samtools index "$BASE.sorted.bam"
    echo "Done."
    ```

=== "run_bwa"

    #### The BWA-MEM Wrapper
    Runs BWA from a container without needing to load modules or remember the container path.

    ```bash title="~/bin/run_bwa"
    #!/bin/bash
    # Usage: run_bwa <ref.fa> <read1.fq> <read2.fq>
    # Output: read1.sam

    CONTAINER="/depot/itap/biocontainers/bwa.sif" # Update with your path
    REF=$1
    R1=$2
    R2=$3
    THREADS=12

    if [ -z "$3" ]; then
        echo "Usage: run_bwa <ref.fa> <r1.fq> <r2.fq>"
        exit 1
    fi

    OUTPUT="$(basename ${R1%.*}.sam)"

    echo "Running BWA MEM with $THREADS threads..."
    apptainer exec $CONTAINER bwa mem -t $THREADS "$REF" "$R1" "$R2" > "$OUTPUT"
    ```

=== "bsort"

    #### Fast BAM Sort
    Quickly sort a BAM file using available threads.

    ```bash title="~/bin/bsort"
    #!/bin/bash
    # Usage: bsort input.bam

    if [ -z "$1" ]; then
        echo "Usage: bsort <input.bam>"
        exit 1
    fi

    BASE="${1%.bam}"
    THREADS=8

    samtools sort -@ $THREADS -o "$BASE.sorted.bam" "$1"
    samtools index "$BASE.sorted.bam"
    ```

=== "fqcount"

    #### Read Counter
    Quickly checks read counts in gzipped files (useful for verifying transfers).

    ```bash title="~/bin/fqcount"
    #!/bin/bash
    # Usage: fqcount file.fastq.gz

    zcat "$1" | echo "$1: $(( $(wc -l) / 4 )) reads"
    ```

**[Full Collection of Scripts](https://github.com/ISUgenomics/common_scripts)**

### 7. Organizing Projects

**Goal:** Structure your data and code so that collaborators (and "Future You") can understand and reproduce your work.

**The "Standard" Directory Tree**
Adopt this structure for every new experiment to keep things consistent.

```text
YYYYMMDD_ProjectName/
├── 00_meta/
│   ├── README
│   ├── notes
│   └── methods.md
├── 01_data/
│   ├── raw/          # Read-only! (FASTQ, reference genomes)
│   └── processed/    # Cleaned data (trimmed reads)
├── 02_scripts/
│   ├── 01_qc.sh
│   └── 02_mapping.sh
├── 03_analysis/      # INTERMEDIATE FILES (BAMs, VCFs)
├── 04_results/       # FINAL OUTPUTS (Figures, Tables for paper)
└── 99_logs/          # Slurm output and error logs
```

**Best Practices**

  * **Raw Data is Sacred:** Never write to `01_data/raw`. Treat it as read-only.
  * **Number Your Scripts:** Name them in execution order (e.g., `01_qc`, `02_align`, `03_call_variants`).
  * **No Spaces:** Use underscores or hyphens in file names (e.g., `Airway_Study`, not `Airway Study`).
  * **Relative Paths:** Write scripts that reference `../01_data` rather than `/scratch/bell/user/project/...` so the folder is portable.

**Version Control (Git)**
Track your `02_scripts` folder, but **ignore** large data files.

```bash
# 1. Start tracking
cd 02_scripts
git init

# 2. Save changes
git add *.sh
git commit -m "Added alignment script"

# 3. Push to cloud (optional but recommended)
git remote add origin https://github.com/user/project.git
git push -u origin main
```

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/RCAC_project-organization-tips.pdf)** *Includes a step-by-step workflow for starting a new project.*


### 8. File Transfers

**Goal:** Move data efficiently without corrupting files or freezing your terminal.

**Choose the Right Tool**

| Data Size | Recommended Tool | Why? |
| :--- | :--- | :--- |
| **< 1 GB** | `scp` | Quick, simple, no setup required. |
| **Directories** | `rsync` | Resumes if interrupted, syncs only changes. |
| **Big Data (>100GB)** | **Globus** | "Fire and forget." Fast, reliable, background transfer. |
| **Cloud (Box/Drive)** | `rclone` | Command-line sync for cloud storage. |

**1. `rsync` (The Workhorse)**
Use this for moving project folders between your laptop and the cluster, or between scratch and depot.

  * `-a`: Archive (preserve permissions/times)
  * `-v`: Verbose
  * `-P`: Partial + Progress (allows resuming)


```bash
# Push: Local -> Cluster
rsync -avP ./local_folder/ boilerid@bell.rcac.purdue.edu:/scratch/bell/boilerid/dest/

# Pull: Cluster -> Local
rsync -avP boilerid@bell.rcac.purdue.edu:~/remote_file.txt ./
```

**2. `scp` (Quick Copy)**
Best for grabbing a single config file or script.

```bash
scp boilerid@bell.rcac.purdue.edu:~/slurm_job.out ./
```

**3. Globus (Big Data)**
For terabytes of sequencing data, do not use the command line. Use Globus for reliable, high-speed transfers that run in the background. First install **[Globus Connect Personal](https://www.globus.org/globus-connect-personal)** on your laptop and set it up.

1. Log in to **[transfer.rcac.purdue.edu](https://transfer.rcac.purdue.edu)**.
2. **Panel 1:** Select "Purdue Rossmann/Bell/Anvil".
3. **Panel 2:** Select your personal endpoint (laptop) or collaborator's endpoint.
4. Drag and drop. You can close your browser; Globus will email you when it's done.

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/RCAC_data-transfer-tips.pdf)** *Includes detailed setup for Globus Connect Personal.*



### 9. Storage Strategy

**Goal:** Balance performance and data safety. Don't let a full disk crash your pipeline.

**The Hierarchy**

| Location | Path | Speed | Persistence | Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **Local Scratch** | `$TMPDIR` | Fastest | Temporary (Job only) | High I/O (thousands of reads/writes). |
| **Scratch** | `$RCAC_SCRATCH` | Fast | Purged (volatile) | Active analysis & intermediate files. |
| **Depot** | `/depot/lab` | Slower | Permanent | Long-term storage & shared data. |
| **Home** | `$HOME` | Slower | Permanent (Small Quota) | Config files, scripts, small logs. |

**Quota Survival Commands**

  * **Check Status:** Run `myquota` to see your usage across all filesystems.

      * *Watch out:* You have limits on both **Size** (GB/TB) and **Files** (inodes).

  * **Find Space Hogs:** If you hit your limit, use these commands to find which directories are taking up space:

    ```bash
    # Check Home
    du -h --max-depth=1 $HOME

    # Check Scratch
    du -h --max-depth=1 $RCAC_SCRATCH
    ```

**Clean Up Routine**

!!! danger "Volatile Storage"
    Scratch is **not** for storage. Files are purged if not accessed for a set period.

1. **Compress:** `tar -czf results.tar.gz results/`
2. **Archive:** Move tarballs to Data Depot.
3. **Delete:** `rm -rf results/` from scratch.



### 10. Journaling & Notes

**Goal:** Build a "Second Brain." Your shell history (`history | grep cmd`) is temporary; your notes are permanent.

**The Strategy: Digital Lab Notebook**
Use tools like **Obsidian** (markdown-based) or **OneNote**.

  * **The "One-Liner" Library:** Save those complex `awk`, `sed`, or `slurm` commands you spent hours perfecting.
  * **Error Logs:** When you fix a weird error, paste the *exact* error message and your solution. This makes it searchable next time you see it.
  * **Metadata:** Document the "Why," not just the "How." (e.g., "Used parameter `-n 10` because memory failed at `-n 5`").

**Example Note Structure:**

```markdown
## Error: Slurm OOM on Trinity Job
**Date:** 2025-12-09
**Error:** `slurmstepd: error: Detected 1 oom-kill event(s)`
**Fix:** Increased mem-per-cpu from 4G to 8G.
**Command:** `sbatch --mem-per-cpu=8G submit.sh`
```



### 11. Reporting with RMarkdown

**Goal:** Stop copy-pasting images into PowerPoint. Create reports where the code *is* the documentation.

**The Workflow**

1. **Code + Narrative:** Use RMarkdown (`.Rmd`) to write your analysis code and your explanation in the same file.
2. **Knit to HTML:** Generate a single HTML file containing your interactive plots, tables, and code.
3. **Share:** Push the HTML to your repo and enable **GitHub Pages**. Send your PI a link, not a zip file.

**Quick Start Header**
Use this YAML header to add a table of contents and code folding (hides code by default so non-coders can read the report).

```yaml
---
title: "Project QC Report"
author: "Your Name"
date: "2025-12-09"
output:
  html_document:
    toc: true
    toc_float: true
    code_folding: hide
---
```

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/rmarkdown-2.0.pdf)** *Official reference for syntax, chunk options, and formatting.*



### 12. Version Control (Git)

**Goal:** Save your work history so you can undo mistakes and collaborate without emailing zip files.

**1. First-Time Setup**
Tell Git who you are (run once per computer):

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@purdue.edu"
```

**2. Starting a Project**

  * **New Project:** `cd my_project` then `git init`
  * **Existing Repo:** `git clone https://github.com/username/repo.git`

**3. The Daily Workflow (Save & Sync)**

1. **Check:** See what changed.

    ```bash
    git status
    ```

2. **Stage:** Select files to save (use `.` for everything).

    ```bash
    git add .
    ```

3. **Commit:** Save the snapshot with a message.

    ```bash
    git commit -m "Added QC plotting script"
    ```

4. **Push:** Send changes to GitHub.

    ```bash
    git push origin main
    ```

**4. The "Golden Rule" of Bioinformatics Git**

!!! danger
    **Never** commit large data files (FASTQ, BAM, big CSVs).

  * **Solution:** Create a file named `.gitignore` in your folder.

  * **Add these lines to it:**

    ```text title=".gitignore"
    *.fastq
    *.bam
    *.sam
    results/
    data/
    ```

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/RCAC-github-projects.pdf)** *Includes branching workflows and a list of Git "Don'ts".*



### 13. Resource Efficiency

**Goal:** Stop guessing how much RAM you need. Requesting 100GB and using 2GB kills your priority and wastes cluster space.

**The Audit Tool: `seff`**
After a job finishes, run this command to see what actually happened.

```bash
seff <job_id>
```

**What to look for:**

  * **Memory Utilized:** If you requested 64GB but used 4GB, lower your request to 6GB or 8GB next time.
  * **CPU Efficiency:** If this is low (< 50%), your code isn't using the threads you asked for. Request fewer cores.

**The "Sinteractive" Test**
Don't write a 50-line script and hope it works. Test interactively first.

```bash
# Get a node for 1 hour
sinteractive -A <account> -t 01:00:00 --mem=8G

# Run your commands manually. If they work, put them in a script.
```



### 14. Job Arrays

**Goal:** Process 100 samples in parallel using ONE script. Never write a `for` loop to submit jobs.

**The Logic**
Slurm launches multiple copies of your script. In each copy, the variable `$SLURM_ARRAY_TASK_ID` changes (1, 2, 3...). You use this number to pick which file to process.

**The Template**
Create a file named `samples.txt` listing your input filenames (one per line).

```bash
#!/bin/bash
#SBATCH --job-name=array_demo
#SBATCH --output=logs/sample_%a.out  # %a becomes the task ID
#SBATCH --array=1-24                 # Process samples 1 through 24
#SBATCH --cpus-per-task=4

# 1. Get the filename for THIS task ID
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)

echo "Processing sample: $SAMPLE"

# 2. Run the tool
apptainer exec tool.sif my_tool -i "$SAMPLE.fq" -o "$SAMPLE.bam"
```

**Common Array Commands**

  * `sbatch --array=1-100 script.sh`: Submit 100 tasks.
  * `sbatch --array=1-100%20 script.sh`: Submit 100, but only run 20 at a time (be nice to the queue).
  * `scancel <jobid>_<taskid>`: Cancel just one specific task in the array.

**[View Quick Reference (PDF)](../../assets/pdfs/lifesciences/RCAC-slurm-quick-reference.pdf)** *Includes detailed syntax for GPU jobs and parameter sweeps.*



### 15. Getting Help

**Goal:** Unblock yourself quickly by choosing the right channel.

<div class="grid cards" markdown>

-   :material-chat: **Peer Support**

    ---

    Best for "How do I run X?" or "Why does this plot look weird?"
    [Join RCAC Genomics Discord](https://discord.gg/RmtKZmaQW9)

-   :material-book-open-variant: **Tutorials**

    ---

    Step-by-step guides for common bioinformatics tasks.
    [Visit RCAC Bioinformatics Docs](https://rcac-bioinformatics.github.io/)

-   :material-email: **Announcements**

    ---

    Subscribe to the **Bioinformatics Mailing List** to catch upcoming workshops and events.

-   :material-alert: **System Issues**

    ---

    Best for "The node crashed" or "I can't log in."
    Email: [rcac-help@purdue.edu](mailto:rcac-help@purdue.edu)

</div>



### 16. Writing Effective Support Tickets

**Goal:** Get your problem fixed in one email, not ten.

**The "Good Ticket" Template**
When emailing `rcac-help@purdue.edu`, include these four things to skip the "back-and-forth" phase:

1.  **The Cluster:** (e.g., Bell, Anvil, Negishi)
2.  **The Job ID:** (e.g., `12345678`) -- Support staff can look up exactly why it failed.
3.  **The Error:** Paste the *exact* error message or attach the `.err` log file. Don't just say "it failed."
4.  **The Path:** Where is the script/data located? (e.g., `/scratch/bell/user/project/run.sh`)

**Example Email:**

!!! note "Email Example"

    > **Subject:** Job 12345678 failed on Bell - "Segmentation Fault"
    >
    > Hi,
    >
    > My job **12345678** on **Bell** failed immediately after starting.
    > **Path:** `/scratch/bell/aseethar/project_x/submit.sh`
    > **Error:** The log file shows `Segmentation fault (core dumped)` when loading the `samtools` module.
    >
    > I have attached the slurm output file. Can you help?
