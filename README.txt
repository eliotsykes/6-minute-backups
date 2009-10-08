6 Minute Backups
----------------
Simple ruby script for securely backing up directories and mysql databases   
http://github.com/eliotsykes/6-minute-backups

The name was inspired by the hitchhiker/abs video scene in There's Something About Mary;
6 minutes is how long I'd like for this to take you to setup on a new box.

I wrote this to do encrypted backups of a wordpress blog, a rails app and a few
mysql databases. You just edit a simple yml file to backup any databases and directories.

What does it do?
----------------
- Backs up any number of mysql databases
- Backs up any number of directories
- Encrypts all backups to your home directory (under ~/backups/)
- Backs up daily, weekly (every Monday) and monthly (every 1st of the month)
- Selectively deletes oldest backup files to keep backup directory size down, specifically:
  - Daily backups: keeps all daily backups from the last week, older dailies are deleted
  - Weekly backups: keeps all weekly backups from the last month, older weeklies are deleted
  - Monthly backups: keeps all monthly backups from the last year, older monthlies are deleted

What will I need?
-----------------
- Ruby installed on the system you want to backup

- A public key to encrypt the backups using GPG. Follow the simple instructions
  here if you want to generate your own public key:
  http://www.madboa.com/geek/gpg-quickstart/#keyintro
  
- Cron to trigger script to run once a day

Instructions
-----------
1. Put all the files in this directory on the system you want to backup.
   Putting it in your home directory under /6-minute-backups is good.
   
   cd ~
   git clone git://github.com/eliotsykes/6-minute-backups.git

2. Copy 6minbackup-sample.yml to ~/.6minbackup/6minbackup.yml and edit as directed in that
   file:
   
   mkdir .6minbackup
   cp 6-minute-backups/6minbackup-sample.yml .6minbackup/6minbackup.yml
   vi .6minbackup/6minbackup.yml

3. Import the gpg_recipient's public key before running the script: 
   e.g. gpg --import pubkey.txt
   ( More on gpg here: http://www.madboa.com/geek/gpg-quickstart/ )

3. Set up cron to run 6minbackup.rb daily.

Using the backups
-----------------
Large files require cat and piping output to gpg, so recommend using this command
whether your encrypted backup file is large or small for decrypting and decompressing:

cat my-backup-file-#{timestamp}.tar.bz2.gpg | gpg --decrypt | tar -jx

Advanced
--------
Use s3sync.rb to store your ~/backups directory off-site on Amazon S3. More info
here: http://s3sync.net/wiki


Feedback and contributions welcome,
--
Eliot Sykes <eliotsykes@gmail.com>

