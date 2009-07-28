class Command

  attr_accessor :message
  
  def execute
    puts log_message
    system(command_line)
  end
  
  def log_message
    "#{message} '#{command_line}'"
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

class CreateDirectoriesCommand < Command
  attr_accessor :path
  
  def initialize(message, path)
    self.message = message
    self.path = path
  end
  
  def command_line
    "#{MKDIR} -p #{path}"
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

class DeleteOldFilesCommand < Command
  attr_accessor :path
  
  def initialize(message, path)
    self.message = message
    self.path = path
  end
  
  def command_line
    "#{FIND} #{path}/* -mtime +30 -delete"
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

