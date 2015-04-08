module Xiaomi
  module Push
    module Services
      class Feedback

        attr_reader :context

        def initialize(context)
          @context = context
        end

        def invalid
          url = 'https://feedback.xmpush.xiaomi.com/v1/feedback/fetch_invalid_regids'
          r = RestClient.get url, @context.header
          data = MultiJson.load r
        end
      end
    end
  end
end
