require 'xiaomi/push/services/messages/base'
require 'xiaomi/push/services/messages/ios'
require 'xiaomi/push/services/messages/android'

module Xiaomi
  module Push
    module Services
      class Message
        # 消息类型模板
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

        # 推送消息
        #
        # @param (see Xiaomi::Push::Message::Base#initialize)
        # @param [Hash] options Hash 结构消息体 (详见 {Xiaomi::Push::Message::IOS}, {Message::Android})
        # @param [Message::IOS] options iOS 消息体
        # @param [Message::Android] options Android 消息体
        # @return [Hash] 小米返回数据结构
        #
        # @raise [RequestError] 推送消息不满足 reg_id/alias/topic/topics/all 会引发异常
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
            raise Xiaomi::Push::RequestError, '无效的消息类型，请检查是否符合这些类型: reg_id/alias/topic/topics/all'
          end
        end

        private

        # 获取消息类型
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

        # 数据校验
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
