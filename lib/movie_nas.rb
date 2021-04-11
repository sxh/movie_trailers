# frozen_string_literal: true
#
require 'pathname'

class MovieLibrary
  def initialize
    @base_directory = "/Volumes/Media/Movies"
  end

  def movie_directories
    Pathname('/Volumes/Media/Movies').children.select(&:directory?).collect{|e| MovieDirectory.new(e)}
  end

end

class MovieDirectory
  def initialize(pathname)
    @pathname = pathname
  end
  def has_trailer?
    @pathname.children.reject(&:directory?).collect{|e| MovieFile.new(e)}.any?(&:is_trailer?)
  end

  def name
    MovieDirectoryName.new(basename)
  end

  private
  def basename
    File.basename(@pathname)
  end
end

class MovieDirectoryName
  def initialize(name)
    @name = name
  end

  def move_year
    year_substring_no_parens.to_i
  end

  def movie_name
    @name.gsub(year_substring, '').strip
  end

  private

  def year_substring
    @name[/\(\d+\)/]
  end

  def year_substring_no_parens
    year_substring[1..-2]
  end

end

class MovieFile
  def initialize(pathname)
    @pathname = pathname
  end

  def is_trailer?
    basename_without_ext.end_with?('-trailer')
  end

  def basename_without_ext
    File.basename(@pathname, ".*")
  end

end


