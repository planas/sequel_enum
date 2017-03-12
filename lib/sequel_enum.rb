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
            self[column] = self.class.enums[column].assoc(value.to_sym)&.last
          end

          define_method "#{column}" do
            self.class.enums[column].rassoc(self[column])&.first
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
