# frozen_string_literal: true

require 'mechanize'
require 'json'

# utility class for anything retrieved from The MovieDB api
class MovieDbApi
  def initialize(api_base, query_parameters = '')
    page = api_page_from(api_base, query_parameters)
    @json = JSON.parse(page.body)
  end

  def results
    @json['results']
  end

  private

  def base_url
    'https://api.themoviedb.org/3'
  end

  def auth
    api_key = '9c762f8e2cb0c83962e7c51008e43906'
    "?api_key=#{api_key}"
  end

  def api_url_from(api_base, query_parameters = '')
    base_url + api_base + auth + query_parameters
  end

  def api_page_from(api_base, query_parameters = '')
    Mechanize.new.get(api_url_from(api_base, query_parameters))
  end
end

# result of calling the videos api for a given movie
class MovieVideos < MovieDbApi
  def initialize(movie_id)
    super("/movie/#{movie_id}/videos")
  end

  def trailers
    trailer_youtube_ids.collect { |each| TrailerVideo.new(each) }
  end

  private

  def trailer_youtube_ids
    results
      .select { |each| each['type'].eql?('Trailer') && each['site'].eql?('YouTube') }
      .collect { |each| each['key'] }
  end
end

# result of calling the a search
class Search < MovieDbApi
  def initialize(name, year)
    super('/search/movie', "&query=#{CGI.escape(name)}&year=#{year}")
  end

  def movies
    movie_ids.collect { |each| Movie.new(each) }
  end

  private

  def movie_ids
    results.collect { |each| each['id'] }
  end
end

# Single movie, source of all related videos
class Movie
  def initialize(movie_id)
    @movie_id = movie_id
  end

  def videos
    MovieVideos.new(@movie_id)
  end
end

# Single video, that we believe is a trailer
class TrailerVideo
  def initialize(youtube_video_id)
    @vid = youtube_video_id
  end

  def download
    begin
      system("youtube-dl -o '~/Movies/%(title)s-trailer.%(ext)s' #{@vid} --restrict-filenames", exception: true)
    rescue Exception => e
      puts e.to_s
    end
  end
end

