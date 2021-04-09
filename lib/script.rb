require 'mechanize'
require 'json'

class MovieDb

  def initialize(mechanize_page)
    @json = JSON.parse(mechanize_page.body)
  end

  def results
    @json['results']
  end

  def agent
    @agent ||= Mechanize.new
  end

  def get(url)
    agent.get(url)
  end

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
class MovieVideos < MovieDb

  def initialize(movie_id)
    url = api_url_from("/movie/#{movie_id}/videos")
    super(agent.get(url))
  end

  def youtube_ids
    results
      .select{|each| each['type'].eql?('Trailer') && each['site'].eql?('YouTube') }
      .collect{|each| each['key']}
  end

  def trailers
    youtube_ids.collect{ |each| TrailerVideo.new(each) }
  end

end

class Movie

  def initialize(movie_id)
    @movie_id = movie_id
  end

  def videos
    MovieVideos.new(@movie_id)
  end

end

# result of calling the a search
class Search < MovieDb

  def initialize(name, year)
    api_key = '9c762f8e2cb0c83962e7c51008e43906'
    # agent = Mechanize.new
    page = agent.get("https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{CGI.escape(name)}&year=#{year}")
    super(page)
  end

  def movies
    movie_ids.collect{ |each| Movie.new(each) }
  end

  private

  def movie_ids
    results.collect{ |each| each['id'] }
  end

end

class TrailerVideo

  def initialize(youtube_video_id)
    @vid = youtube_video_id
  end

  def download
    system("youtube-dl -o '~/Movies/%(title)s-trailer.%(ext)s' #{@vid} --restrict-filenames", exception: true)
  end

end

name = 'Jack Reacher'
year = 2012
Search.new(name, year).movies.each do |movie|
  movie.videos.trailers.each(&:download)
end
