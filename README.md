# Update-script
Script that makes it easy to automate apt updates on linux.

Use ase follows:
`sudo apt update`\
Add the `-c` switch to run `sudo apt autoremove` at the end.

There is a version of the script that can use ntfy to inform you in case you want to automate your updating via, e.g., a crontab.\
You can run: `sudo apt update -c -s`\ to differentiate when the script was run by a script (hence the `-s` switch).
