require 'http'
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

      attr_reader :device, :client

      # 实例化一个新的客户端
      #
      # @see https://dev.mi.com/console/doc/detail?pId=68 小米推送服务启用指南
      #
      # @param [String] secret 小米应用的 App Secret
      # @param [Symbol] env 推送环境，可用的环境有 :production/:sandbox
      #
      # @raise [RequestError] 必须使用 Xiaomi::Push::Android 或 Xiaomi::Push::IOS 实例化
      # @raise [RequestError] Android 使用 sandbox 推送环境引发异常
      def initialize(secret, env = :production)
        @device = self.class.name.split('::')[-1].upcase
        @client = HTTP.headers(authorization: "key=#{secret}")

        determine_platform!(env)

        env == :production ? use_production! : use_sandbox!
      end

      # 单条消息
      def message
        @message ||= Services::Message.new(self)
      end

      # 多条消息
      def messages
        @messages ||= Services::Messages.new(self)
      end

      # 标签
      def topic
        @topic ||= Services::Topic.new(self)
      end

      # 用户查询
      def user
        @user ||= Services::User.new(self)
      end

      # Feedback
      def feedback
        @feedback ||= Services::Feedback.new(self)
      end

      # 以 GET 方式的网络请求
      #
      # @param [String] url
      # @param [Hash] params
      # @return [Hash] 小米返回数据结构
      def get(url, params = nil)
        r = @client.get(url, params: params)
        data = JSON.parse(r)
      end

      # 以 POST 方式的网络请求
      #
      # @param [String] url
      # @param [Hash] params
      # @return [Hash] 小米返回数据结构
      def post(url, params = nil)
        r = @client.post(url, form: params)
        data = JSON.parse(r)
      end

      private

      def determine_platform!(env)
        unless DEVICES.include?@device
          raise RequestError, '必须使用 Xiaomi::Push::Android 或 Xiaomi::Push::IOS 实例化'
        end

        if env == :sandbox && @device == 'ANDROID'
          raise RequestError, 'Android 环境不能支持 sandbox 测试环境'
        end
      end
    end
  end
end
