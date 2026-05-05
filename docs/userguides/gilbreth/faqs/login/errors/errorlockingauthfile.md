---
tags:
  - Gilbreth
authors:
  - jin456
resource: Gilbreth
search:
  boost: 2
---

# /usr/bin/xauth: error in locking authority file

### Problem

I receive this message when logging in:

`/usr/bin/xauth: error in locking authority file`

### Solution

Your home directory disk quota is full. You may check your quota with `myquota`.

You will need to free up space in your home directory.

`ncdu` command is a convenient interactive tool to examine disk usage. Consider running `ncdu $HOME` to analyze where the bulk of the usage is. With this knowledge, you could then archive your data elsewhere (e.g. your research group's Data Depot space, or Fortress tape archive), or delete files you no longer need.

There are several common locations that tend to grow large over time and are merely cached downloads.  The following are safe to delete if you see them in the output of `ncdu $HOME`:

```
/home/${user.username}/.local/share/Trash
/home/${user.username}/.cache/pip
/home/${user.username}/.conda/pkgs
/home/${user.username}/.singularity/cache
```