require 'uri'


module Xiaomi
  module Push
    module Const
      DEVICES = %w[ANDROID IOS].freeze

      PRODUCTION_URL = 'https://api.xmpush.xiaomi.com'
      SANDBOX_URL = 'https://sandbox.xmpush.xiaomi.com'

      attr_reader :base_url

      def use_production!
        production
      end

      def use_sandbox!
        sandbox
      end

      def production
        @base_url ||= PRODUCTION_URL
      end

      def sandbox
        @base_url ||= SANDBOX_URL
      end

      def build_uri(uri)
        URI::join(@base_url, "v2/#{uri}").to_s
      end
    end
  end
end
