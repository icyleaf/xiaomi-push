module Xiaomi
  module Push
    module Services
      # 定时任务类 API
      #
      # @see https://dev.mi.com/console/doc/detail?pId=1163#_7
      #
      # @attr [Client] context
      class Job
        attr_reader :context

        def initialize(context)
          @context = context
        end

        # 检测定时任务是否存在
        #
        # @param [String] job_id 任务 id
        # @return [Hash] 小米返回数据结构
        def exist?(job_id)
          url = @context.build_uri('schedule_job/exist')
          @context.post(url, { job_id: job_id })
        end

        # 删除定时任务
        #
        # @param [String] job_id 任务 id
        # @return [Hash] 小米返回数据结构
        def destory(job_id)
          url = @context.build_uri('schedule_job/delete')
          @context.post(url, { job_id: job_id })
        end
      end
    end
  end
end
