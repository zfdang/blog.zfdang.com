---
title: OpenWrt下AdGuard Home如何和SSR Plus+公共工作
date: 2020-07-25 00:06:21
tags:
---

在OpenWRT下，使用AdGuard Home来简单去广告，同时使用SSR Plus+的GFW模式

总结了最佳的搭配模式为：

1. SSR Plus+，_运行模式_为"GFW列表模式"；_DNS解析方式_为 "使用PDNSD TCP查询并缓存"
2. AdGuard Home，运行在1053端口。_重定向模式_为： “重定向53端口到AdGuardHome”
3. AdGuard Home, 上游DNS服务器设置为: 127.0.0.1:53
4. DNSMasq, 上游DNS服务器设置为: 223.5.5.5, 180.76.76.76

优点： 希望被block的地址，会第一时间被干掉；在AdGuard Home里，也能看到客户端的IP地址。

最终DNS解析的流程如下：

![DNS workflow](/img/2020/ad_ssr.png)
