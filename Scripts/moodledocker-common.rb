require 'pathname'

module MoodleDocker
  @base_dir = File.dirname(File.dirname(__dir__))
  @forbidden_names = ['Metafiles']

  def self.base_dir
    return @base_dir
  end

  def self.script_dir
    return @base_dir + "/Metafiles/Scripts"
  end

  def self.forbidden_names
    return @forbidden_names
  end

  def self.php_default
    return 'php-7.4'
  end

  def self.php_options
    return Dir.children("#{File.dirname(__dir__)}/Dockerfiles/php")
  end

  def self.db_default
    return 'psql-10.4'
  end

  def self.db_options
    return Dir.children("#{File.dirname(__dir__)}/Dockerfiles/db")
  end

  def self.name_valid? (name)
    if name =~ /[^\w\.]/
      puts "Error: Target name \"#{name}\" invalid. Please specify a proper string (a-zA-Z0-9\\.)."
      return false
    end

    if self.forbidden_names.include? (name)
      puts "Error: Target name \"#{name}\" is not allowed, please choose another one."
      return false
    end

    return true
  end

  def self.project_exists? (name)
    # Asserts that the name is valid! Does not perform ANY sanitizing AT ALL.
    return File.directory?(self.base_dir + "/" + name)
  end

  def self.project_path (path)
    # Look for a project with a moodle link which leads to the current path
    dirs = Dir.entries(self.base_dir).select { |entry| File.directory? File.join(self.base_dir,entry) and
        !(entry =='.' || entry == '..') and
        File.exists? File.join(self.base_dir,entry,"moodle")}
    links = []
    dirs.each do |entry|
      dirname = File.join(self.base_dir, entry, 'moodle')
      if File.symlink? (dirname) # Follow link.
        links << File.readlink(dirname)
      else
        links << dirname
      end
    end
    pathname = Pathname.new(path)
    return links.select {|entry| pathname.fnmatch?(File.join(entry,'**'))}.first()
  end

  def self.project_name (path)
    # Look for a project with a moodle link which leads to the current path
    dirs = Dir.entries(self.base_dir).select { |entry| File.directory? File.join(self.base_dir,entry) and
        !(entry =='.' || entry == '..') and
        File.exists? File.join(self.base_dir,entry,"moodle")}
    pathname = Pathname.new(path)
    return dirs.select {|entry| pathname.fnmatch?(File.join(File.readlink(File.join(self.base_dir,entry,"moodle")),'**'))}.first()
  end
end
