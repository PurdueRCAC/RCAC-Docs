---
tags:
  - Geddes
authors:
  - jin456
  - goughes
  - fbakhit
search:
  boost: 2
---

# Migrating Namespaces and Workloads from Geddes (RKE1) to Geddes2 (RKE2)

This guide explains how to migrate namespaces and workloads between the Geddes (RKE1) cluster and the Geddes2 (RKE2) cluster using Rancher and `kubectl`.


## Recommended Migration Workflow

1. Configure kubeconfig contexts
2. Create namespace on Geddes2
3. Export resources from Geddes
4. Clean YAML manifests
5. Validate YAML files
6. Deploy resources to Geddes2
7. Verify workloads and services


## Configure kubectl Contexts

To migrate namespaces between Geddes and Geddes2, first add both cluster kubeconfigs as contexts in your local `kubectl` configuration.



### Step 1 — Download kubeconfig from Rancher

For each cluster:

1. Open Rancher
2. Navigate to the cluster
3. Click **Kubeconfig**
4. Copy or download the kubeconfig

You should end up with files similar to:

```bash
geddes-v1.yaml
geddes-v2.yaml
```



### Step 2 — Test Each kubeconfig Separately

Verify that each kubeconfig can successfully connect to its cluster.

##### Test Geddes (RKE1)

```bash
kubectl --kubeconfig geddes-v1.yaml get nodes
```

##### Test Geddes2 (RKE2)

```bash
kubectl --kubeconfig geddes-v2.yaml get nodes
```

If both commands work successfully, continue to the next step.



### Step 3 — Merge kubeconfigs

Temporarily merge both kubeconfig files:

```bash
export KUBECONFIG=geddes-v1.yaml:geddes-v2.yaml
```

Then merge them into your default kubeconfig:

```bash
kubectl config view --flatten > ~/.kube/config
```



### Step 4 — Verify Contexts

Verify that both cluster contexts are available:

```bash
kubectl config get-contexts
```

Example output:

```text
CURRENT   NAME
*         geddes
          geddes2
```



### Step 5 — Test Switching Contexts

#### Switch to Geddes

```bash
kubectl config use-context geddes
```

Verify access:

```bash
kubectl get pods -n <namespace>
```

If this command works, your context and permissions are configured correctly.



#### Switch to Geddes2

```bash
kubectl config use-context geddes2
```



### Step 6 — Use Contexts Directly

You can now run commands against either cluster directly.

#### Geddes

```bash id="p8m4qn"
kubectl --context geddes get ns
```

#### Geddes2

```bash id="x1q7rv"
kubectl --context geddes2 get ns
```



### Export and Deploy YAML File

#### Important

This step is performed after:

1. Exporting the namespace from Geddes
2. Creating the namespace on Geddes2



### Step 1 — Export Resources from Geddes

You can export workloads individually or export the full namespace.



#### Example A — Export Individual Resource Types

```bash id="z4m8qt"
kubectl --context geddes -n my-namespace get deployment -o yaml > deployment.yaml

kubectl --context geddes -n my-namespace get statefulset -o yaml > statefulset.yaml

kubectl --context geddes -n my-namespace get daemonset -o yaml > daemonset.yaml

kubectl --context geddes -n my-namespace get job -o yaml > job.yaml

kubectl --context geddes -n my-namespace get cronjob -o yaml > cronjob.yaml
```



#### Example B — Export Individual Applications

If your deployment is called `website` in namespace `my-namespace`:

```bash
kubectl --context geddes get deployment <deployment-name> \
-n my-namespace -o yaml > deployment-name.yaml

kubectl --context geddes get daemonset <daemonset-name> \
-n my-namespace -o yaml > daemonset-name.yaml
```

You can repeat this process for:

* statefulsets
* services
* configmaps
* ingresses
* secrets



#### Example C — Export All Resources Using Script

**Script overview**

The script is an interactive Bash utility that exports Kubernetes resources from a selected namespace into organized YAML files.

**What the Script Does**

The script performs the following actions:

1. Prompts the user for a Kubernetes context, in this case this should be 'geddes'
2. Prompts for the namespace to export
3. Verifies the namespace exists. If the namespace does not exist, the script exits with an error.
4. Presents a list of Kubernetes resource types
5. Allows the user to select which resources to export
6. Creates directories automatically
7. Exports each selected resource as an individual YAML file
8. Organizes the files into resource-specific folders


**Display Available Resource Types**

The script presents the following Kubernetes resource types:

