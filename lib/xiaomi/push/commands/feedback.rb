command :feedback do |c|
  c.syntax = 'xmp feedback [options]'
  c.summary = '获取小米无效的设备列表'
  c.description = ''

  # normal params
  c.option '--device DEVICE', %w('android', 'ios'), '设备类型'
  c.option '--secret SECRET', '应用密钥'

  c.action do |args, options|
    puts options if $verbose

    @device = options.device.capitalize if options.device
    @secret = options.secret

    determine_device! unless @device
    determine_secret! unless @secret

    feedback!
  end

  private

  def feedback!
    client = Xiaomi::Push.const_get(@device).new(@secret)
    r = client.feedback.invalid

    puts r
  end

  def determine_device!
    devices = %w(Android iOS).freeze
    @device = choose "选择推送设备:", *devices
  end

  def determine_secret!
    @secret ||= ask '小米应用密钥:'
  end
end
