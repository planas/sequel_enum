module Sequel
  module Plugins
    module Enum
      def self.apply(model, opts = OPTS)
      end

      module ClassMethods
        
        def enums
          @enums ||= {}
        end

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
            val = self.class.enums[column].assoc(value.to_sym)
            self[column] = val && val.last
          end

          define_method "#{column}" do
            val = self.class.enums[column].rassoc(self[column])
            val && val.first
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