```text
deployment
statefulset
daemonset
service
configmap
ingress
pvc
secret
```

For each resource type, the user is prompted:

```bash
Export deployment? (y/n):
Export daemonset? (y/n):
Export pvc? (y/n):
```

Only selected resources are exported.



**Create Export Directory Structure**

The script automatically creates a folder structure under:

```text 
namespace/<namespace>
```

Example:

```text
namespace/
└── my-namespace/
    ├── deployment/
    ├── service/
    ├── configmap/
    ├── ingress/
    └── secret/
```

Each resource type gets its own directory.



**Export Resources as YAML Files**

The script exports every discovered resource individually using `kubectl`.

Example exported files:

```text
namespace/my-namespace/deployment/web.yaml
namespace/my-namespace/service/web-service.yaml
namespace/my-namespace/configmap/app-config.yaml
```

Each file contains the full Kubernetes YAML manifest for that resource.



**Important Notes**

This script requires the Python `PyYAML` package.

Install it using:

```bash
pip install pyyaml
```

**Exported YAML Contains Cluster Metadata**

The exported YAML files include:

* Kubernetes runtime metadata
* Rancher-generated metadata
* resource versions
* status information

Before deploying these manifests to another cluster, the files should be cleaned using a cleanup script.



**Secrets**

The script exports Kubernetes secrets exactly as stored in the cluster.

Use caution when handling exported secret files.



**Persistent Volumes**

PVC objects may export successfully, but underlying storage data is not migrated automatically.

Additional storage migration steps may be required.



**Full Script**

Expand the section below to view and copy the complete `export-resources.py` script

??? note "View full export-resources.py script"

    ```bash 
    #!/usr/bin/env python3

    import os
    import subprocess
    import sys

    AVAILABLE_RESOURCES = [
        "deployment",
        "statefulset",
        "daemonset",
        "service",
        "configmap",
        "ingress",
        "pvc",
        "secret",
    ]


    def run_command(command):
        """Run shell command and return output."""
        result = subprocess.run(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        return result.returncode, result.stdout.strip(), result.stderr.strip()


    def main():
        print("=======================================")
        print(" Kubernetes Namespace Export Utility")
        print("=======================================")

        # Get kube context
        context = input(
            "Enter kube context (leave blank for current context): "
        ).strip()

        # Get namespace
        namespace = input("Enter namespace to export: ").strip()

        if not namespace:
            print("ERROR: Namespace cannot be empty")
            sys.exit(1)

        # Build context argument
        context_arg = ""

        if context:
            context_arg = f"--context {context}"

        # Verify namespace exists
        print(f"\nChecking namespace '{namespace}'...")

        cmd = f"kubectl {context_arg} get namespace {namespace}"

        rc, out, err = run_command(cmd)

        if rc != 0:
            print(f"ERROR: Namespace '{namespace}' not found")
            print(err)
            sys.exit(1)

        # Select resources
        selected_resources = []

        print("\nSelect resources to export:")
        print("--")

        for resource in AVAILABLE_RESOURCES:
            answer = input(f"Export {resource}? (y/n): ").strip().lower()

            if answer in ["y", "yes"]:
                selected_resources.append(resource)

        if not selected_resources:
            print("\nNo resources selected.")
            sys.exit(1)

        # Base export directory
        base_dir = os.path.join("namespace", namespace)

        os.makedirs(base_dir, exist_ok=True)

        print("\nStarting export...\n")

        for resource in selected_resources:
            print(f"Exporting resource type: {resource}")

            resource_dir = os.path.join(base_dir, resource)

            os.makedirs(resource_dir, exist_ok=True)

            # Get resource names
            cmd = (
                f"kubectl {context_arg} -n {namespace} "
                f"get {resource} -o name"
            )

            rc, out, err = run_command(cmd)

            if rc != 0:
                print(f"WARNING: Unable to get {resource}")
                print(err)
                continue

            items = out.splitlines()

            if not items:
                print(f"  No {resource} found")
                continue

            for item in items:
                item = item.strip()

                if not item:
                    continue

                name = item.split("/")[-1]

                output_file = os.path.join(
                    resource_dir,
                    f"{name}.yaml"
                )

                print(f"  -> Exporting {item}")

                export_cmd = (
                    f"kubectl {context_arg} -n {namespace} "
                    f"get {item} -o yaml"
                )

                rc, yaml_out, err = run_command(export_cmd)

                if rc != 0:
                    print(f"ERROR exporting {item}")
                    print(err)
                    continue

                with open(output_file, "w") as f:
                    f.write(yaml_out)

        print("\n=======================================")
        print(" Export completed successfully")
        print("=======================================")
        print(f"Files saved under: {base_dir}")


    if __name__ == "__main__":
        main()


    ```





