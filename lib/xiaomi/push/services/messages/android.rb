module Xiaomi
  module Push
    module Message
      # Android 消息数据体
      #
      # @attr [String] title 标题
      # @attr [String] description 描述
      # @attr [String] badge 角标, 默认 1
      # @attr [String] sound 声音，默认 default
      # @attr [String] pass_through 是否为穿透, 取值 0(默认，通知栏消息)/1（穿透）
      # @attr [String] notify_type 提醒类型，取值 DEFAULT_ALL(默认)/DEFAULT_SOUND(提示音)/DEFAULT_VIBRATE(振动)/DEFAULT_LIGHTS(指示灯)
      # @attr [Integer] notify_id 提醒，默认情况下，通知栏只显示一条推送消息。如果通知栏要显示多条推送消息，需要针对不同的消息设置不同的 notify_id
      class Android < Base
        attr_accessor :title, :description, :badge, :sound, :pass_through, :notify_type, :notify_id

        def initialize(**params)
          @title = params[:title]
          @description = params[:description]
          @badge = params[:badge] || 1
          @sound = params[:sound] || 'default'
          @pass_through = params[:pass_through] || 0
          @notify_type = params[:notify_type] || 'DEFAULT_ALL'
          @notify_id = params[:notify_id]
          @extras = params[:extras] || {}
        end
      end
    end
  end
end
