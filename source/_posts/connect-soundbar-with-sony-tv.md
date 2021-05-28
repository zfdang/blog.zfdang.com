---
title: 在SONY电视上正确使用Kodi和回音壁
date: 2021-05-28 14:21:35
tags:
---

配置：

	电视：Sony 65X8500G
	回音壁：雅马哈 YAS-109
	Kodi: 19.1

目标：解码音频，包括杜比(Dobly Digital) 和DTS Digital Surround。

## 回音壁支持格式

一般在说明书里可以找到：

![支持的音频输入](/img/2021/yas109-1.png)

## 连接方式

SONY电视的HDMI(eARC)，通过HDMI线，连接到Soundbar的HDMI OUT(ARC)口

![连接](/img/2021/yas109-2.png)

## 电视设置

直通模式改成自动。

To output DTS audio, follow these steps to set the Pass through mode to Auto:

	On the supplied remote control, press the HOME button.
	Select Settings.
	Select Display & Sound.
	Select Audio output.
	Select Pass through mode → Auto.

![电视](/img/2021/sony-1.jpeg)
![电视](/img/2021/sony-2.jpeg)

## Kodi设置

	系统-音频-声道数：2.0
	系统-音频-允许直通输出
	系统-音频-启用杜比数字（AC3）兼容功放
	  系统-音频-启用杜比数字（AC3）编码转换
	系统-音频-DTS兼容功放

![kodi](/img/2021/kodi-1.jpeg)
![kodi](/img/2021/kodi-2.jpeg)

## 测试

播放不同的音源，然后按Soundbar的INFO键来检查收到的信号：

![YAS](/img/2021/yas109-3.png)



