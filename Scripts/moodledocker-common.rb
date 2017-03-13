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
end