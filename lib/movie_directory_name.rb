# frozen_string_literal: true

require 'forwardable'

class Regexp

  def +(other)
    Regexp.new(self.to_s + other.to_s)
  end

end

# Common regular expressions for movie years
module YearRegexps
  def year_regexp
    /(19|20)\d{2}/
  end

  def year_in_parens_regexp
    /\(/ + year_regexp + /\)/
  end
end

# Wrapper around a particular strategy
class MovieDirectoryName
  extend Forwardable
  def_delegators :@delegate, :year, :movie

  def initialize(name)
    @delegate = ParensYearName.applies_to?(name) ? ParensYearName.new(name) : DottedName.new(name)
  end

end

# Something like 'Spontaneous (2020)'
class ParensYearName

  include YearRegexps
  extend YearRegexps

  def self.applies_to?(a_string)
    !!a_string[year_in_parens_regexp]
  end

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
    @name[year_in_parens_regexp]
  end

  def year_substring_no_parens
    year_substring[1..-2]
  end
end

class DottedName

  include YearRegexps

  def initialize(name)
    @name = name.gsub(".", " ")
  end

  def year
    @name[year_index..(year_index+3)].to_i
  end

  def movie
    @name[0..(year_index-1)].strip
  end

  private

  def year_index
    @name.index(year_regexp)
  end

end
