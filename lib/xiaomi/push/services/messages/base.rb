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
            instance_variable_set(key, value)
          else
            instance_variable_get(key)
          end
        end

        # 转换为字典
        # @return [Hash] 消息体
        def to_params
          hash_data = {}
          instance_variables.each do |ivar|
            key = instance_key(ivar)

            key = if ios? && ios10_struct?
              ios10_struct(key)
            else
              extra_key(key)
            end

            value = instance_variable_get(ivar)

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

        # 检查是否为 iOS 10 消息体
        #
        # @return [Bool]
        def ios10_struct?
          return @ios10_struct unless @ios10_struct.nil?

          @ios10_struct = false

          keys = instance_variables.map {|e| instance_key(e) }
          %w(title subtitle).each do |key|
            return @ios10_struct = true if keys.include?(key)
          end

          @ios10_struct
        end

        # 转换 iOS 10 消息的参数
        #
        # 仅转换 title, subtitle, body 和 description
        #
        # @example
        #   ios10_struct('title') # => 'aps_proper_fields.title'
        #   ios10_struct('description') # => 'aps_proper_fields.body'
        #   ios10_struct('badge') # => 'badge'
        #
        # @param [String] key
        # @return [Bool]
        def ios10_struct(key)
          key = 'body' if key == 'description'
          return extra_key(key) unless %w(title subtitle body mutable-content).include?(key)

          "aps_proper_fields.#{key}"
        end

        # 检测是否是 iOS 消息体
        #
        # @return [Bool]
        def ios?
          current == 'IOS'
        end

        # 检测是否是 Android 消息体
        #
        # @return [Bool]
        def android?
          current == 'ANDROID'
        end

        # 当前消息体类型
        #
        # @return [String] IOS/ANDROID
        def current
          @current ||= self.class.name.split('::')[-1].upcase
        end

        private

        def instance_key(var)
          var.to_s.gsub('_', '-').delete('@')
        end

        def extra_key?(key)
          %w(badge sound category).include?(key)
        end

        def extra_key(key)
          if extra_key?(key)
            key = 'sound_url' if key.include?('sound')
            key = "extra.#{key}"
          else
            key
          end
        end
      end
    end
  end
end
