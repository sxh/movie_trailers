# frozen_string_literal: true

require 'forwardable'

# Wrapper around a particular strategy
class MovieDirectoryName
  extend Forwardable
  def_delegators :@delegate, :year, :movie

  def initialize(name)
    @delegate = MovieDirectoryNameWithParenthesisedYear.new(name)
  end
end

# Something like 'Spontaneous (2020)'
class MovieDirectoryNameWithParenthesisedYear
  def initialize(name)
    @name = name
  end

  def year
    year_substring_no_parens.to_i
  end

  def movie
    @name.gsub(year_substring, '').strip
  end

  private

  def year_substring
    @name[/\(\d+\)/]
  end

  def year_substring_no_parens
    year_substring[1..-2]
  end
end
