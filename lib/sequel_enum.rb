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

        def symbolize(hash)
          self.enums.each do |key, val|
            s_key = key.to_s
            hash[key] = hash[key].to_sym if hash[key]
            hash[s_key] = hash[s_key].to_sym if hash[s_key]
          end
          hash
        end

        def enum(column, values)
          if values.is_a? Hash
            values.each do |key,val|
              raise ArgumentError, "index should be numeric, #{key} provided wich it's a #{key.class}" unless key.is_a? Fixnum
              raise ArgumentError "value should be a symbol, #{val} provided wich it's a #{val.class}" unless val.is_a? Symbol
            end
          elsif values.is_a? Array
            values = Hash[values.map.with_index { |v, i| [i,v] }]
          else
            raise ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { index => :value }"
          end

          define_method "update" do |hash|
            super self.class.symbolize(hash)
          end

          define_method "initialize_set" do |hash = {}|
            super self.class.symbolize(hash)
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

          enums[column] = values
        end
      end
    end
  end
end
