module Xiaomi
  module Push
    module Message
      # 消息体的基本数据
      #
      # @abstract
      # @attr [String] registration_id reg id
      # @attr [String] alias 别名
      # @attr [String] topic 标签
      # @attr [String] user_account user account
      # @attr [String] topics 多个标签
      # @attr [String] topic_op 配合 topics 使用
      # @attr [String] extras 额外参数
      class Base
        attr_accessor :registration_id, :alias, :topic, :user_account, :topics, :topic_op, :extras

        # 设置或获取附加数据
        # @param [String] key
        # @param [String] value
        # @return [void]
        def extra(key, value = nil)
          unless value
            @extras[key]
          else
            @extras[key] = value
          end
        end

        # 设置或获取基本数据
        #
        # @param [String] key 设置 :registration_id, :alias, :topic, :user_account, :topics, :topic_op, :extras
        # @param [String] value
        # @return [void]
        def type(key, value = nil)
          key = "@#{key}"

          if value
            instance_variable_set key, value
          else
            instance_variable_get key
          end
        end

        # 组装消息体
        # @return [Hash] 消息体
        def build
          hash_data = {}
          instance_variables.each do |ivar|
            key = ivar.to_s.delete '@'
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
