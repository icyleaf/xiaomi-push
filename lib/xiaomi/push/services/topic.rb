module Xiaomi
  module Push
    module Services
      # 标签类 API
      #
      # @attr [Client] context
      class Topic
        attr_reader :context

        # 初始化
        #
        # @param [Client] context
        def initialize(context)
          @context = context
        end

        # 订阅标签
        #
        # 可使用 reg id 或 alias 的方式订阅标签
        #
        # @example
        #   subscribe(reg_id: 'abc', topic: 'beijing')
        #   subscribe(alias: 'abc', topic: 'beijing')
        #   subscribe(alias: 'abc,def,ghi,jkl', topic: 'beijing')
        #
        # @param [Hash] options
        # @option options [String] :reg_id 订阅 reg id，多个以逗号分割，最多 1000 个
        # @option options [String] :aliases 订阅 alias，多个以逗号分割，最多 1000 个
        # @option options [String] :topic 订阅名
        # @option options [String] :category 分类，可选项
        # @return [Hash] 小米返回数据结构
        def subscribe(**options)
          url, params = prepare_params(__method__.to_s, options)
          @context.request url, params
        end

        # 取消订阅标签
        #
        # 可使用 reg id 或 alias 的方式取消订阅标签
        #
        # @example
        #   unsubscribe(reg_id: 'abc', topic: 'beijing')
        #   unsubscribe(alias: 'abc', topic: 'beijing')
        #   unsubscribe(alias: 'abc,def,ghi,jkl', topic: 'beijing')
        #
        # @param [Hash] options
        # @option options [String] :reg_id 订阅 reg id，多个以逗号分割，最多 1000 个
        # @option options [String] :aliases 订阅 alias，多个以逗号分割，最多 1000 个
        # @option options [String] :topic 订阅名
        # @option options [String] :category 分类，可选项
        # @return [Hash] 小米返回数据结构
        def unsubscribe(**options)
          url, params = prepare_params(__method__.to_s, options)
          @context.request url, params
        end

        private

        def prepare_params(uri, options)
          if options.key?(:reg_id)
            type = 'registration_id'
            value = options[:reg_id]
            url = @context.build_uri("topic/#{uri}")
          elsif options.key?(:alias)
            type = 'aliases'
            value = options[:alias]
            url = @context.build_uri("topic/#{uri}/alias")
          end

          params = {
            type.to_sym => value,
            :topic => options[:name],
            :category => options[:category]
          }

          [url, params]
        end
      end
    end
  end
end
