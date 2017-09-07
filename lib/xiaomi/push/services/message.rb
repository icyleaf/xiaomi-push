require 'xiaomi/push/services/messages/base'
require 'xiaomi/push/services/messages/ios'
require 'xiaomi/push/services/messages/android'

module Xiaomi
  module Push
    module Services
      class Message
        MESSAGE_TYPE = {
          reg_id: {
            uri: 'regid',
            query: 'registration_id'
          },
          alias: {
            uri: 'alias',
            query: 'alias'
          },
          user: {
            uri: 'user_account',
            query: 'user_account'
          },
          topic: {
            uri: 'topic',
            query: 'topic'
          },
          topics: {
            uri: 'multi_topic',
            query: 'topics'
          },
          topic_op: {
            uri: 'multi_topic',
            query: 'topic_op'
          },
          all: {
            uri: 'all',
            query: 'all'
          },
        }

        attr_reader :context
        def initialize(context)
          @context = context
        end

        def send(**options)
          type, value = fetch_message_type(options)
          if type && value
            url = @context.build_uri("message/#{type[:uri]}")
            if options[:message].kind_of?Xiaomi::Push::Message::Base
              options[:message].type(type[:query], value)
              params = options[:message].build
            else
              params = options[:message]
              params[type[:query].to_sym] = value
            end

            r = RestClient.post url, params, @context.header
            data = JSON.parse r
          else
            raise Xiaomi::Push::RequestError, 'Not match message type: reg_id/alias/topic/topics/all'
          end
        end

        private

        def fetch_message_type(data)
          type, value = nil
          MESSAGE_TYPE.select do |k,v|
            if data.has_key?k
              type = v
              value = data[k]
              break
            end
          end

          [type, value]
        end

        def valid?(params)
          validates = {
            'payload' => {
              require: true,
            },
            'restricted_package_name' => {
              require: true,
            },
            'pass_through' => {
              require: true,
            },
            'title' => {
              require: true,
            },
            'description' => {
              require: true,
            },
            'notify_type' => {
              require: true,
              values: {
                'DEFAULT_ALL' => -1,
                'DEFAULT_SOUND' => 1,
                'DEFAULT_VIBRATE' => 2,
                'DEFAULT_LIGHTS' => 3
              }
            },
            'time_to_live' => {
              require: false,
            },
            'time_to_send' => {
              require: false,
            },
            'notify_id' => {
              require: false,
            },
            'extra.sound_uri' => {
              require: false,
            },
            'extra.ticker' => {
              require: false,
            },
            'extra.notify_foreground' => {
              require: false,
            },
            'extra.notify_effect' => {
              require: false,
            },
          }
        end
      end
    end
  end
end
