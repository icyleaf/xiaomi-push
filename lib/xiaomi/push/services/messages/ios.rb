module Xiaomi
  module Push
    module Message
      # iOS 数据消息体
      # @attr [String] title 标题
      # @attr [String] description 描述
      # @attr [String] badge 角标, 默认 1
      # @attr [String] sound 声音，默认 default
      # @attr [String] category iOS 8 以上可设置推送消息快速回复类别
      class IOS < Base
        attr_accessor :description, :badge, :sound, :category

        def initialize(**params)
          @description = params[:description]
          @badge = params[:badge] || 1
          @sound = params[:sound] || 'default'
          @category = params[:category]
          @extras = params[:extras] || {}
        end
      end
    end
  end
end
