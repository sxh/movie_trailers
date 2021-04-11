# frozen_string_literal: true

require_relative 'movie_db'
require_relative 'movie_nas'

MovieLibrary.new.movie_directories.reject(&:has_trailer?).each do |dir|
  puts '*************************************************************************'
  puts "No trailers found for #{dir.name.movie} #{dir.name.year}"
  puts '*************************************************************************'
  TheMovieDb::Search.new(dir.name.movie, dir.name.year).movies.each do |movie|
    movie.videos.trailers.each(&:download)
  end

end
