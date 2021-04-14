# frozen_string_literal: true

require 'forwardable'

# Extension to base class
class Regexp
  def +(other)
    Regexp.new(to_s + other.to_s)
  end
end

class String
  def without_domain_names
    gsub(/www\..*\.org/, '')
  end

  def without_dots
    gsub('.', ' ')
  end

end

module MovieNas
  # Common regular expressions for movie years
  module YearRegexps
    def year_only_regexp
      /(19|20)\d{2}/
    end

    def year_in_parens_regexp
      /\(/ + year_only_regexp + /\)/
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

  # abstract class with common code
  class NameWithYear
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def movie
      @name[0..(year_index - 1)].strip
    end

    private

    def year_index
      @name.index(year_regexp)
    end
  end

  # Something like 'Spontaneous (2020)'
  class ParensYearName < NameWithYear
    include YearRegexps
    extend YearRegexps

    def self.applies_to?(a_string)
      !!a_string[year_in_parens_regexp]
    end

    def year
      name[(year_index + 1)..(year_index + 4)].to_i
    end

    def year_regexp
      year_in_parens_regexp
    end
  end

  # names like The.Shape.of.Water.2017.1080p.BluRay.x264-SPARKS
  class DottedName < NameWithYear
    include YearRegexps

    def initialize(name)
      super(name.without_domain_names.without_dots)
    end

    def year
      name[year_index..(year_index + 3)].to_i
    end

    private

    def year_regexp
      year_only_regexp
    end
  end
end
