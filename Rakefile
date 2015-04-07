require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'dotenv/tasks'
require 'awesome_print'

# $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'xiaomi/push'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :send => :dotenv do

  message = {
    title: '这是标题',
    description: '这个是推送的描述',
    notify_type: -1,
  }
  client = Xiaomi::Push::Android.new(ENV['XIAOMI_PUSH_ANDROID_SECRET'])

  p "Send message to android device"
  # client.message.send(reg_id:'', data:message_data)
  r = client.message.send(alias:'866383029998732', message:message)
  # client.message.send(topic:'test', data:message_data)
  ap r

  p "Send message to ios device"
  client = Xiaomi::Push::IOS.new(ENV['XIAOMI_PUSH_IOS_SECRET'])
  r = client.message.send(
    reg_id:'xksdf76s667687xd786sdxsdf689s6x6s8d76s8d',
    message:Xiaomi::Push::Message::IOS.new(
      description:'这不是描述'
  ))
  ap r
end

task :message do
  ios_message = Xiaomi::Push::Message::IOS.new(title:'dddd')
  ios_message.extra('url', 'http://www.xxx.com')
  p ios_message

  p ios_message.build
end
