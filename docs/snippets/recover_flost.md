<!-- Template snippet: {CLUSTER} = title-case cluster name, {cluster} = lowercase. Replaced at build time by `recover_flost_snippet` in main.py. -->
# flost

If you know when you lost the file, the easiest way is to use the `flost` command. This tool is available from any RCAC resource. If you do not have access to a compute cluster, any {CLUSTER} user may use an SSH client to connect to `{cluster}.rcac.purdue.edu` and run this command.

To run the tool you will need to specify the location where the lost file was with the `-w` argument:

```
$ flost -w /your/location
```

!!!note
    Only `/home` and `/depot/` folders have backups across RCAC resources. If you know more specifically where the lost file was you may provide the full path to that directory.

This tool will prompt you for the date on which you lost the file or would like to recover the file from. If the tool finds an appropriate snapshot it will provide instructions on how to search for and recover the file.

If you are not sure what date you lost the file you may try entering different dates into the `flost` to try to find the file or you may also [manually browse](manual.md) the snapshots as described below.

[**Back to the Lost File Recovery section**](../recover.md)
