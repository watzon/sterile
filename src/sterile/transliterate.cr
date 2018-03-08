require "./data/codepoints_data"
require "extensions/src/core/object"

module Sterile
  extend self

  def transmogrify(string, &block)
    result = ""
    string.codepoints.each do |codepoint|
      cg = codepoint >> 8
      cp = codepoint & 0xFF
      if cg_data = Data.codepoints_data[cg]
        if mapping = cg_data[cp]
          result += yield(mapping, codepoint)
        end
      end
    end
    result
  end

  # Transliterate Unicode [and accented ASCII] characters to their plain-text
  # ASCII equivalents. This is based on data from the stringex gem (https://github.com/rsl/stringex)
  # which is in turn a port of Perl's Unidecode and ostensibly provides
  # superior results to iconv. The optical conversion data is based on work
  # by Eric Boehs at https://github.com/ericboehs/to_slug
  # Passing an option of :optical => true will prefer optical mapping instead
  # of more pedantic matches.
  #
  #   "ýůçký".transliterate # => "yucky"
  #
  def transliterate(string, optical = false)
    if optical
      transmogrify(string) do |mapping, codepoint|
        mapping[1] || mapping[0] || ""
      end
    else
      transmogrify(string) do |mapping, codepoint|
        mapping[0] || mapping[1] || ""
      end
    end
  end

  alias_method :to_ascii, :transliterate
end
