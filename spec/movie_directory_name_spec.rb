require 'movie_directory_name'

describe MovieDirectoryName do

  it 'should parse names like Spontaneous (2020)' do
    name = MovieDirectoryName.new('Spontaneous (2020)')
    expect(name.movie).to eql('Spontaneous')
    expect(name.year).to eql(2020)
  end

  it 'should parse names like The.Shape.of.Water.2017.1080p.BluRay.x264-SPARKS[hotpena]' do
    name = MovieDirectoryName.new('The.Shape.of.Water.2017.1080p.BluRay.x264-SPARKS[hotpena]')
    expect(name.movie).to eql('The Shape of Water')
    expect(name.year).to eql(2017)
  end

  #


end