module Glamazon
  module Finder
    def find(id)
      find_by_id([id]).first
    end
    def method_missing(meth, *args, &blk)
      # Dynamic finders, e.g. Klass.find_by_foo('bar)
      a = extract_attribute_from_method_name(meth)
      if /find_by_([_a-zA-Z]\w*)/.match(meth.to_s)
        self.class.instance_eval do
          define_method(meth) { |val| all.select { |o| o[a] == val.first } }
        end
        send meth, args
      elsif /find_or_create_by_([_a-zA-Z]\w*)/.match(meth.to_s)
        self.class.instance_eval do
          define_method(meth) { |val| send("find_by_#{a}", val) || create(a => val) }
        end
        send meth, args
      else
        super
      end
    end

    private

    def extract_attribute_from_method_name(meth)
      meth.to_s.gsub /\w+_by_/, ''
    end
  end
end