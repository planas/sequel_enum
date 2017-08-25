module Sequel
  module Plugins
    module Enum
      def self.apply(model, opts = OPTS)
        model.instance_eval do
          @enums = {}
        end
      end

      module ClassMethods
        attr_reader :enums
        def enum(column, values)
          if values.is_a? Hash
            values.each do |key,val|
              raise ArgumentError, "index should be a symbol, #{key} provided which it's a #{key.class}" unless key.is_a? Symbol
              raise ArgumentError, "value should be an integer, #{val} provided which it's a #{val.class}" unless val.is_a? Integer
            end
          elsif values.is_a? Array
            values = Hash[values.map.with_index { |v, i| [v, i] }]
          else
            raise ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { :symbol => integer }"
          end

          define_method "#{column}=" do |value|
            if value.is_a? Integer 
              values.each do |k,v|
                if v == value
                  self[column] = value
                end
                raise(ArgumentError,"Not a valid #{column}") if self[column].nil?
              end
            else
              val = self.class.enums[column].assoc(value.to_sym)
              self[column] = val && val.last
            end
          end

          define_method "#{column}" do
            val = self.class.enums[column].rassoc(self[column])
            val && val.first
          end
          
          define_method "#{column}?" do |value|
            if value.is_a? Symbol
              self.send(column) == value
            elsif value.is_a? Integer
              self[column] == value
            else
              raise ArgumentError
            end
          end
          
          define_singleton_method "#{column}" do
            self.enums[column]
          end

          values.each do |key, value|
            define_method "#{key}?" do
              self.send(column) == key
            end
          end

          self.enums[column] = values
        end
      end
    end
  end
end
