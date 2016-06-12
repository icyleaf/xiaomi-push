require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'dotenv/tasks'

# $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'xiaomi/push'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task send: :dotenv do
  message = {
    title: '这是标题',
    description: '这个是推送的描述',
    notify_type: -1
  }

  client = Xiaomi::Push::Android.new(ENV['XIAOMI_PUSH_ANDROID_SECRET'])

  p 'Send message to android device'
  client.message.send(reg_id: '', message: message)
  r = client.message.send(alias: '866383029998732', message: message)
  # r = client.message.send(topic: 'test', message: message)
  puts r

  p 'Send message to ios device'
  client = Xiaomi::Push::IOS.new(ENV['XIAOMI_PUSH_IOS_SECRET'])
  r = client.message.send(
    reg_id: 'xksdf76s667687xd786sdxsdf689s6x6s8d76s8d',
    message: Xiaomi::Push::Message::IOS.new(
      description: '这不是描述'
  ))
  puts r
end

namespace :topic do
  task subscribe: :dotenv do
    client = Xiaomi::Push::Android.new(ENV['XIAOMI_PUSH_ANDROID_SECRET'])
    r = client.topic.subscribe(alias: '866383029998732', name: 'test')
    puts r
  end

  task unsubscribe: :dotenv do
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
