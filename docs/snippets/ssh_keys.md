### General overview

To connect to {{ resource }} using SSH keys, you must follow three high-level steps:

1. Generate a key pair consisting of a private and a public key on your local machine.
2. Copy the public key to the cluster and append it to `$HOME/.ssh/authorized_keys` file in your account.
3. Test if you can ssh from your local computer to the cluster without using your Purdue password.

Detailed steps for different operating systems and specific SSH client softwares are give below.

### Mac and Linux:

1. Run `ssh-keygen` in a terminal on your local machine. You may supply a filename and a passphrase for protecting your private key, but it is not mandatory. To accept the default settings, press Enter without specifying a filename.

!!!note:
    If you do not protect your private key with a passphrase, anyone with access to your computer could SSH to your account on {{ resource }}.

2. By default, the key files will be stored in `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` on your local machine.
3. Copy the contents of the public key into `$HOME/.ssh/authorized_keys` on the cluster with the following command. When asked for a password, type your password followed by "`,push`". Your Purdue Duo client will receive a notification to approve the login.

   `ssh-copy-id -i ~/.ssh/id_rsa.pub username@{{ resource }}.rcac.purdue.edu`

   Note: use your actual Purdue account user name.

   If your system does not have the `ssh-copy-id` command, use this instead:

   `cat ~/.ssh/id_rsa.pub | ssh username@{{ resource }}.rcac.purdue.edu "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys"`
4. Test the new key by SSH-ing to the server. The login should now complete without asking for a password.
5. If the private key has a non-default name or location, you need to specify the key by

   `ssh -i my_private_key_name username@{{ resource }}.rcac.purdue.edu`

### Windows:

Windows SSH Instructions

| Programs | Instructions |
| --- | --- |
| **MobaXterm** | Open a local terminal and follow Linux steps |
| **Git Bash** | Follow Linux steps |
| **Windows 10 PowerShell** | Follow Linux steps |
| **Windows 10 Subsystem for Linux** | Follow Linux steps |
| **PuTTY** | Follow steps below |

**PuTTY:**

1. Launch *PuTTYgen*, keep the default key type (RSA) and length (2048-bits) and click **Generate** button.

   ![PuTTYgen interface](/knowledge/accounts/keygen1.png)


   The "Generate" button can be found under the "Actions" section of the PuTTY Key Generator interface.
2. Once the key pair is generated:

   Use the **Save public key** button to save the public key, e.g. `Documents\SSH_Keys\mylaptop_public_key.pub`

   Use the **Save private key** button to save the private key, e.g. `Documents\SSH_Keys\mylaptop_private_key.ppk`. When saving the private key, you can also choose a reminder comment, as well as an optional passphrase to protect your key, as shown in the image below. **Note**: If you do not protect your private key with a passphrase, anyone with access to your computer could SSH to your account on {{ resource }}.

   ![PuTTY Key Generator form with the passphrase and comment fields highlighted](/knowledge/accounts/keygen5.png)


   The PuTTY Key Generator form has inputs for the Key passphrase and optional reminder comment.

   From the menu of *PuTTYgen*, use the *"Conversion -> Export OpenSSH key"* tool to convert the private key into openssh format, e.g. `Documents\SSH_Keys\mylaptop_private_key.openssh` to be used later for Thinlinc.
3. Configure *PuTTY* to use key-based authentication:

   Launch *PuTTY* and navigate to *"Connection -> SSH ->Auth"* on the left panel, click **Browse** button under the *"Authentication parameters"* section and choose your private key, e.g. **mylaptop\_private\_key.ppk**

   ![PuTTY Auth panel](/knowledge/accounts/keygen2.png)


   After clicking Connection -> SSH ->Auth panel, the "Browse" option can be found at the bottom of the resulting panel.

   Navigate back to *"Session"* on the left panel. Highlight *"Default Settings"* and click the "Save" button to ensure the change in place.
4. Connect to the cluster. When asked for a password, type your password followed by "`,push`". Your Purdue Duo client will receive a notification to approve the login. Copy the contents of public key from *PuTTYgen* as shown below and paste it into `$HOME/.ssh/authorized_keys`. Please double-check that your text editor did not wrap or fold the pasted value (it should be one very long line).

   ![PuTTY Key Generator form with the generated key highlighted](/knowledge/accounts/keygen4.png)


   The "Public key" will look like a long string of random letters and numbers in a text box at the top of the window.
5. Test by connecting to the cluster. If successful, you will **not** be prompted for a password or receive a Duo notification. If you protected your private key with a passphrase in step 2, you **will** instead be prompted to enter your chosen passphrase when connecting.