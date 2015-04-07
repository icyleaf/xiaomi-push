module Xiaomi
  module Push
    class Error < StandardError
      attr_reader :url, :error
    end

    class RequestError < Xiaomi::Push::Error

    end

    class FailuresError < Xiaomi::Push::Error
      def initialize(code, error)
        @code = code
        @error = error

        super "[#{@code}] #{@error}"
      end
    end
  end
end
