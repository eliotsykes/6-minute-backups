require 'yaml'

confpath = [File.expand_path(File.dirname(__FILE__)), "#{ENV['HOME']}/.6minbackup"]

confpath.each do |path|
  if File.exists?(path) && File.directory?(path) && File.exists?("#{path}/6minbackup.yml")
    CONFIG = YAML.load_file("#{path}/6minbackup.yml")
    break
  end
end

MYSQLDUMP=CONFIG["mysqldump"]
TAR=CONFIG["tar"]
MKDIR=CONFIG["mkdir"]
DATABASES=CONFIG["databases"]
MYSQL_USER=CONFIG["mysql_user"]
MYSQL_PWD=CONFIG["mysql_pwd"]
GPG=CONFIG["gpg"]
GPG_RECIPIENT=CONFIG["gpg_recipient"]
RM=CONFIG["rm"]
FIND=CONFIG["find"]
CP=CONFIG["cp"]
WEEKLIES_DIR = 'weeklies'
MONTHLIES_DIR = 'monthlies'
