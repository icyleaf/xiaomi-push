module Xiaomi
  module Push
    module Services
      # 适用于 iOS 推送获取设备 Feedback
      class Feedback
        attr_reader :context

        def initialize(context)
          @context = context
        end

        # 获取失效的 device token
        def invalid
          url = 'https://feedback.xmpush.xiaomi.com/v1/feedback/fetch_invalid_regids'
          r = RestClient.get url, @context.header
          JSON.parse r
        end
      end
    end
  end
end
