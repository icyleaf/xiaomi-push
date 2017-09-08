require 'rest-client'
require 'json'

module Xiaomi
  module Push
    # 小米推送内置客户端
    #
    # 实际情况并不会直接被使用，而是使用 iOS 或 Android 的实例化
    #
    # @example 实例化 iOS 推送客户端(环境使用 :sandbox)
    #   client = Xiaomi::Push::IOS('Fill your app secret', :sandbox)
    # @example 实例化 Android 推送客户端
    #   client = Xiaomi::Push::Android('Fill your app secret')
    #
    # @see https://dev.mi.com/console/doc/detail?pId=68 小米推送服务启用指南
    class Client
      include Const

      attr_reader :device, :secret, :header

      # 实例化一个新的客户端
      #
      # @see https://dev.mi.com/console/doc/detail?pId=68 小米推送服务启用指南
      #
      # @param [String] secret 小米应用的 App Secret
      # @param [Symbol] env 推送环境，可用的环境有 :production/:sandbox
      #
      # @raise [NameError] 必须使用 Xiaomi::Push::Android 或 Xiaomi::Push::IOS 实例化
      # @raise [NameError] Android 使用 sandbox 推送环境引发异常
      def initialize(secret, env = :production)
        @device = self.class.name.split('::')[-1].upcase
        @secret = secret
        @header = {
          'Authorization' => "key=#{@secret}"
        }

        determine_platform!(env)

        env == :production ? use_production! : use_sandbox!
      end

      # 消息
      def message
        @message ||= Services::Message.new(self)
      end

      # 标签
      def topic
        @topic ||= Services::Topic.new(self)
      end

      # Feedback
      def feedback
        @feedback ||= Services::Feedback.new(self)
      end

      # 以 POST 方式的通用网络请求
      #
      # @param [String] url
      # @param [Hash] params
      # @return [Hash] 小米返回数据结构
      def request(url, params)
        r = RestClient.post url, params, @header
        data = JSON.parse r
      end

      private

      def determine_platform!(env)
        unless DEVICES.include?@device
          raise NameError, '必须使用 Xiaomi::Push::Android 或 Xiaomi::Push::IOS 实例化'
        end

        if env == :sandbox && @device == 'ANDROID'
          raise NameError, 'Android 环境不能支持 sandbox 测试环境'
        end
      end
    end
  end
end
