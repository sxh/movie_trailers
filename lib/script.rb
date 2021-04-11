# frozen_string_literal: true

require_relative 'movie_db'
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
    File.basename(@pathname, ".*")
  end

end

class MovieDirectoryName
  def initialize(name)
    @name = name
  end

  def year
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
MovieLibrary.new.movie_directories.reject(&:has_trailer?).each do |dir|
  pp dir.basename
  pp dir.has_trailer?
  pp MovieDirectoryName.new(dir.basename).year
  pp MovieDirectoryName.new(dir.basename).movie_name
end


# [
#   ['A History of Violence', 2005],
#   ['City of God', 2002],
#   ['E.T. the Extra-Terrestrial', 1982],
#   ['End of Sentence', 2019],
#   ['Far from Heaven', 2002],
#   ['Lantana', 2001],
#   ['Praise', 1998],
#   ['Sex, Lies, and Videotape', 1989],
#   ['The Long Kiss Goodnight', 1996],
#   ['The Whistlers', 2019],
#   ['While We Were Young', 2014],
#   ['Working Man', 2020]
# ].each do |name, year|
#   Search.new(name, year).movies.each do |movie|
#     movie.videos.trailers.each(&:download)
#   end
# end
