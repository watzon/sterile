require "./data/smart_format_rules"

module Sterile
    # Format text with proper "curly" quotes, m-dashes, copyright, trademark, etc.
    #
    #   q{"He said, 'Away with you, Drake!'"}.smart_format # => “He said, ‘Away with you, Drake!’”
    #
    def smart_format(string)
      Data.smart_format_rules.each do |rule|
        string = string.gsub rule[0], rule[1]
      end
      string
    end

    # Like +smart_format+, but works with HTML/XML (somewhat).
    #
    def smart_format_tags(string)
      string.gsub_tags do |text|
        text.smart_format
      end.encode_entities.gsub(/(\<\/\w+\>)&ldquo;/, "\\1&rdquo;").gsub(/(\<\/\w+\>)&lsquo;/, "\\1&rsquo;")
    end
end
