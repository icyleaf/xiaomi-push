module Xiaomi
  module Push
    module Message
      class Android
        attr_accessor :title, :description, :badge, :sound, :pass_through, :notify_type, :notify_id, :extras
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
