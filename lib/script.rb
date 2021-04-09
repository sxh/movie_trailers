require 'mechanize'
require 'json'

api_key = '9c762f8e2cb0c83962e7c51008e43906'

class MovieDb

  def initialize(mechanize_page)
    @json = JSON.parse(mechanize_page.body)
  end

  def results
    @json['results']
  end

end

# result of calling the videos api for a given movie
class MovieVideos < MovieDb

  # def initialize(mechanize_page)
  #   @json = JSON.parse(mechanize_page.body)
  # end

  def youtube_ids
    results
      .select{|each| each['type'].eql?('Trailer') && each['site'].eql?('YouTube') }
      .collect{|each| each['key']}
  end

end

class Movie

  def initialize(movie_id)
    @movie_id = movie_id
  end

  def videos
    api_key = '9c762f8e2cb0c83962e7c51008e43906'
    agent = Mechanize.new
    page = agent.get("https://api.themoviedb.org/3/movie/#{@movie_id}/videos?api_key=#{api_key}")
    MovieVideos.new(page)
  end

end

# result of calling the a search
class Search < MovieDb

  def initialize()
    api_key = '9c762f8e2cb0c83962e7c51008e43906'
    agent = Mechanize.new
    name = 'Jack Reacher'
    year = 2012
    page = agent.get("https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{CGI.escape(name)}&year=#{year}")
    super(page)
  end

  def movie_ids
    results.collect{ |each| each['id'] }
  end

  def movies
    movie_ids.collect{ |each| Movie.new(each) }
  end

end

class Trailer

  def initialize(youtube_video_id)
    @vid = youtube_video_id
  end

  def download
    system("youtube-dl -o '~/Movies/%(title)s-trailer.%(ext)s' #{@vid} --restrict-filenames", exception: true)
  end

end

search = Search.new()
pp search.movie_ids

search.movies.each do |movie|
  # page = agent.get("https://api.themoviedb.org/3/movie/#{movie_id}/videos?api_key=#{api_key}")
  trailer_ids = movie.videos.youtube_ids
  trailer_ids.each do |vid|
    Trailer.new(vid).download
  end
  pp trailer_ids
end