### Step 2 — Resource Cleanup Before Deployment to Geddes2


After exporting a namespace, the YAML files contain cluster-specific metadata that must be removed before deploying to Geddes2.

This cleanup process removes:

* RKE1-specific metadata
* Rancher-generated metadata
* Kubernetes runtime metadata

Cleaning exported YAML files helps prevent deployment conflicts and removes unnecessary cluster-specific information before importing workloads into the Geddes2 cluster.


#### Cleanup Multiple YAML Files (Namespace Folder Cleanup)

This script:

* Cleans **all YAML files recursively**
* Processes all folders under a namespace directory
* Removes Kubernetes and Rancher-generated metadata
* Overwrites the original YAML files (in-place cleanup)

#### Important:
  * This script **overwrites existing YAML files** with the cleaned version. There is no backup unless you create one manually.
  * The script must be executed in the directory where the exported namespace folder exists. You may modify the script if your folder location is different.



The script will:

* scan all folders under `namespace/my-namespace`
* process every `.yaml` file
* overwrite each file with cleaned content



#### Python Cleanup Script

Expand the section below to view and copy the complete `cleanup_multiple_yaml.py` script.


??? note "View full cleanup_multiple_yaml.py script"

    ```python
    #!/usr/bin/env python3

    import os
    import re
    import sys
    from pathlib import Path

    print("=======================================")
    print(" Kubernetes YAML Cleanup Utility")
    print("=======================================")

    # Ask for namespace
    namespace = input("Enter namespace directory to clean: ").strip()

    if not namespace:
        print("ERROR: Namespace cannot be empty")
        sys.exit(1)

    # Build base directory
    base_dir = Path("namespace") / namespace

    # Verify directory exists
    if not base_dir.is_dir():
        print(f"ERROR: Directory '{base_dir}' does not exist")
        sys.exit(1)

    print("")
    print("Starting cleanup in:")
    print(base_dir)
    print("")


    def remove_block(lines, start_pattern):
        """
        Remove YAML block sections such as:
        managedFields:
        status:
        ownerReferences:
        finalizers:
        """
        new_lines = []

        skip = False
        indent_level = None

        for line in lines:
            if not skip:
                if re.match(start_pattern, line):
                    skip = True
                    indent_level = len(line) - len(line.lstrip())
                    continue
                else:
                    new_lines.append(line)
            else:
                current_indent = len(line) - len(line.lstrip())

                if line.strip() and current_indent <= indent_level:
                    skip = False
                    new_lines.append(line)

        return new_lines


    for file in base_dir.rglob("*.yaml"):
        print(f"Processing: {file}")

        with open(file, "r") as f:
            lines = f.readlines()

        cleaned_lines = []

        for line in lines:
            if re.search(r'^\s*uid:', line):
                continue

            if re.search(r'^\s*resourceVersion:', line):
                continue

            if re.search(r'^\s*creationTimestamp:', line):
                continue

            if re.search(r'^\s*selfLink:', line):
                continue

            if re.search(r'^\s*generation:', line):
                continue

            if re.search(r'^\s*deployment\.kubernetes\.io/revision:', line):
                continue

            if "field.cattle.io" in line:
                continue

            if "cattle.io" in line:
                continue

            if "kubectl.kubernetes.io/last-applied-configuration" in line:
                continue

            cleaned_lines.append(line)

        cleaned_lines = remove_block(cleaned_lines, r'^\s*managedFields:')
        cleaned_lines = remove_block(cleaned_lines, r'^\s*status:')
        cleaned_lines = remove_block(cleaned_lines, r'^\s*ownerReferences:')
        cleaned_lines = remove_block(cleaned_lines, r'^\s*finalizers:')

        with open(file, "w") as f:
            f.writelines(cleaned_lines)

        print(f"Cleaned: {file}")

    print("")
    print("=======================================")
    print(" YAML cleanup completed successfully")
    print("=======================================")
    ```




### Cleanup a Single YAML File

The following Python utility is designed to clean individual Kubernetes YAML manifests exported from geddes cluster.



### Example Usage

  * Clean a Single YAML File

    ```bash
      python3 cleanup_single_yaml.py dirty.yaml
    ```

This prints the cleaned YAML output to the terminal.



## Python Cleanup Script

Expand the section below to view and copy the complete `cleanup_single_yaml.py` script.

