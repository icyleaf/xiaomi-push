require 'rest-client'
require 'json'

module Xiaomi
  module Push
    class Client
      include Const

      attr_reader :device, :secret, :header
      def initialize(secret, env = :production)
        @device = self.class.name.split('::')[-1].upcase
        @secret = secret
        @header = {
          'Authorization' => "key=#{@secret}"
        }

        determine_platform!(env)

        env == :production ? use_production! : use_sandbox!
      end

      def message
        @message ||= Services::Message.new(self)
      end

      def topic
        @topic ||= Services::Topic.new(self)
      end

      def feedback
        @feedback ||= Services::Feedback.new(self)
      end

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
