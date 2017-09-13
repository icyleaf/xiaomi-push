module Xiaomi
  module Push
    module Services
      # 用户查询类 API
      #
      # 比如查找用户设置的 Alias 和 Topic 等
      # @attr [Client] context
      class User
        attr_reader :context

        # 初始化
        #
        # @param [Client] context
        def initialize(context)
          @context = context
        end

        # def reg_id(alias)
        #   # url = @context.build_uri('reg_id/all') + "?alias=#{alias}"
        #   # r = HTTP.headers(@header).get url
        #   # JSON.parse(r)
        # end

        # 根据 reg id 查找绑定的别名（aliases）
        #
        # 一个 reg id 可以绑定多个 alias
        #
        # @param [String] reg_id
        # @param [String] package_name
        # @return [Hash] 小米返回数据结构
        def aliases(reg_id, package_name = nil)
          url = @context.build_uri('alias/all')
          @context.get(url, reg_params(reg_id, package_name))
        end

        # 根据 reg id 查找设置的标签（Topics）
        #
        # 一个 reg id 可以绑定多个 topic
        #
        # @param [String] reg_id
        # @param [String] package_name
        # @return [Hash] 小米返回数据结构
        def topices(reg_id, package_name = nil)
          url = @context.build_uri('topic/all')
          @context.get(url, reg_params(reg_id, package_name))
        end

        private

        def reg_params(reg_id, package_name = nil)
          {
            registration_id: reg_id,
          }.tap do |obj|
            obj[:restricted_package_name] = package_name if package_name
          end
        end
      end
    end
  end
end
