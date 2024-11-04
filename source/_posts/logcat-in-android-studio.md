---
title: android studio里logcat的问题
date: 2024-11-01 08:50:22
tags:
---
## logcat的过滤器

实际上有两个，一个是在UI界面上的filters

![](img/2024/logcat-2.png)

另外一个是在 settings里的

叫做ignore tags
![](img/2024/logcat-1.png)

settings -> Tools -> logcat -> ignore tags

这个ignore tags被添加之后，在ui上是无法清掉的，即使选择了clear all filters 也是没有效果的

## 被坑了好久，还以为系统出了啥问题了
