require 'pathname'
require 'erb'
require 'yaml'

module MoodleDocker
  @base_dir = File.dirname(File.dirname(__dir__))
  @forbidden_names = ['Metafiles']

  class Foo
    attr_accessor :name, :configwwu
    def template_binding
      binding
    end
  end

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
    return 'php-8.3'
  end

  def self.php_options
    return Dir.children("#{File.dirname(__dir__)}/Dockerfiles/php").sort!
  end

  def self.db_default
    return 'psql-14'
  end

  def self.db_options
    return Dir.children("#{File.dirname(__dir__)}/Dockerfiles/db").sort!
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
        File.exist? File.join(self.base_dir,entry,"moodle")}
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

  def self.command_return_status (cmd)
    begin
      `#{cmd}`
      return $?.success?
    rescue Errno::ENOENT
      return false
    end
  end

  def self.find_docker_compose_name
    if self.command_return_status("docker compose")
      return "docker compose"
    end

    if self.command_return_status("docker-compose")
      return "docker-compose"
    end

    puts "Error: Could not find docker compose!"
    exit
  end

  def self.docker_compose_name
    @docker_compose_name ||= find_docker_compose_name
    return @docker_compose_name
  end

  def self.docker_delimiter
    if `#{self.docker_compose_name} version --short`.start_with?("2")
      return '-'
    else
      return '_'
    end
  end

  def self.project_name (path)
    # Look for a project with a moodle link which leads to the current path
    dirs = Dir.entries(self.base_dir).select { |entry| File.directory? File.join(self.base_dir,entry) and
        !(entry =='.' || entry == '..') and
        File.exist? File.join(self.base_dir,entry,"moodle")}
    pathname = Pathname.new(path)
    return dirs.select {|entry| pathname.fnmatch?(File.join(File.readlink(File.join(self.base_dir,entry,"moodle")),'**'))}.first()
  end

  def self.build_yaml (name, srcdir, refresh=false)
    FileUtils.cd(MoodleDocker.base_dir) do
      datadir = name + "/data"
      unless refresh
        FileUtils.mkdir([name, datadir, datadir + "/db", datadir + "/moodledata"])
      end

      remaining_php = MoodleDocker.php_options - [MoodleDocker.php_default]
      puts "PHP-Version? #{MoodleDocker.php_default} (Default), #{remaining_php.join(', ')}"
      input = $stdin.gets.chomp
      if MoodleDocker.php_options.include? input
        php = input
      else
        php = MoodleDocker.php_default
      end

      remaining_db = MoodleDocker.db_options - [MoodleDocker.db_default]
      puts "DB-Version? #{MoodleDocker.db_default} (Default), #{remaining_db.join(', ')}"
      input = $stdin.gets.chomp
      if MoodleDocker.db_options.include? input
        db = input
      else
        db = MoodleDocker.db_default
      end

      foo = Foo.new
      foo.name = name

      yaml = {
        "services" => {}
      }

      template = File.read("Metafiles/Dockerfiles/php/#{php}/docker-compose.erb")
      yaml['services']['php'] = YAML.load(ERB.new(template).result(foo.template_binding))['php']
      yaml['services']['php']['network_mode'] = 'bridge'

      template = File.read("Metafiles/Dockerfiles/db/#{db}/docker-compose.erb")
      yaml['services']['db'] = YAML.load(ERB.new(template).result(foo.template_binding))['db']
      yaml['services']['db']['network_mode'] = 'bridge'

      template = File.read("Metafiles/Dockerfiles/nginx/docker-compose.erb")
      yaml['services']['nginx'] = YAML.load(ERB.new(template).result(foo.template_binding))['nginx']
      yaml['services']['nginx']['network_mode'] = 'bridge'

      new_file = File.open("#{name}/docker-compose.yml", "w+")
      new_file << YAML.dump(yaml)
      new_file.close

      unless refresh
        puts "  Change owner of Moodledata directory to www-data (requires SU privileges)."
        system("sudo chown 33:33 " + datadir + "/moodledata")

        File.symlink(srcdir, name + "/moodle")
      end

      FileUtils.cp("Metafiles/Dockerfiles/php/#{php}/moodledev.ini", name + "/moodledev.ini")

      puts "Copy config? (0: No (Default), 1: copy config.php, 2: also include require(config-wwu.php)): "
      input = $stdin.gets.chomp

      if input == "2" then
        configwwu = true
      else
        configwwu = false
      end

      if input == "2" || input == "1" then
        new_file = File.open("#{srcdir}/config.php", "w+")
        template = File.read("Metafiles/Templates/config.erb")
        foo = Foo.new
        foo.name = name
        foo.configwwu = configwwu
        new_file << ERB.new(template).result(foo.template_binding)
        new_file.close
      end
    end
  end
end
