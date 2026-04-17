---
tags:
  - Anvil
  - Object Storage
authors:
  - hkashgar
search:
  boost: 2
draft: false
---

[Back to Anvil Object Storage](index.md)

# User Tools

## Rclone

[`rclone` :octicons-link-external-16:](https://rclone.org/) is a command-line tool for interacting with cloud and object storage systems. On Anvil, it can be used to connect to the S3-compatible object storage service and manage buckets and files.

---

#### 1. Load the `rclone` module

First, load the `rclone` module on Anvil:

```bash
module load rclone
```

Verify installation:

```bash
$ rclone version
rclone v1.70.3 
```

---

#### 2. Start the `rclone` configuration

Run the configuration and create a new remote:

```bash
rclone config
```
 
Inside the interactive menu:
- Type `n` to create a new remote
- Enter a name (example):

```
anvil-s3
```

---

#### 3. Select storage type

When prompted for the storage type, choose:

```
s3 
```
Then, when asked for the provider, select:

```
Ceph Object Storage \ (Ceph)
```

---

#### 4. Enter credentials

Provide **Access Key ID** and **Secret Access Key** These are provided by RCAC team when your object storage account is created.

---

#### 5. Set connection parameters

Use:

- **Endpoint URL:** https://s3.anvil.rcac.purdue.edu
- **Region:** leave blank (unless provided)
- **Location constraint:** leave blank

For the remaining configuration prompts, accept the default values unless otherwise specified, then confirm and save the configuration.

---

### Test the connection

List files in your bucket (the bucket name will be provided by the RCAC team):

```bash
rclone ls anvil-s3:bucketname
```

---

### Common `rclone` commands

**Show config**
```bash
rclone config show
```

**List files in a bucket**
```bash
rclone ls anvil-s3:bucketname
```

**List directories in a bucket**
```bash
rclone lsd anvil-s3:bucketname
```

**Upload a file**
```bash
rclone copy myfile.txt anvil-s3:bucketname
```

**Upload a directory**
```bash
rclone copy mydir anvil-s3:bucketname/mydir
```

**Download data**
```bash
rclone copy anvil-s3:bucketname/mydir ./mydir
```

**sync directories**
```bash
rclone sync mydir anvil-s3:bucketname/mydir
```

!!! warning "Warning"
    `sync` will delete files at the destination that do not exist in the source.

---

#### Example configuration file

Location:

```
~/.config/rclone/rclone.conf
```

Example:

```ini
[anvil-s3]
type = s3
provider = Ceph
env_auth = true
access_key_id = YOUR_ACCESS_KEY
secret_access_key = YOUR_SECRET_KEY
endpoint = https://s3.anvil.rcac.purdue.edu
force_path_style = true
acl = private
```

---

## s3cmd

[`s3cmd` :octicons-link-external-16:](https://s3tools.org/s3cmd) is a command-line tool for interacting with S3-compatible object storage. On Anvil, it can be used to manage buckets and transfer data to and from object storage.

!!! note "Note"
    Unlike `rclone`, which supports multiple named remotes, `s3cmd` relies on a single configuration file (`~/.s3cfg`) and is generally limited to one endpoint at a time. To work with multiple endpoints, use separate configuration files with the `--config` option.

---

#### 1. Verify `s3cmd` 

Verify installation on the cluster:

```bash
$ s3cmd --version
s3cmd version 2.4.0
```

---

#### 2. Start the configuration

Run:

```bash
s3cmd --configure
```

---

#### 3. Enter credentials

Provide the following when prompted: **Access Key** and **Secret Key**. These are provided by the RCAC team when your object storage account is created.

---

#### 4. Set connection parameters

When prompted for endpoint and DNS settings, use:

- **S3 Endpoint:**  
  s3.anvil.rcac.purdue.edu

- **DNS-style bucket+hostname:**  
  %(bucket)s.s3.anvil.rcac.purdue.edu

- **Use HTTPS:**  
  Yes

- **Default region:**  
  Leave blank

For the remaining configuration prompts, accept the default values unless otherwise specified, then confirm and save the configuration.

After configuration completes, you can check them here:

```bash
cat ~/.s3cfg
```

Ensure the following settings:

```ini
host_base = s3.anvil.rcac.purdue.edu
host_bucket = %(bucket)s.s3.anvil.rcac.purdue.edu
use_https = True
```

!!! warning 
    Leave `host_bucket` empty if you want to enforce path-style addressing.

---

### Test the connection

List files in your bucket (the bucket name will be provided by the RCAC team):

```bash
s3cmd ls s3://bucketname
```

---

### Common `s3cmd` commands

**List buckets**
```bash
s3cmd ls
```

**List files in a bucket**
```bash
s3cmd ls s3://bucketname
```

**Upload a file**
```bash
s3cmd put myfile.txt s3://bucketname/
```

**Upload a directory**
```bash
s3cmd put -r mydir s3://bucketname/
```

**Download a file**
```bash
s3cmd get s3://bucketname/myfile.txt
```

**Download a directory**
```bash
s3cmd get -r s3://bucketname/mydir
```

**Remove a file**
```bash
s3cmd del s3://bucketname/myfile.txt
```

**Verbose debug**
```bash
s3cmd ls s3://bucketname --debug
```
---

#### Example configuration file

Location:

```
~/.s3cfg
```

Example:

```ini
[default]
access_key = YOUR_ACCESS_KEY
secret_key = YOUR_SECRET_KEY
host_base = s3.anvil.rcac.purdue.edu
host_bucket = %(bucket)s.s3.anvil.rcac.purdue.edu
use_https = True
```

## Python boto3

[`boto3` :octicons-link-external-16:](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html) is the official AWS SDK for Python. It can also be used with S3-compatible object storage such as Anvil’s Ceph-based storage by specifying a custom endpoint.

---

#### 1. Load Conda module and create your environment

On Anvil, load conda module or activate your environment:

```bash

module load conda
conda create -n boto3 python=3.12
conda activate boto3
pip install boto3

```

---

#### 2. Configure credentials

You can provide credentials in two ways:

##### Environment variables

```bash
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
```

Then in Python: 

```python
import boto3

# Create S3 client (credentials picked up automatically from environment)
s3 = boto3.client(
    "s3",
    endpoint_url="https://s3.anvil.rcac.purdue.edu"
)
```

##### Directly in code

```python
import boto3

s3 = boto3.client(
    "s3",
    endpoint_url="https://s3.anvil.rcac.purdue.edu",
    aws_access_key_id="YOUR_ACCESS_KEY",
    aws_secret_access_key="YOUR_SECRET_KEY"
)
```

---

#### 3. Test the connection

List available buckets:

```python
response = s3.list_buckets()

for bucket in response["Buckets"]:
    print(bucket["Name"])
```

---

#### 4. Access your bucket

List files in your bucket (the bucket name will be provided by the RCAC team):

```python
bucket_name = "bucketname"

response = s3.list_objects_v2(Bucket=bucket_name)

for obj in response.get("Contents", []):
    print(obj["Key"])
```

---

#### Common `boto3` operations

**Upload a file**

```python
s3.upload_file("myfile.txt", "bucketname", "myfile.txt")
```

---

**Download a file**

```python
s3.download_file("bucketname", "myfile.txt", "myfile.txt")
```

---

**Upload a directory**

```python
import os

for root, dirs, files in os.walk("mydir"):
    for file in files:
        local_path = os.path.join(root, file)
        s3_path = os.path.relpath(local_path, "mydir")
        s3.upload_file(local_path, "bucketname", s3_path)
```

---

**Delete a file**

```python
s3.delete_object(Bucket="bucketname", Key="myfile.txt")
```

---

**Advanced: Use a custom session**

```python
session = boto3.session.Session()

s3 = session.client(
    "s3",
    endpoint_url="https://s3.anvil.rcac.purdue.edu"
)
```

**Advanced: Streaming file (no download)**

```python
obj = s3.get_object(Bucket="bucketname", Key="data/file.txt")
data = obj["Body"].read()
```
## Notes

- Keep your credentials secure
- Access depends on bucket permissions
- Shared buckets may be accessible without ownership

---