command :message do |c|
  c.syntax = 'xmp message [options]'
  c.summary = '发送小米推送消息'
  c.description = '使用小米推送消息（目前仅支持 regid/alias/user/topic 推送方式）'

  # 必须参数
  c.option '--device DEVICE', %w(android ios), '设备类型'
  c.option '--secret SECRET', '应用密钥'

  # 推送类型
  c.option '--regid REGID', 'reg id'
  c.option '--alias ALIAS', '别名'
  c.option '--user USER', '用户'
  c.option '--topic TOPIC', '标签/群组'

  # 消息体
  c.option '-i', '--title TITLE', '消息标题（适用于 Android 或 iOS 10 以上设备）'
  c.option '-s', '--subtitle SUBTITLE', '消息副标题（仅适用于 iOS 10 以上设备）'
  c.option '-m', '--image IMAGE', '消息图片地址（仅适用于 iOS 10 以上设备）'
  # c.option '-c', '--image IMAGE', '消息图片地址（仅适用于 iOS 10 以上设备）'
  c.option '-d', '--description DESCRIPTION', '消息主体描述'
  c.option '-b', '--badge BADGE', Integer, '消息数字'
  c.option '-e', '--extras KEY=VALUE', Array, '自定义数据(使用 KEY=VALUE 方式，多个以逗号不带空格分隔)'

  c.action do |args, options|
    puts options if $verbose

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
      :message => @message
    }

    if $verbose
      puts message_data
    end

    client = Xiaomi::Push.const_get(@device).new(@secret)
    r = client.message.send(message_data)

    puts r
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
      title: @title,
      subtitle: @subtitle,
      description: @description,
      image: @image,
      badge: @badge,
      extras: @extras
    )
  end

  def determine_message!(options)
    @title = options.title
    @subtitle = options.subtitle
    @description = options.description
    @image = options.image
    @badge = options.badge

    @extras =
      if options.extras
        Hash[options.extras.collect { |data| data.split(/\=/) }]
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
    devices = %w(Android iOS).freeze
    @device = choose('选择推送设备:', *devices)
  end

  def determine_secret!
    @secret ||= ask '小米应用密钥:'
  end

  def determine_channel!(options)
    channles = %w(regid alias user topic).freeze
    @channel = channles.select { |k| options.__hash__.key?k.to_sym }

    if @channel.count > 0
      @channel = @channel[0]
      @channel_id = options.__hash__[@channel.to_sym]
    else
      @channel = choose('选择推送方式:', *channles)
      @channel_id = ask("输入 #{@channel} 的值:")
    end
  end
end
