require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'xiaomi/push'
require 'pp'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :test do
  # m = Xiaomi::Push::Message::IOS.new({
  #   title: '这是标题',
  #   description: '这个是推送的描述',
  #   badge: 2,
  #   notify_type: -1
  # })

  # pp m.to_params

  client = Xiaomi::Push::IOS.new(ENV['XIAOMI_PUSH_SECRET'])
  # r = client.user.aliases('Apn5cKFa3OaH/wrv0V/CpyQI3JLwUPEkBg8y7zBJc0s=')
  r = client.user.reg_id('"ABA82094-C785-9FC5-0DA3-F4DC5731EEFD')
  pp r
end

namespace :message do
  task :send do
    message = {
      title: '这是标题',
      description: '这个是推送的描述',
      notify_type: -1
    }

    p 'Send message to android device'
    client = Xiaomi::Push::Android.new(ENV['XIAOMI_PUSH_SECRET'])
    client.message.send(reg_id: '', message: message)
    r = client.message.send(alias: '866383029998732', message: message)
    # r = client.message.send(topic: 'test', message: message)
    puts r

    p 'Send message to ios device'
    client = Xiaomi::Push::IOS.new(ENV['XIAOMI_PUSH_SECRET'])
    r = client.message.send(
      reg_id: 'xksdf76s667687xd786sdxsdf689s6x6s8d76s8d',
      message: Xiaomi::Push::Message::IOS.new(
        description: '这不是描述'
    ))
    puts r
  end

  task :counters, [:package_name, :start_date, :end_date] do |t, opts|
    require 'date'
    start_date = opts.fetch(:start_date, Date.today.strftime('%Y%m%d'))
    end_date = opts.fetch(:end_date, (Date.today + 1).strftime('%Y%m%d'))
    package_name = opts.fetch(:package_name)

    if package_name
      client = Xiaomi::Push::IOS.new(ENV['XIAOMI_PUSH_SECRET'])
      pp client.message.counters(start_date, end_date, package_name)
    else
      puts "missing package name"
    end
  end
end

namespace :topic do
  task :subscribe do
    client = Xiaomi::Push::IOS.new(ENV['XIAOMI_PUSH_SECRET'])
    r = client.topic.subscribe(alias: '866383029998732', name: 'test')
    puts r
  end

  task :unsubscribe do
    client = Xiaomi::Push::Android.new(ENV['XIAOMI_PUSH_ANDROID_SECRET'])
    r = client.topic.unsubscribe(alias: '866383029998732', name: 'test')
    puts r
  end
end

task :message do
  ios_message = Xiaomi::Push::Message::IOS.new(title: 'dddd')
  ios_message.extra('url', 'http://www.xxx.com')
  p ios_message

  p ios_message.build
end

task :feedback do
  client = Xiaomi::Push::Android.new(ENV['XIAOMI_PUSH_ANDROID_SECRET'])
  r = client.feedback.invalid
  puts r
end
