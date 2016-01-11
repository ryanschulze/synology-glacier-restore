# synology-glacier-restore

The [Synology Glacier Backup](https://www.synology.com/en-us/dsm/app_packages/GlacierBackup) app has a nice gui to backup and restore files from a Synology NAS to Amazon glacier (as a low cost offsite backup). While it provides sufficient possibilities to restore files that were backed up, it is important to consider a worst case scenario where the synology device probably can't be used to restore files any more. The application renames the files it backups to 138 character long random file names. It then stores the mapping "random file name" to "path and real file name" in a sqlite3 database (in a seperate vault with the suffix '_mapping'). This makes it not quite straightforward or simple to restore a synology backup on glacier with other tools.

This script reads the sqlit3 database, rebuild the directory structure, and copies the files from the "random" format over to the "real" filename. It assumes you have already downloaded the 2 vaults (one with the backed up files, one with the mapping database) and they can be accessed locally.

Usage:
```bash
./unpack_glacier.sh <mapping_file> <encoded_files_directory> <destination_deirectory>
```

## ToDo List
- getopts instead of fixed positional arguments
- chose which action to to (copy,move,print)
- only work on specific paths of the backup
