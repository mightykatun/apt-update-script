# APT Update script
Script that makes it easy to automate apt updates on linux.

Use ase follows:
`sudo apt update`\
Add the `-c` switch to run `sudo apt autoremove` at the end.

There is a version of the script that can use ntfy to inform you in case you want to automate your updating via, e.g., a crontab.\
You can run: `sudo apt update -c -s`\ to differentiate when the script was run by an external script (hence the `-s` switch).

The ntfy script adds a timestamp which allows you to run it through crontab and have it create a log file (hacky command warning ⚠️):\
`@reboot sleep 300 && sudo bash -c "/usr/var/bin/update -c -s >> /var/log/update.log 2>&1"`
