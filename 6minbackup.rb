#!/usr/bin/env ruby

# Modify load path so require will find files in this directory regardless
# of where this script is run from.
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require '6minconfig'
require '6mincommands'

def timestamp
  return Time.now.utc.strftime("%Y%m%d%H%M%S")  
end

puts "Backing up @ #{Time.now.utc}"
os_user=CONFIG["os_user"]
backups_home = "/home/#{os_user}/backups"
dbs_home = "#{backups_home}/dbs"
dirs_home = "#{backups_home}/dirs"
db_dump_file = "mysql-backup-#{timestamp}.sql"
db_backup = "#{dbs_home}/#{db_dump_file}"
compressed_file_path = "#{db_backup}.tar.bz2"
encrypted_file_path = "#{compressed_file_path}.gpg"
directories = CONFIG['directories']

# TODO remove duplication below

# Backup the dbs
CreateDirectoriesCommand.new("Creating directories", dbs_home).execute
MysqlDumpCommand.new("Dumping database(s)", db_backup).execute
CompressCommand.new('Compressing', db_backup, compressed_file_path).execute
DeleteCommand.new("Deleting dump file", db_backup).execute
EncryptCommand.new("Encrypting", compressed_file_path, encrypted_file_path).execute
DeleteCommand.new("Deleting compressed file", compressed_file_path).execute
DeleteOldFilesCommand.new("Deleting backups older than 30 days", dbs_home).execute

# Backup the directories
CreateDirectoriesCommand.new("Creating directories", dirs_home).execute
directories.each do |backup_name, directory|
  compressed = "#{dirs_home}/#{backup_name}-#{timestamp}.tar.bz2"
  CompressCommand.new('Compressing', directory, compressed).execute
  encrypted = "#{compressed}.gpg"
  EncryptCommand.new('Encrypting', compressed, encrypted).execute
  DeleteCommand.new('Deleting compressed file', compressed).execute
  DeleteOldFilesCommand.new('Deleting backups older than 30 days', dirs_home).execute
end

