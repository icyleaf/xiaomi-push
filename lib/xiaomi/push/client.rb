require "rest-client"
require "xiaomi/push/services/message"
require "xiaomi/push/services/topic"
require "xiaomi/push/services/alias"
require "xiaomi/push/services/feedback"


module Xiaomi
  module Push
    class Client
      attr_reader :client, :secret
      def initialize(client:, secret:, **options)

      end

      def message
        @message ||= ::Device::Message.new(self)
      end

      def topic
        @topic ||= ::Device::Topic.new(self)
      end

    end
  end
end
