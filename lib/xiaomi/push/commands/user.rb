command :user do |c|
  c.syntax = 'xmp user [options]'
  c.summary = '小米 aliases/topics 查询工具'
  c.description = '通过 reg id 查找用户绑定的 alias 和 topic'

  # normal params
  c.option '--device DEVICE', %w(android, ios), '设备类型'
  c.option '--secret SECRET', '应用密钥'
  c.option '--reg-id REG_ID', 'Reg id'
  c.option '--package-name PACKAGE_NAME', '包的唯一标识，android 是 package name， ios 是 bundle identiflier'

  c.action do |args, options|
    puts options if $verbose

    @device = options.device.capitalize if options.device
    @secret = options.secret
    @reg_id = options.reg_id
    @package_name = options.package_name

    determine_device! unless @device
    determine_secret! unless @secret

    @client = Xiaomi::Push.const_get(@device).new(@secret)

    find_aliases!
    find_topics!
  end

  private

  def find_aliases!
    r = @client.user.aliases(@reg_id, @package_name)
    if r['result'] == 'ok'
      print_data(r, :alias)
    else
      user_error(r, :alias)
    end
  end

  def find_topics!
    r = @client.user.topices(@reg_id, @package_name)
    if r['result'] == 'ok'
      print_data(r, :topic)
    else
      user_error(r, :topic)
    end
  end

  def print_data(data, type)
    say "#{type.to_s} count: #{data['data']['list'].count}"
    data['data']['list'].each do |key|
      say_ok " * #{key}"
    end
  end

  def user_error(data, type)
    say_error "#{type.to_s} error."
    say_error "[#{data['code']}] #{data['description']}: #{data['reason']}"
  end

  def determine_device!
    devices = %w(Android iOS).freeze
    @device = choose("选择推送设备:", *devices)
  end

  def determine_secret!
    @secret ||= ask('小米应用密钥:')
  end
end
