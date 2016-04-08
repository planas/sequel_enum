module Sequel
  module Plugins
    module Enum
      def self.apply(model, opts = OPTS)
      end

      module ClassMethods
        attr_accessor :enums

        def enum(column, values)
          self.enums = {}
          if values.is_a? Hash
            values.each do |key,val|
              raise ArgumentError, "index should be a symbol, #{key} provided which it's a #{key.class}" unless key.is_a? Symbol
              raise ArgumentError "value should be numeric, #{val} provided which it's a #{val.class}" unless val.is_a? Fixnum
            end
          elsif values.is_a? Array
            values = Hash[values.map.with_index { |v, i| [i,v] }]
          else
            raise ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { index => :value }"
          end

          define_method "#{column}=" do |value|
            index = self.class.enums[column].rassoc(value)
            self[column] = index && index.first
          end

          define_method "#{column}" do
            self.class.enums[column].fetch(self[column], nil)
          end

          values.each do |key, value|
            define_method "#{value}?" do
              self.send(column) == value
            end
          end
          self.enums[column] = values
        end
      end
    end
  end
end
