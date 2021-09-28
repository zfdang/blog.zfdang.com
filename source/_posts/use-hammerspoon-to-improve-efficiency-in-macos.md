---
title: MacOS下使用HammerSpoon来提高效率
date: 2021-09-27 11:55:50
tags:
- HammerSpoon
- MacOS
---
## 从BTT到HammerSpoon

之前一直都用BetterTouchTool来做一些快捷的操作。但是这玩意是收费的，之前买的一个license, 现在居然失效了...

就想尝试着看看有没有类似的软件可以替代，于是找到了HammerSpoon!

HammerSpoon安装完之后，什么也干不了，需要自己来写配置文件，从而实现各种快捷操作，这个导致了它比较高的使用门槛！

## HammerSpoon的配置

这个是我的HammerSpoon配置：

https://github.com/zfdang/hammerspoon-config

使用起来也比较简单：

```
rm -rf ~/.hammerspoon
	
git clone https://github.com/zfdang/hammerspoon-config.git ~/.hammerspoon
```
	
然后在HammerSpoon里reload config即可

## 实现的功能


HyperKey: {"cmd", "alt", "ctrl", "shift"}  -- 定义超级快捷键

```
HyperKey + l: lock screen; 锁屏

HyperKey + b: show battery status on screen；在屏幕上显示电量

HyperKey + [: move app to left screen；把App移动到下一个屏幕

HyperKey + ]: move app to right screen；把App移动到上一个屏幕

HyperKey + return: maximize current window

HyperKey + left: resize current window to the left half of the screen

HyperKey + right: resize current window to the right half of the screen

HyperKey + up: resize current window to the top half of the screen

HyperKey + down: resize current window to the bottom half of the screen

HyperKey + x: launch application by x (see key2App in key-bindings.lua, you can customize it in your own way)

{"CMD","Ctrl"} + up: volume up

{"CMD","Ctrl"} + down: volume down
```

可以根据自己的需要，来定制功能。
