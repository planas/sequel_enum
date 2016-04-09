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
            values = Hash[values.map.with_index { |v, i| [v, i] }]
          else
            raise ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { :literal => number }"
          end

          define_method :[]= do |key, value|
            if column.to_sym == key.to_sym
              index = self.class.enums[column].rassoc(value)
              @value = (index && index.first)
            end
            super(key, value)
          end

          define_method "#{column}=" do |value|
            index = self.class.enums[column].assoc(value)
            @value = (index && index.first)
            self[column] = self.class.enums[column].fetch(@value, nil)
          end

          define_method "#{column}" do
            unless @value
              index = self.class.enums[column].rassoc(self[column])
              @value = (index && index.first)
            end
            @value
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
