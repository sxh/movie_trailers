# frozen_string_literal: true

require 'pathname'

require_relative 'movie_directory_name'

class MovieLibrary
  def initialize(base_path_string)
    @base_directory = base_path_string
  end

  def movie_directories
    Pathname('/Volumes/Media/Movies').children.select(&:directory?).collect { |e| MovieDirectory.new(e) }
  end
end

class MovieDirectory
  def initialize(pathname)
    @pathname = pathname
  end

  def has_trailer?
    @pathname.children.reject(&:directory?).collect { |e| MovieFile.new(e) }.any?(&:is_trailer?)
  end

  def name
    MovieDirectoryName.new(basename)
  end

  def path
    @pathname.to_s
  end

  private

  def basename
    File.basename(@pathname)
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
    File.basename(@pathname, '.*')
  end
end
