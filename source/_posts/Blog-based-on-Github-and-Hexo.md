---
title: 使用Github和Hexo来建立个人Blog
date: 2018-09-23 14:22:23
tags:
---
之前的服务器被干掉了，结果数据还没有备份，有点坑爹了
重新开始

现在github的repo, 支持使用repo中的/docs/目录作为项目主页，用Hexo来建立blog就非常方便了，根本不需要使用deploy的步骤了。

修改_config.yml中的输出目录:

public_dir: docs


修改github repo的设置:

![Github Repo Setting](/img/github-repo.png)

