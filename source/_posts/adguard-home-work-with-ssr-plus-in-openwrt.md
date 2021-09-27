---
title: OpenWrt下AdGuard Home如何和SSR Plus+共同工作
date: 2020-07-25 00:06:21
tags:
- OpenWRT
- AdGuardHome
---

在OpenWRT下，使用AdGuard Home来简单去广告，同时使用SSR Plus+的GFW模式

总结了最佳的搭配模式为：

1. SSR Plus+， **运行模式** 为"GFW列表模式"；**DNS解析方式** 为 "使用PDNSD TCP查询并缓存"
2. AdGuard Home，运行在1053端口。**重定向模式** 为： “重定向53端口到AdGuardHome”
3. AdGuard Home, 上游DNS服务器设置为: 127.0.0.1:53
4. DNSMasq, 上游DNS服务器设置为: 223.5.5.5, 180.76.76.76

优点： 被block的DNS，会第一时间在AdGuard Home里被干掉；在AdGuard Home里，也能看到客户端的IP地址。

最终DNS解析的流程如下：

![DNS workflow](/img/2020/ad_ssr.png)
