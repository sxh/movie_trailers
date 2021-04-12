# frozen_string_literal: true

require_relative 'movie_db'
require_relative 'movie_nas'

# change code copy videos to target directory
MovieLibrary.new("/Volumes/Media/Movies").movie_directories.reject(&:has_trailer?).each do |dir|
  puts '*************************************************************************'
  puts "No trailers found in #{dir.path}"
  puts "No trailers found for #{dir.name.movie} #{dir.name.year}"
  puts '*************************************************************************'
  TheMovieDb::Search.new(dir.name.movie, dir.name.year).movies.each do |movie|
    movie.videos.trailers.each(&:download)
  end

end
