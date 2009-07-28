6 Minute Backups
----------------
Simple ruby script for securely backing up directories and mysql databases   
http://github.com/eliotsykes/6-minute-backups

The name was inspired by the hitchhiker/abs video scene in There's Something About Mary;
6 minutes is how long I'd like for this to take you to setup on a new box.

I wrote this to do encrypted backups of a wordpress blog, a rails app and a few
mysql databases. You just edit a yml file to backup any databases and directories.

What does it do?
----------------
- Backs up any number of mysql databases
- Backs up any number of directories
- Encrypts all backups to your home directory (under ~/backups/)
- Keeps last 30 days worth of backups

What will I need?
-----------------
- Ruby installed on the system you want to backup

- A public key to encrypt the backups using GPG. Follow the simple instructions
  here if you want to generate your own public key:
  http://www.madboa.com/geek/gpg-quickstart/#keyintro

Instructions
-----------
1. Put all the files in this directory on the system you want to backup.
   Putting it in your home directory under /6-minute-backups is good.

2. Copy 6minbackup-sample.yml to 6minbackup.yml and edit as directed in that
   file.

3. Import the gpg_recipient's public key before running the script: 
   e.g. gpg --import pubkey.txt
   ( More on gpg here: http://www.madboa.com/geek/gpg-quickstart/ )

3. Set up cron to run 6minbackup.rb daily (or however often you want it to run).

Advanced
--------
Use s3sync.rb to store your ~/backups directory off-site.


Feedback and contributions welcome,
--
Eliot Sykes <eliotsykes@gmail.com>

