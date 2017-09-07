# 非官方小米推送服务端 Ruby SDK

[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/xiaomi-push.svg?style=flat)](https://circleci.com/gh/icyleaf/xiaomi-push)
[![Code Climate](https://img.shields.io/codeclimate/github/icyleaf/xiaomi-push.svg?style=flat)](https://codeclimate.com/github/icyleaf/xiaomi-push)
[![Inline docs](http://inch-ci.org/github/icyleaf/xiaomi-push.svg?style=flat)](https://inch-ci.org/github/icyleaf/xiaomi-push)
[![Gem version](https://img.shields.io/gem/v/xiaomi-push.svg?style=flat)](https://rubygems.org/gems/xiaomi-push)
[![License](https://img.shields.io/badge/license-MIT-red.svg?style=flat)](LICENSE.txt)

> 2017年9月7日更新：万年巨坑重新开坑，目前正在开发并支持 2016 年后的新功能...

官方 API 文档: https://dev.mi.com/console/doc/detail?pId=1163

官方 SDK 下载：https://dev.mi.com/mipush/downpage/ (Python Java PHP)

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

### 发消息

```ruby
require 'xiaomi-push'

# 初始化
## iOS (环境支持 :production/:sandbox)
client = Xiaomi::Push::IOS('Fill your app secret', :production)
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
  badge:10,
  extras: {
    uri: 'app://bbs?id=8624',
    source: 'mpush'
  }
)

### Android
message = Xiaomi::Push::Message::Android.new(
  title:'标题要有吸引力',
  description:'描述可以在手机显示两行',
  notify_type:'DEFAULT_ALL',
  extras: {
    source: 'mpush'
  }
)
#### 支持单独追加 extra
message.extra('uri', 'app://bbs?id=8624')

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

### 命令行工具

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

## 贡献代码

1. Fork it ( https://github.com/[my-github-username]/xiaomi-push/fork )
1. Create your feature branch (`git checkout -b my-new-feature`\)
1. Commit your changes (`git commit -am 'Add some feature'`\)
1. Push to the branch (`git push origin my-new-feature`\)
1. Create a new Pull Request
