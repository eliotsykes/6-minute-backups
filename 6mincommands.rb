class Command

  attr_accessor :message
  
  def execute
    if (enabled?)
      puts log_message
      command_lines.each do |command_line|
        system(command_line)
      end
    end
  end
  
  def command_lines
    command_line
  end
  
  def log_message
    "#{message} '#{command_line}'"
  end
  
  def enabled?
    true
  end
  
end

class CompressCommand < Command
  attr_accessor :to_compress, :compressed
  
  def initialize(message, to_compress, compressed)
    self.message = message
    self.to_compress = to_compress
    self.compressed = compressed
  end
  
  def command_line
    "#{TAR} -cjf #{compressed} #{to_compress}"
  end
end

class CreateBackupDirectoriesCommand < Command
  attr_accessor :path
  
  def initialize(path)
    self.message = 'Creating backup directories'
    self.path = path
  end
  
  def command_lines
    return [
      "#{MKDIR} -p #{path}/#{WEEKLIES_DIR}",
      "#{MKDIR} #{path}/#{MONTHLIES_DIR}"
    ]
  end
  
  def enabled?
    !File.exists?("#{path}/#{WEEKLIES_DIR}") || !File.exists?("#{path}/#{MONTHLIES_DIR}") 
  end
end

class DeleteCommand < Command
  attr_accessor :to_delete
  
  def initialize(message, to_delete)
    self.message = message
    self.to_delete = to_delete
  end
  
  def command_line
    "#{RM} -f #{to_delete}"
  end
end

# Deletes old backup files, which are:
# - all but the last 7 days of dailies
# - all but the last month (31 days) of weeklies
# - all but the last year (365 days) of monthlies
class DeleteOldFilesCommand < Command
  attr_accessor :path
  
  def initialize(path)
    self.message = "Deleting old backups (dailies, weeklies, and monthlies)"
    self.path = path
  end
  
  def command_lines
    # The -prune option ensures that only files in that directory are listed. No
    # subdirectories are shown.
    return [
      "#{FIND} #{path}/*.gpg -mtime +7 -print -prune | xargs rm",
      "#{FIND} #{path}/#{WEEKLIES_DIR}/*.gpg -mtime +31 -print -prune | xargs rm",
      "#{FIND} #{path}/#{MONTHLIES_DIR}/*.gpg -mtime +365 -print -prune | xargs rm"
    ]
  end
end

class EncryptCommand < Command
  attr_accessor :to_encrypt, :encrypted
  
  def initialize(message, to_encrypt, encrypted)
    self.message = message
    self.to_encrypt = to_encrypt
    self.encrypted = encrypted
  end
  
  def command_line
    # Command to encrypt with pgp - http://www.madboa.com/geek/gpg-quickstart/
    # --always-trust prevents prompt so the script can run unattended.
    "#{GPG} --encrypt --always-trust --recipient '#{GPG_RECIPIENT}' --output #{encrypted} #{to_encrypt}"  
  end
end

class MysqlDumpCommand < Command
  
  attr_accessor :output
  
  def initialize(message, output)
    self.message = message
    self.output = output
  end
  
  def command_line
    # --single-transaction is good for backing up InnoDB
    # Dump to a sql file first, don't compress at the same time to reduce the time
    # we're using mysqldump which is probably a good thing.
    "#{MYSQLDUMP} --single-transaction --databases #{DATABASES} --user=#{MYSQL_USER} --password='#{MYSQL_PWD}' > #{output}"
  end
  
  def log_message
    # Overidden so the password is not output to the screen.
    "#{message} #{DATABASES} to '#{output}'"
  end
end

class GraduateCommand < Command
  attr_accessor :source, :target
  
  def initialize(source, graduation_dir)
    self.source = source
    self.target = "#{File.dirname(source)}/#{graduation_dir}"
    self.message = "Graduating to '#{graduation_dir}'"
  end
  
  def command_line
    "#{CP} #{source} #{target}"
  end
  
  def now
    Time.now.utc
  end
  
end

class WeeklyGraduateCommand < GraduateCommand
  
  def initialize(source)
    super(source, WEEKLIES_DIR)
  end
  
  def enabled?
    monday?
  end
  
  def monday?
    # Returns the day of the week as a number, where 0 = Sunday, 1 = Mon, etc.
    now.strftime("%w") == 1
  end
end

class MonthlyGraduateCommand < GraduateCommand
  
  def initialize(source)
    super(source, MONTHLIES_DIR)
  end
  
  def enabled?
    first_of_the_month?
  end
  
  def first_of_the_month?
    now.day == 1
  end
end
