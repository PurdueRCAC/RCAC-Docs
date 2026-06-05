---
tags:
  - Fortress
authors:
  - jin456
search:
  boost: 2
draft: false
---

# Fortress Overview

Fortress uses a [Spectra Logic TFinity robotic tape library](https://youtu.be/I3quB7uQPRM) with a capacity of over 200 PB.

## Hardware Overview

| Storage Subsystem | Current Capacity | Hardware |
|---|---|---|
| Disk Cache | Over 800 TB | 2 Seagate 5U84 Storage arrays |
| Long-Term Storage | Over 200 PB | LTO-9 Robotic Tape Library |

All files stored on Fortress appear in at least two separate storage devices:

- One copy is permanently on tape.
- Recently used or files smaller than 100MB have their primary copy stored on a conventional spinning disk storage array (disk cache). Disk cache provides a rapid restore time.

Both primary and secondary copies of larger files reside on separate tape cartridges in the robotic tape library. After a period of inactivity, HPSS will migrate files from disk cache to tape.

Fortress writes two copies of every file either to two tapes, or to disk and a tape, to protect against medium errors. Unfortunately, Fortress does not automatically switch to the alternate copy when it has trouble accessing the primary. If it seems to be taking an extraordinary amount of time to retrieve a file (hours), please [contact support](mailto:rcac-help@purdue.edu). We can then investigate why it is taking so long. If it is an error on the primary copy, we will instruct Fortress to switch to the alternate copy as the primary and recreate a new alternate copy.

## Fortress Storage Quota

There is currently no quota on Fortress disk use. Fortress users will receive a monthly email report showing your current Fortress usage.

Files belonging to deleted accounts will also be retained, but inaccessible except by special request after the accounts have been terminated. The files will be kept for no more than ten years or the usability of the media on which they are stored, whichever comes first.

## Fortress File Recovery

Data on Fortress is not backed up elsewhere in a traditional sense. New and modified files in the disk cache are migrated to tape within 30 minutes, and Fortress maintains two copies of every file on different media to protect against media failures, but there is no backup protecting against accidental deletions.

!!! warning "Warning"
    If you remove or overwrite a file on Fortress, it is gone. You cannot request to have it retrieved.
