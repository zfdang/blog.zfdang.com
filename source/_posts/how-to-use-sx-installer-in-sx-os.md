---
title: 在Switch SX OS里如何安装和使用SX Installer
date: 2020-07-07 18:18:39
tags: Switch
---

SX OS本身是可以直接安装nsp格式的游戏的，但是如果追求更强大的安装工具的话，就需要使用SX Installer了。

SX Installer更强大的功能包括：支持安装nsz (压缩的nsp, 文件大小会小很多)，能把同一个游戏的升级包、DLC包同时安装，支持后台安装，等

SX Installer可以在team SX的网站里直接下载，目前的版本是V3.02

https://sx.xecuter.com/download/sxinstaller_v3.02.zip

# 安装

把下载好的压缩包在TF卡解开，然后把switch/sx/里的那个nsp文件复制到TF卡的根目录，最终的目录结构如下：

![TF目录结构](/img/2020/sx-installer-layout.png)

在 SX OS的install功能里，安装上面的那个nsp文件。

安装完之后，退出SX OS。在主页的游戏界面，就会出现SX Installer的图标了。

![SX Installer](/img/2020/sx-installer-entry.png)

注意：不要把switch/sx/这个目录删除了，这里的文件会被SX Installer使用到

# 配置

SX Installer缺省不能安装unsigned的包，需要打开这个功能。

在Option->Install unsigned Code里，打开这个设置

![config](/img/2020/sx-config-1.png)

按下A键后，会出现如下需要输入密码的界面:

![config-input](/img/2020/sx-config-2.png)

在这个界面输入密码：

![config-key](/img/2020/sx-config-3.png)

上、上、下、下、左、右、左、右、B、A、+

# 使用

SX installer启动之后，界面如下：

![config-menu](/img/2020/sx-installer-menu.png)

New Games里，同一个游戏的多个包也被整合到一个条目里了，非常方便。

安装游戏时，界面如图：

![install](/img/2020/sx-installer-install.png)

左侧显示了这个游戏有多少个升级包，多少个DLC等，多个安装包都被收集在了这里。

右侧有一些选项。个人建议：

1. 打开“install ALL DLC"
2. 打开"Install Latest Update" 
3. 根据需要打开或者关闭"Delete After"

安装开始之后，可以按B键，把安装任务放到后台执行，我们可以同步进行其他操作。

# 注意事项

1. 不能删除TF根目录的/switch/sx/目录
2. TF卡或者U盘里的游戏，需要把nsp/nsz文件都放到根目录里，貌似现在还不支持查找目录里的安装文件。好在SX installer会自动把这些文件按照游戏组织起来，使用起来也不算太不便。









