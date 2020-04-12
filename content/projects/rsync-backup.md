---
Title: rsync-backup
ProjectGroup: Applications
Repository: https://github.com/sjakthol/rsync-backup
Description: |
  An utility for taking periodic point-in-time snapshots of
  local directories and backing them up to a remote machine
  with rsync.
Tags:
    - shell
Date: 2017-09-10
---

This script can be used to backup local directories over SSH to
a remote machine. It uses rsync's `--link-dest` feature to avoid
storing copies of files that have not changed between two snapshots.

{{< rawhtml >}}
<a target="_blank" rel="noopener" href="https://github.com/sjakthol/rsync-backup">View in Github</a>
{{< /rawhtml >}}