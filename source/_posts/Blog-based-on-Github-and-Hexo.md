---
title: 使用Github和Hexo来建立个人Blog
date: 2018-09-23 14:22:23
tags:
---
之前的Blog服务器被干掉了，结果数据还没有备份，有点坑爹了~~~

重新开始!

现在github的repo, 支持使用repo中的/docs/目录作为项目主页，用Hexo来建立blog就非常方便了，如果想偷懒的话根本不需要deploy的步骤了。

### 修改hexo的输出目录

修改_config.yml中的输出目录:

`public_dir: docs`

然后 "/docs/“下面增加CNAME文件，指定blog的地址， 如 "blog.zfdang.com"

`$ hexo g`

把repo push到github上

### 修改github repo的设置

![Github Repo Setting](/img/github-repo.png)

### 收工！