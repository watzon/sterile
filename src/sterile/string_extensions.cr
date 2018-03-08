module Sterile

  module StringExtensions
    macro included
      {% for method in Sterile.methods %}
        # def {{method.name}}(*args, &block); Sterile.{{method.name}}(self, *args, &block); end
        def {{method.name}}(*args); Sterile.{{method.name}}(self, *args); end
      {% end %}
    end
  end

end


class String
  include Sterile::StringExtensions
end
