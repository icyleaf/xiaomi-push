# 变更历史

### v0.3.0

主要围绕 [#4](https://github.com/icyleaf/xiaomi-push/issues/4) 的需求完成：

- [重大改变] 仅支持 ruby 2.1（包含）以上版本

- [新增] 支持 iOS 10 的消息结构
- [新增] 初始化支持使用 sandbox 推送环境
- [新增] `message.counters` 接口获取消息的统计数据
- [新增] `message.send` 接口使用 v3 版本并支持 user_account 查询（调用时用 user）
- [新增] `user.aliases` 接口获取根据 reg id 查找绑定的别名（aliases）
- [新增] `user.topics` 接口获取根据 reg id 查找绑定的标签（Topics）
- [新增] `job.exist?` 接口检测定时任务是否存在
- [新增] `job.destory` 接口删除定时任务
- [新增] `xmp user` 命令工具支持查询 reg id 的 alias 和 topic
- [新增] `xmp message` 命令工具支持 user_account 推送

- [文档] 完善 README 文档和补全 API 文档

- [重构] 使用高性能的 http 代替 rest-client
- [重构] 移除 multi_json 转而使用自带的 json 解析

- [修复] 组装消息体获取 key 错误的问题 [8efc5ee](https://github.com/icyleaf/xiaomi-push/commit/8efc5eeb3e02366d3a92da62fc1a6b81a58a143c)
- [修复] 推送角标和声音设置不对的问题 [ebc4c89](https://github.com/icyleaf/xiaomi-push/commit/ebc4c89cad6db6d0b6cabaa7f52e54d53a4d55d6)
- [修复] `xmp` 检查 device 错误的逻辑 [1d728f29](https://github.com/icyleaf/xiaomi-push/commit/1d728f29405fd31bcff1a6d4c6cd4940ab9690ce)

### v0.2.4

- 项目初发布
