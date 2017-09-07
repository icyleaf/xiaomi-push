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

      private

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
        URI.join(@base_url, "v2/#{uri}").to_s
      end
    end
  end
end
