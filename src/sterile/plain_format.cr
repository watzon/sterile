require "./data/plain_format_rules"

module Sterile

    def plain_format(string)
      Data.plain_format_rules.each do |rule|
        string = string.gsub rule[0], rule[1]
      end
      string
    end

    # Like +plain_format+, but works with HTML/XML (somewhat).
    #
    def plain_format_tags(string)
      string.gsub_tags do |text|
        text.plain_format
      end.encode_entities
    end
end
