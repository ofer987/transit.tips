ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

class Directory
  attr_reader :path

  def initialize(path)
    self.path = path.to_s.strip
  end

  def entries
    Dir.entries(path)
      .reject { |item| item == '.' }
      .reject { |item| item == '..' }
  end

  def files
    entries
      .map { |item| File.join(path, item) }
      .select { |item| File.file? item }
      .map { |item| Extension.new(item) }
  end

  def directories
    entries
      .map { |item| File.join(path, item) }
      .select { |item| File.directory? item }
      .map { |item| Directory.new(item) }
  end

  def load
    files.each { |item| item.load }
    directories.each { |item| item.load }
  end

  private

  attr_writer :path
end

class Extension
  attr_reader :path

  def initialize(path)
    self.path = path.to_s.strip
  end

  def load
    require path
  end

  private

  attr_writer :path
end

extensions = File.expand_path('../../app/extensions/', __FILE__)
Directory.new(extensions).load
