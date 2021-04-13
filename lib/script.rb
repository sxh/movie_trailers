# frozen_string_literal: true

require_relative 'movie_db'
require_relative 'movie_nas'

# change code copy videos to target directory
MovieLibrary.new('/Volumes/Media/Movies').movie_directories.reject(&:has_trailer?).each do |movie_directory|
  puts '*************************************************************************'
  puts "Haven't previously sourced trailers for #{movie_directory.name.movie} #{movie_directory.name.year}"
  puts "Searching for trailers now"
  puts '*************************************************************************'
  TheMovieDb::Search.new(movie_directory.name.movie, movie_directory.name.year).movies.each do |movie|
    movie.videos.best_trailer&.download_to(movie_directory.path)
  end
end

puts "Finished scanning movies for trailers"
