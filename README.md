# 非官方小米推送服务端 Ruby SDK

[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/xiaomi-push.svg?style=flat)](https://circleci.com/gh/icyleaf/xiaomi-push)
[![Code Climate](https://img.shields.io/codeclimate/github/icyleaf/xiaomi-push.svg?style=flat)](https://codeclimate.com/github/icyleaf/xiaomi-push)
[![Inline docs](http://inch-ci.org/github/icyleaf/xiaomi-push.svg?style=flat)](https://inch-ci.org/github/icyleaf/xiaomi-push)
[![Gem version](https://img.shields.io/gem/v/xiaomi-push.svg?style=flat)](https://rubygems.org/gems/xiaomi-push)
[![License](https://img.shields.io/badge/license-MIT-red.svg?style=flat)](LICENSE.txt)

> 2017年9月7日更新：当前分支已支持 2016 年后官方的新功能。

## TL;DR

### 安装

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

### 用法

### 发单一消息

支持按照 `reg_id`/`alias`/`topic`/`topics`/`user`/`all` 的方式向单个或一组设备发送同一条推送消息。

```ruby
require 'xiaomi-push'

# 初始化
# iOS (环境支持 :production/:sandbox)
client = Xiaomi::Push::IOS('Fill your app secret', :production)
# Android
client = Xiaomi::Push::Android('Fill your app secret')

# 消息结构
# Hash 模式
message = {
  'title': 'Android 需要标题',
  'descrption': 'iOS 主要显示描述',
  'extra.uri': 'app://bbs?id=8624'
}

# Builder 模式
# iOS
message = Xiaomi::Push::Message::IOS.new(
  description: 'iOS 主要显示描述',
  badge: 10,
  extras: {
    uri: 'app://bbs?id=8624',
    source: 'mpush'
  }
)

# iOS 10
message = Xiaomi::Push::Message::IOS.new(
  title: '这是标题',
  subtitle: '这是副标题'
  description:'iOS 主要显示描述', # 对于 iOS 这里即可以是 description 也可以是 iOS 10 结构的 body
  badge: 1,
  extras: {
    uri: 'app://bbs?id=8624',
    source: 'mpush'
  }
)

# Android
message = Xiaomi::Push::Message::Android.new(
  title: '标题要有吸引力',
  description: '描述可以在手机显示两行',
  notify_type: 'DEFAULT_ALL',
  extras: {
    source: 'mpush'
  }
)

# 支持单独追加 extra
message.extra('uri', 'app://bbs?id=8624')

# 发消息
# 根据 regid
client.message.send reg_id:'id', message:message

# 根据 alias
client.message.send alias:'alias', message:message

# 根据 topic
client.message.send topic:'topic', message:message

# 全部推送
client.message.send all:true, message:message
```

### 发送多条消息

支持同一设备类型的设备发送不同的消息。**注意**发送多个消息不能是不同类型的设备 key。

支持的消息类型：

- `:reg_id`
  - `reg_id`
  - `regid`
  - `registration_id`
- `:alias`
  - `:alias`
- `:user`
  - `:user`
  - `:account`
  - `:useraccount`
  - `:user_account`

> 以上子列表为消息体传递的设备的 key 的名字。

```ruby
# 向多个 reg id 发送不同的消息
client.messages.send(:reg_id, [
  {
    reg_id: 'abc',
    title: '这是标题1',
    description: '这个是推送的描述1',
    notify_type: -1
  },
  {
    regid: 'dfc',
    title: '这是标题2',
    description: '这个是推送的描述2',
  },
  {
    registration_id: 'dfc',
    title: '这是标题2',
    description: '这个是推送的描述2',
  }
])

# 这个是错误的消息，无法发送
client.messages.send(:alias, [
  {
    reg_id: 'abc',
    title: '这是标题1',
    description: '这个是推送的描述1',
    notify_type: -1
  },
  {
    user: 'dfc',
    title: '这是标题2',
    description: '这个是推送的描述2',
  },
])
```

### 订阅/取消订阅标签

```ruby
# 订阅单个 reg id 到 beijing 标签
client.topic.subscribe(reg_id: 'abc', topic: 'beijing')

# 订阅多个 alias 到 beijing 标签
client.topic.subscribe(alias: 'abc,def,ghi,jkl', topic: 'beijing')

# 取消订阅 beijing 标签的单个 reg id
client.topic.unsubscribe(reg_id: 'abc', topic: 'beijing')

# 取消订阅 beijing 标签的多个 alias
client.topic.unsubscribe(alias: 'abc,def,ghi,jkl', topic: 'beijing')
```

### 获取无效 iOS 的推送设备

用于检查 iOS 用户关闭了应用的推送或者是卸载了 App 的设备列表

```ruby
client.feedback.invalid
```

### 获取消息的统计数据

```ruby
# 获取 2017-09-01 到 2017-09-30 应用 com.icyleaf.app.helloworld 统计数据
client.message.counters('20170901', '20170930', 'com.icyleaf.app.helloworld')
```

更多用例可查阅 [Rakefile](Rakefile)。

### 命令行工具

本 SDK 同时还附带一个命令行工具 `xmp`，可以使用它尽快快速的测试和验证参数信息.

```bash
# 发消息
## iOS
### 发送附加内容并设置未读消息数为 2
$ xmp message --device ios --secret '<密钥>' \
  --alias '<Alias>' \
  -d '推送的描述内容' \
  -b 2 \
  -e uri="http://icyleaf.com"
# => {"result"=>"ok", "trace_id"=>"abc", "code"=>0, "data"=>{"id"=>"abc68b8350529097551xyz"}, "description"=>"成功", "info"=>"Received push messages for 1 ALIAS"}

## Android
### 最基本的推送信息
$ xmp message --device android --secret '<密钥>' \
  --regid '<RegId>' \
  -i '推送的标题' \
  -d '推送的描述内容'
# => {"result"=>"ok", "trace_id"=>"abc", "code"=>0, "data"=>{"id"=>"abc68b8350529097551xyz"}, "description"=>"成功", "info"=>"Received push messages for 1 REG_ID"}

# 查找绑定的 aliases 和 topics
$ xmp user --device ios --secret '<密钥>' --reg-id '<RegId>'
# => alias count: 1
# =>  * ABCDEFGH-1234-5678-90ABC-F4DC5731EEFD
# => topic count: 1
# =>  * all

# 查找 iOS 无效的设备（Reg id）
$ xmp feedback --device ios --secret '<密钥>'
# => {"result"=>"ok", "trace_id"=>"Xlm07b67505290966457ey", "code"=>0, "data"=>{"list"=>["+9AKnbpV22HafwE7vjYMr6Hc7i41ClyQr7iqX1fm7zc="]}}

# 查看帮助
$ xmp message --help

  NAME:

    xmp

  DESCRIPTION:

    小米推送命令行工具

  COMMANDS:

    feedback 获取小米无效的设备列表
    message  发送小米推送消息
    user     小米 aliases/topics 查询工具
```

## 相关资源

- 官方 API 文档: https://dev.mi.com/console/doc/detail?pId=1163
- 官方 SDK 下载：https://dev.mi.com/mipush/downpage/ (Python Java PHP)

## 贡献代码

1. Fork it ( https://github.com/[my-github-username]/xiaomi-push/fork )
1. Create your feature branch (`git checkout -b my-new-feature`\)
1. Commit your changes (`git commit -am 'Add some feature'`\)
1. Push to the branch (`git push origin my-new-feature`\)
1. Create a new Pull Request
