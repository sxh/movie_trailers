# frozen_string_literal: true

require_relative 'movie_db'
require_relative 'movie_nas'

MovieLibrary.new.movie_directories.reject(&:has_trailer?).each do |dir|
  pp dir.has_trailer?
  pp dir.name.year
  pp dir.name.movie
  Search.new(dir.name.movie, dir.name.year).movies.each do |movie|
    movie.videos.trailers.each(&:download)
  end

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
