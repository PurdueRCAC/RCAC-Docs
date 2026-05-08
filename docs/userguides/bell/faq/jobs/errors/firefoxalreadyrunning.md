---
tags:
  - Bell
authors:
  - mahlawat
resource: Bell
search:
  boost: 2
---

# Close Firefox / Firefox is already running but not responding

### Problem

You receive the following message after trying to launch Firefox browser inside your graphics desktop:

```
Close Firefox

Firefox is already running, but not responding.  To open a new window,
you  must first close the existing Firefox process, or restart your system.
```

### Solution

When Firefox runs, it creates several lock files in the Firefox profile directory (inside `~/.mozilla/firefox/` folder in your home directory). If a newly-started Firefox instance detects the presence of these lock files, it complains.

This error can happen due to multiple reasons:

1. Reason: You had a single Firefox process running, but it terminated abruptly without a chance to clean its lock files (e.g. the job got terminated, session ended, node crashed or rebooted, etc).
   * Solution: If you are certain you do not have any other Firefox processes running elsewhere, please use the following command in a terminal window to detect and remove the lock files:

     ```
     $ unlock-firefox
     ```
2. Reason: You may indeed have another Firefox process (in another Thinlinc or Gateway session on this or other cluster, another front-end or compute node). With many clusters sharing common home directory, a running Firefox instance on one can affect another.
   * Solution: Try finding and closing running Firefox process(es) on other nodes and clusters.
   * Solution: If you must have multiple Firefoxes running simultaneously, you may be able to create separate Firefox profiles and select which one to use for each instance.