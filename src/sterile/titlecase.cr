module Sterile
  extend self

  def titlecase(string)
    lsquo = 8216.chr
    rsquo = 8217.chr
    ldquo = 8220.chr
    rdquo = 8221.chr
    ndash = 8211.chr

    string = string.strip
    string = string.gsub(/\s+/, " ")
    string = string.downcase unless string =~ /[[:lower:]]/

    small_words = %w{a an and as at(?!&t) but by en for if in nor of on or the to v[.]? via vs[.]?}.join("|")
    apos = / (?: ['#{rsquo}] [[:lower:]]* )? /x

    string = string.gsub(
      /
        \b
        ([_\*]*)
        (?:
          ( [-\+\w]+ [@.\:\/] [-\w@.\:\/]+ #{apos} )      # URL, domain, or email
          |
          ( (?i: #{small_words} ) #{apos} )               # or small word, case-insensitive
          |
          ( [[:alpha:]] [[:lower:]'#{rsquo}()\[\]{}]* #{apos} )  # or word without internal caps
          |
          ( [[:alpha:]] [[:alpha:]'#{rsquo}()\[\]{}]* #{apos} )  # or some other word
        )
        ([_\*]*)
        \b
      /x
    ) do |s|
      (s[1]? ? s[1].to_s : "") +
        (s[2]? ? s[2].to_s : (s[3]? ? s[3].to_s.downcase : (s[4]? ? s[4].to_s.upcase : s[5].to_s))) +
        (s[6]? ? s[6].to_s : "")
    end

    string = string.gsub(
      /
        (
          \A [[:punct:]]*     # start of title
          | [:.;?!][ ]+       # or of subsentence
          | [ ]['"#{ldquo}#{lsquo}(\[][ ]*  # or of inserted subphrase
        )
        ( #{small_words} )    # followed by a small-word
        \b
      /xi
    ) do |s|
      s[1].to_s + s[2].to_s.upcase
    end

    string = string.gsub(
      /
        \b
        ( #{small_words} )    # small-word
        (?=
          [[:punct:]]* \Z     # at the end of the title
          |
          ['"#{rsquo}#{rdquo})\]] [ ]       # or of an inserted subphrase
        )
      /x
    ) do |s|
      s[1].to_s.downcase.capitalize
    end

    string = string.gsub(
      /
        (
          \b
          [[:alpha:]]         # single first letter
          [\-#{ndash}]               # followed by a dash
        )
        ( [[:alpha:]] )       # followed by a letter
      /x
    ) do |s|
      s[1].to_s + s[2].to_s.downcase
    end

    string = string.gsub(/q&a/i, "Q&A")

    string
  end
end
