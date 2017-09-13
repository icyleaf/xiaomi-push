module Xiaomi
  module Push
    module Services
      # 适用于 iOS 推送获取设备 Feedback API
      #
      # @attr [Client] context
      class Feedback
        attr_reader :context

        def initialize(context)
          @context = context
        end

        # 获取失效的 device token
        #
        # @see https://dev.mi.com/console/doc/detail?pId=1163#_4_1
        #
        # @return [Hash] 小米返回数据结构
        def invalid
          url = 'https://feedback.xmpush.xiaomi.com/v1/feedback/fetch_invalid_regids'
          @context.get url
        end
      end
    end
  end
end
