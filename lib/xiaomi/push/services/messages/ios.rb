module Xiaomi
  module Push
    module Message
      class IOS < Base
        attr_accessor :title, :description, :badge, :sound, :category, :extras
        def initialize(**params)
          @title = params[:title]
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
