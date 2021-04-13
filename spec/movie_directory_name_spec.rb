require 'movie_nas'

describe MovieDirectoryName do

  it "should parse simple names" do
    name = MovieDirectoryName.new('Spontaneous (2020)')
    expect(name.movie).to eql('Spontaneous')
    expect(name.year).to eql(2020)
  end
end