module Xiaomi
  module Push
    module Message
      class IOS
        attr_accessor :title, :description, :badge, :sound, :category, :extras
        def initialize(**params)
          @title = params[:title]
          @description = params[:description]
          @badge = params[:badge] || 1
          @sound = params[:sound] || 'default'
          @category = params[:category]
          @extras = params[:extras] || {}
        end

        def extra(key, value = nil)
          unless value
            @extras[key]
          else
            @extras[key] = value
          end
        end
      end
    end
  end
end