??? note "View full cleanup_single_yaml.py script"

    ```python
    #!/usr/bin/env python3
    # Strip kubectl export noise from Deployment YAMLs.
    # Usage:
    #   python3 k8s_clean.py dirty.yaml
    #   python3 k8s_clean.py dirty.yaml -o clean.yaml
    #   python3 k8s_clean.py *.yaml -o ./clean/

    import argparse
    import sys
    from pathlib import Path

    try:
        import yaml
    except ImportError:
        sys.exit("PyYAML is required: pip install pyyaml")


    METADATA_DROP = {
        "annotations",
        "creationTimestamp",
        "generation",
        "resourceVersion",
        "uid",
        "managedFields",
        "selfLink",
    }

    TEMPLATE_METADATA_DROP = {
        "annotations",
        "creationTimestamp",
    }


    def clean_deployment(doc: dict) -> dict:
        if doc is None:
            return doc

        meta = doc.get("metadata", {})
        for key in METADATA_DROP:
            meta.pop(key, None)

        spec = doc.get("spec", {})
        template = spec.get("template", {})
        tmeta = template.get("metadata", {})
        for key in TEMPLATE_METADATA_DROP:
            tmeta.pop(key, None)
        # avoid leaving a bare `metadata: {}` in the template
        if not tmeta:
            template.pop("metadata", None)
        else:
            template["metadata"] = tmeta

        doc.pop("status", None)

        return doc


    def process_file(src: Path, dst: Path | None) -> None:
        docs = list(yaml.safe_load_all(src.read_text()))
        cleaned = [clean_deployment(d) for d in docs if d is not None]

        out_text = yaml.dump_all(
            cleaned,
            default_flow_style=False,
            allow_unicode=True,
            sort_keys=False,
        )

        if dst is None:
            print(out_text)
        else:
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.write_text(out_text)
            print(f"  wrote {dst}")


    def main():
        parser = argparse.ArgumentParser(
            description="Strip Kubernetes export noise from Deployment YAML files."
        )
        parser.add_argument("inputs", nargs="+", help="Source YAML file(s)")
        parser.add_argument(
            "-o", "--output",
            help="Output file or directory. Omit to print to stdout.",
        )
        args = parser.parse_args()

        sources = [Path(p) for p in args.inputs]
        out = Path(args.output) if args.output else None
        multi = len(sources) > 1
        out_is_dir = out is not None and (out.is_dir() or multi or out.suffix == "")

        for src in sources:
            if not src.exists():
                print(f"WARNING: {src} not found, skipping.", file=sys.stderr)
                continue

            if out is None:
                dst = None
            elif out_is_dir:
                dst = out / src.name
            else:
                dst = out

            process_file(src, dst)


    if __name__ == "__main__":
        main()
    ```


## Step 3 — Basic Validation (Recommended)

Validate all YAML files after cleanup and before deployment to Geddes2.

This verifies:

* YAML syntax
* Kubernetes API compatibility
* cluster compatibility

### Example A — Validate Single YAML File

```bash
kubectl --context geddes2 apply --dry-run=client \
-f my-resources.yaml
```

or

```bash
kubectl apply --dry-run=client \
-f my-resources.yaml
```



### Example B — Validate Entire Directory

Not recommended for large exports because troubleshooting can become difficult.

```bash
kubectl --context geddes2 apply --dry-run=server \
-f ./your-directory/
```


### Example C — Validate Each File Individually (Recommended)

This approach is safer and easier for debugging.

```bash
for file in $(find ./your-directory -name "*.yaml"); do
  echo "Validating $file"
  kubectl apply --dry-run=client -f "$file"
done
```


## Step 4 — Resource Deployment on Geddes2

After cleanup and validation, deploy the resources to Geddes2.



### Example A — Deploy Single YAML File

Ensure your YAML contains:

```yaml
metadata:
  namespace: <my-namespace>
```

Deploy using:

```bash
kubectl --context geddes2 apply -f resources-file.yaml
```



### Example B — Deploy Entire Namespace Folder

If using the `export-resources.sh` script, the exported structure will look like:

```text
namespace/<my-namespace>
```

Deploy all resources:

```bash
kubectl --context geddes2 apply -f namespace/<my-namespace>
```

## Important Notes

#### Persistent Volume Data

PVC objects migrate, but the underlying storage data usually does not.

Persistent application data must be migrated separately.



#### Secrets

Some secrets should not be migrated directly:

* service-account-token secrets
* Helm release secrets
* auto-generated certificates
