module Xiaomi
  module Push
    module Message
      class Base
        attr_accessor :registration_id, :alias, :topic, :topics, :topic_op, :extras

        def extra(key, value = nil)
          unless value
            @extras[key]
          else
            @extras[key] = value
          end
        end

        def type(key, value = nil)
          key = "@#{key}"

          if value
            instance_variable_set key, value
          else
            instance_variable_get key
          end
        end

        def build
          hash_data = {}
          instance_variables.each do |ivar|
            key = ivar.to_s.delete('@')
            value = instance_variable_get ivar

            next unless value

            if key == 'extras'
              value.each do |k, v|
                key = "extra.#{k}"
                hash_data[key] = v
              end
            else
              hash_data[key] = value
            end
          end

          hash_data
        end
      end
    end
  end
end
