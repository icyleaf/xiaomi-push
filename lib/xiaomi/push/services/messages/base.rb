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

          unless value
            instance_variable_get key
          else
            instance_variable_set key, value
          end
        end

        def build
          hash_data = {}
          instance_variables.each do |ivar|
            key = ivar.to_s.gsub('@', '')
            value = instance_variable_get ivar

            if value
              unless key == 'extras'
                hash_data[key] = value
              else
                value.each do |k, v|
                  key = "extra.#{k}"
                  hash_data[key] = v
                end
              end
            end
          end

          hash_data
        end
      end
    end
  end
end
