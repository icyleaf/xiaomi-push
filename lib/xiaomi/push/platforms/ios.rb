module Xiaomi
  module Push
    # iOS 推送
    #
    # @example
    #   Xiaomi::Push::Message::iOS.new(
    #     description:'iOS 主要显示描述',
    #     badge:10,
    #     extras: {
    #       uri: 'app://bbs?id=8624',
    #       source: 'mpush'
    #     }
    #   )
    class IOS < Xiaomi::Push::Client
    end

    # 用于 cli 的别名
    Ios = IOS
  end
end
