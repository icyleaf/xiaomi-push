require 'uri'

module Xiaomi
  module Push
    module Const
      # 支持设备
      DEVICES = %w(ANDROID IOS).freeze
      # 产品环境
      PRODUCTION_URL = 'https://api.xmpush.xiaomi.com'.freeze
      # 沙盒环境（仅支持 iOS）
      SANDBOX_URL = 'https://sandbox.xmpush.xiaomi.com'.freeze

      attr_reader :base_url

      # 切换产品环境
      def use_production!
        production
      end

      # 切换沙盒环境
      def use_sandbox!
        sandbox
      end

      # :nodoc:
      def production
        @base_url ||= PRODUCTION_URL
      end

      # :nodoc:
      def sandbox
        @base_url ||= SANDBOX_URL
      end

      # :nodoc:
      def build_uri(uri)
        version =
          if uri.start_with?('stats', 'trace', 'alias') || uri == 'topic/all'
            # 获取消息的统计数据/追踪消息状态/某个用户目前设置的所有 Alias 和订阅的所有 Topic
            'v1'
          elsif uri.start_with?('message')
            # 发送消息支持多包使用 v3 版本
            'v3'
          else
            'v2'
          end

        File.join(@base_url, version, uri)
      end
    end
  end
end
