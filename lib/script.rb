# frozen_string_literal: true

require_relative 'movie_db'
require_relative 'movie_nas'

# change code copy videos to target directory
MovieLibrary.new("/Volumes/Media/Movies").movie_directories.reject(&:has_trailer?).each do |movie_directory|
  puts '*************************************************************************'
  puts "Haven't sourced trailers found for #{movie_directory.name.movie} #{movie_directory.name.year}"
  puts '*************************************************************************'
  TheMovieDb::Search.new(movie_directory.name.movie, movie_directory.name.year).movies.each do |movie|
    movie.videos.trailers.each{|trailer| trailer.download_to(movie_directory.path)}
  end

end
