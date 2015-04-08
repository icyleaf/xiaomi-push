command :message do |c|
  c.syntax = 'xmp message [options]'
  c.summary = '发送小米推送消息'
  c.description = '使用小米推送消息（目前仅支持 regid/alias/topic 推送方式）'

  # normal params
  c.option '--device DEVICE', ['android', 'ios'], '设备类型'
  c.option '--secret SECRET', '应用密钥'

  # type
  c.option '--regid REGID', 'reg id'
  c.option '--alias ALIAS', '别名'
  c.option '--topic TOPIC', '订阅名'

  # message
  c.option '-i', '--title TITLE', '消息标题（仅 Android 有效）'
  c.option '-d', '--description DESCRIPTION', '消息主体描述'
  c.option '-b', '--badge BADGE', Integer, '消息数字'
  c.option '-e', '--extras KEY=VALUE', Array, '自定义数据(使用 KEY=VALUE 方式，多个以逗号不带空格分隔)'

  # ## ios only
  # c.option '-y', '--category CATEGORY', '推送类别名称 (仅 iOS 有效)'
  # c.option '-v', '--environment ENV', [:production, :sandbox], '推送环境(仅 iOS 有效)'
  #
  # ## android only
  # c.option '-g', '--through THROUGHT', [0, 1], '消息传递方式(仅 iOS 有效)'
  # c.option '-n', '--notify NOTIFY', [-1, 1, 2, 4], 'message notify type'

  c.action do |args, options|
    ap options if $verbose

    @device = options.device.capitalize if options.device
    @secret = options.secret

    determine_device! unless @device
    determine_secret! unless @secret

    determine_channel!(options)
    determine_message!(options)

    sent!
  end

  private

    def sent!
      message_data = {
        @channel.to_sym => @channel_id,
        :message => @message,
      }

      if $verbose
        ap message_data
      end

      client = Xiaomi::Push.const_get(@device).new(@secret)
      r = client.message.send(message_data)

      ap r
    end

    def determine_android_message!(options)
      @message = Xiaomi::Push::Message::Android.new(
        title: @title,
        description: @description,
        badge: @badge,
        extras: @extras
      )
    end

    def determine_ios_message!(options)
      @message = Xiaomi::Push::Message::IOS.new(
        description: @description,
        badge: @badge,
        extras: @extras
      )
    end

    def determine_message!(options)
      @title = options.title
      @description = options.description
      @badge = options.badge

      @extras = if options.extras
        Hash[options.extras.collect{|data| data.split(/\=/)}]
      else
        nil
      end

      case @device.downcase
      when 'android'
        determine_android_message!(options)
      when 'ios'
        determine_ios_message!(options)
      end
    end

    def determine_device!
      devices = %w[Android iOS].freeze
      @device = choose "选择推送设备:", *devices
    end

    def determine_secret!
      @secret ||= ask '小米应用密钥:'
    end

    def determine_channel!(options)
      channles = %w[regid alias topic].freeze
      @channel = channles.select { |k| options.__hash__.has_key?k.to_sym }

      unless @channel.count > 0
        @channel = choose "选择推送方式:", *channles

        @channel_id = ask "输入 #{@channel} 的值:"
      else
        @channel = @channel[0]
        @channel_id = options.__hash__[@channel.to_sym]
      end
    end
end
