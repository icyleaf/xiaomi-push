require 'xiaomi/push/services/messages/base'
require 'xiaomi/push/services/messages/ios'
require 'xiaomi/push/services/messages/android'

module Xiaomi
  module Push
    module Services
      # 消息类 API
      #
      # 允许向多个设备发送不同的推送消息
      #
      # 设备的标识支持 reg_id/alias/user_account
      #
      # @attr [Client] context
      class Messages
        # 消息类型模板
        MESSAGE_TYPE = {
          reg_id: {
            uri: 'regids',
            keys: [:reg_id, :regid, :registration_id]
          },
          alias: {
            uri: 'aliases',
            keys: [:alias, :aliass, :aliases]
          },
          user: {
            uri: 'user_accounts',
            keys: [:user, :account, :useraccount, :user_account]
          }
        }

        attr_reader :context

        def initialize(context)
          @context = context
        end

        # 推送消息
        #
        # @see https://dev.mi.com/console/doc/detail?pId=1163#_1_0
        #
        # @param [Hash] type 发送消息类型，可选 :reg_id, :alias, :user
        # @param [Array] messages 消息结构消息体的数组 (详见 {Xiaomi::Push::Message::IOS}, {Message::Android})
        # @return [Hash] 小米返回数据结构
        #
        # @raise [RequestError] 推送消息不满足 reg_id/alias/user 会引发异常
        # @raise [RequestError] 消息体没有包含关键 target key 会引发异常
        # @raise [RequestError] messages 不是数组存储的消息体时会引发异常
        def send(type, messages = [])
          url = @context.build_uri("multi_messages/#{request_uri(type)}")
          params = request_params(type, messages)
          @context.post(url, params)
        end

        private

        # 获取消息类型
        def request_uri(type)
          MESSAGE_TYPE[type][:uri]
        rescue NoMethodError
          raise RequestError, '无效的消息类型，请检查是否符合这些类型: reg_id/alias/user'
        end

        def request_params(type, messages)
          raise RequestError, '消息必须是数组类型' unless messages.kind_of?(Array)

          messages.each_with_object([]) do |message, obj|
            message = options[:message].to_params if message.kind_of?(Xiaomi::Push::Message::Base)
            target_key = target_key(type, message)

            raise RequestError, "#{type.to_s} 消息缺失关键 Key，可设置为 #{MESSAGE_TYPE[type][:keys].join('/')} 均可：#{message}" unless target_key

            obj.push({
              target: message.delete(target_key),
              message: message,
            })
          end
        end

        def target_key(type, message)
          keys = MESSAGE_TYPE[type][:keys]
          message.each do |key, _|
            return key if keys.include?(key)
          end

          nil
        end
      end
    end
  end
end
