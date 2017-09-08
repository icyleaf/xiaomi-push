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

        # 转换为字典
        # @return [Hash] 消息体
        def to_params
          hash_data = {}
          instance_variables.each do |ivar|
            key = instance_key(ivar)

            if ios? && ios10_struct?
              key = ios10_struct(key)
            end

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

        def ios10_struct?
          return @ios10_struct unless @ios10_struct.nil?

          @ios10_struct = false

          keys = instance_variables.map {|e| instance_key(e) }
          %w(title subtitle).each do |key|
            return @ios10_struct = true if keys.include?(key)
          end

          @ios10_struct
        end

        def ios10_struct(key)
          key = 'body' if key == 'description'
          return key unless %w(title subtitle body).include?(key)

          "aps_proper_fields.#{key}"
        end

        def ios?
          current == 'IOS'
        end

        def android?
          current == 'ANDROID'
        end

        def current
          @current ||= self.class.name.split('::')[-1].upcase
        end

        private

        def instance_key(var)
          var.to_s.delete '@'
        end
      end
    end
  end
end
