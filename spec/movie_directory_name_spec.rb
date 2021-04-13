require 'movie_directory_name'

describe MovieDirectoryName do

  it 'should parse simple names' do
    name = MovieDirectoryName.new('Spontaneous (2020)')
    expect(name.movie).to eql('Spontaneous')
    expect(name.year).to eql(2020)
  end

  # The.Shape.of.Water.2017.1080p.BluRay.x264-SPARKS[hotpena]


end