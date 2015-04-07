非官方小米推送服务端 Ruby SDK
=============================

官方文档: http://dev.xiaomi.com/doc/?p=533#d5e725

安装
----

添加如下至 Gemfile:

```ruby
gem 'xiaomi-push'
```

执行:

```
$ bundle
```

或直接安装:

```
$ gem install xiaomi-push
```

用法
----

### 发消息

```ruby
require 'xiaomi-push'
# 初始化
## iOS
client = Xiaomi::Push::IOS('Fill your app secret')
## Android
client = Xiaomi::Push::Android('Fill your app secret')

# 消息结构
## Hash 模式
message = {
  'title': 'Android 需要标题',
  'descrption': 'iOS 主要显示描述',
  'extra.uri': 'app://bbs?id=8624'
}

## Builder 模式
### iOS
message = Xiaomi::Push::Message::IOS.new(
  description:'iOS 主要显示描述',
  badge:10
)

### Android
message = Xiaomi::Push::Message::Android.new(
  title:'标题要有吸引力',
  description:'描述可以在手机显示两行',
  notify_type:'DEFAULT_ALL'
)

# 发消息
## 根据 regid
client.message.send reg_id:'id', message:message

## 根据 alias
client.message.send alias:'alias', message:message

## 根据 topic
client.message.send topic:'topic', message:message

## 全部推送
client.message.send all:true, message:message
```

命令行工具
----------

本 SDK 同时还附带一个命令行工具 `xmp`，可以使用它尽快快速的测试和验证参数信息.

```bash
# 发消息
## iOS
### 发送附加内容并设置未读消息数为 2
$ xmp message --device ios --secret '<密钥>' -d '推送的内容' -b 2 -e uri="app://bbs?id",source="push"

## Android
### 最基本的推送信息
$ xmp message --device android --secret '<密钥>' -i '推送的标题' -d '推送的内容'

# 查看帮助
$ xmp message --help
```

开发
----

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

如何共享
--------

1.	Fork it ( https://github.com/[my-github-username]/xiaomi-push/fork )
2.	Create your feature branch (`git checkout -b my-new-feature`\)
3.	Commit your changes (`git commit -am 'Add some feature'`\)
4.	Push to the branch (`git push origin my-new-feature`\)
5.	Create a new Pull Request
