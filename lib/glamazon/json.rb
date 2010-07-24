module Glamazon
  module JSON
    def to_json
      encoder.encode attributes
    end
    
    def encoder
      @encoder ||= ::Yajl::Encoder.new
    end
  end
end