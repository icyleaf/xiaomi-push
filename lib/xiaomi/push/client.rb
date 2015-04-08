require "rest-client"
require "multi_json"

module Xiaomi
  module Push
    class Client
      include Const

      attr_reader :device, :secret, :header
      def initialize(secret)
        @device = self.class.name.split("::")[-1].upcase
        @secret = secret

        unless DEVICES.include?@device
          raise NameError, 'Instance using Xiaomi::Push::Android or Xiaomi::Push::IOS'
        end

        @header = {
          'Authorization' => "key=#{@secret}"
        }

        use_production!
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
        data = MultiJson.load r
      end

    end
  end
end
