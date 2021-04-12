# frozen_string_literal: true

require 'mechanize'
require 'json'

module TheMovieDb
  # utility class for anything retrieved from The MovieDB api
  class MovieDbApi
    attr_reader :api_called, :api_results, :json

    def initialize(api_base, query_parameters = '')
      @api_called = api_url_from(api_base, query_parameters)
      page = Mechanize.new.get(@api_called)
      @api_results = page.body
      @json = JSON.parse(api_results)
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
  end

  # result of calling the videos api for a given movie
  class MovieVideos < MovieDbApi
    def initialize(tmdb_movie_id)
      super("/movie/#{tmdb_movie_id}/videos")
    end

    def trailers
      trailer_results.collect { |each| TrailerVideo.new(each['key'], each['size']) }
    end

    def best_trailer
      trailers.max_by(&:size)
    end

    private

    def trailer_results
      filtered = results.select { |each| each['type'].eql?('Trailer') && each['site'].eql?('YouTube') }
      if filtered.empty?
        puts "Didn't find any trailer information using #{api_called}"
        puts "Json returned was #{json}"
      end
      filtered
    end
  end

  # result of calling the a search
  class Search < MovieDbApi
    def initialize(name, year)
      super('/search/movie', "&query=#{CGI.escape(name)}&year=#{year}")
    end

    def movies
      results = movie_ids.collect { |each| Movie.new(each) }
      if results.empty?
        puts "Nothing movies found searching #{api_called}"
        puts "Json returned was #{json}"
      end
      results
    end

    private

    def movie_ids
      results.collect { |each| each['id'] }
    end
  end

  # Single movie, source of all related videos
  class Movie
    def initialize(movie_id)
      @tmdb_movie_id = movie_id
    end

    def videos
      MovieVideos.new(@tmdb_movie_id)
    end
  end

  # Single video, that we believe is a trailer
  class TrailerVideo
    attr_reader :size

    def initialize(youtube_video_id, size)
      @vid = youtube_video_id
      @size = size
    end

    def download_to(path)
      destination = "#{path}/%(title)s-trailer.%(ext)s"
      system("youtube-dl -o '#{destination}' #{@vid} --restrict-filenames", exception: true)
    rescue Exception => e
      puts e.to_s
    end
  end
end
