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

# 发消息
## 根据 regid
client.message.send reg_id:'id', data:'playload'

## 根据 alias
client.message.send alias:'alias', data:'playload'

## 根据 topic
client.message.send topic:'topic', data:'playload'
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
