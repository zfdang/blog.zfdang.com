---
title: 国行Switch可用的hosts配置
date: 2021-09-28 20:06:38
tags:
- Switch
- Atmosphere
---

和谐版的switch, 为了防止系统自动升级啥的，可以按照建议，把nintendo相关的域名给block了，参考

https://rentry.org/AvoidSwitchBan

不过在连接WIFI网络时，国行固件使用的是不同的域名来检测网络可用性，所以直接使用上面的hosts, 会导致系统认为网络不可用。

这是一个国行可用的hosts文件

```
# File: /atmosphere/hosts/default.txt
# Block Nintendo Servers
127.0.0.1 *nintendo.*
127.0.0.1 *nintendo-europe.com
127.0.0.1 *nintendoswitch.*
95.216.149.205 *conntest.nintendowifi.net
95.216.149.205 *ctest.cdn.nintendo.net
# connection check destination for china version
221.194.155.207 *ctest.cdn.n.nintendoswitch.cn
```