require 'mechanize'
require 'json'

api_key = '9c762f8e2cb0c83962e7c51008e43906'

class Videos
  def initialize(mechanize_page)
    @json = JSON.parse(mechanize_page.body)
  end

  def youtube_ids
    @json["results"]
      .select{|each| each["type"].eql?("Trailer") && each["site"].eql?("YouTube") }
      .collect{|each| each['key']}
  end

end

agent = Mechanize.new
page = agent.get("https://api.themoviedb.org/3/movie/550/videos?api_key=#{api_key}")
content = page.body
json_response = JSON.parse(content)
pp Videos.new(page).youtube_ids

# https://api.themoviedb.org/3/movie/550?api_key=9c762f8e2cb0c83962e7c51008e43906
#
# https://api.themoviedb.org/3/movie/550/videos?api_key=9c762f8e2cb0c83962e7c51008e43906

