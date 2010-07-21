module Glamazon
  module JSON
    def to_json
      encoder.encode table
    end
    
    def encoder
      @encoder ||= Yajl::Encoder.new
    end
  end
end