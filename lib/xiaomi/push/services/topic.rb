module Xiaomi
  module Push
    module Services
      class Topic
        attr_reader :context
        def initialize(context)
          @context = context
        end

        def subscribe(**options)
          url, params = prepare_params(__method__.to_s, options)
          data = @context.request url, params
        end

        def unsubscribe(**options)
          url, params = prepare_params(__method__.to_s, options)
          data = @context.request url, params
        end

        private
          def prepare_params(uri, options)
            if options.has_key?(:reg_id)
              type = "registration_id"
              value = options[:reg_id]
              url = @context.build_uri("topic/#{uri}")
            elsif options.has_key?(:alias)
              type = "aliases"
              value = options[:alias]
              url = @context.build_uri("topic/#{uri}/alias")
            end

            params = {
              type.to_sym => value,
              :topic => options[:name],
              :category => options[:category],
            }

            [url, params]
          end
      end
    end
  end
end
