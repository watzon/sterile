module Sterile
  extend self

  # Turn Unicode characters into their HTML equivilents.
  # If a valid HTML entity is not possible, it will create a numeric entity.
  #
  #   q{“Economy Hits Bottom,” ran the headline}.encode_entities # => &ldquo;Economy Hits Bottom,&rdquo; ran the headline
  #
  def encode_entities(string)
    transmogrify(string) do |mapping, codepoint|
      if (32..126).include?(codepoint)
        mapping[0]
      else
        "&" + (mapping[2] || "#" + codepoint.to_s) + ";"
      end
    end
  end

  # The reverse of +encode_entities+. Turns HTML or numeric entities into
  # their Unicode counterparts.
  #
  def decode_entities(string)
    string = string.gsub(/&#(\d{1,4});/) { |s| [s[1].to_i].chr }
    string.gsub(/&([a-zA-Z0-9]+);/) do |s|
      codepoint = html_entities_data[s[1]].to_i
      codepoint ? codepoint.chr : s[0]
    end
  end
end
