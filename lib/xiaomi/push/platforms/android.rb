module Xiaomi
  module Push
    # Android 推送
    #
    # @example
    #   Xiaomi::Push::Message::Android.new(
    #     title:'标题要有吸引力',
    #     description:'描述可以在手机显示两行',
    #     notify_type:'DEFAULT_ALL',
    #     extras: {
    #       source: 'mpush'
    #     }
    #   )
    class Android < Xiaomi::Push::Client
    end
  end
end
