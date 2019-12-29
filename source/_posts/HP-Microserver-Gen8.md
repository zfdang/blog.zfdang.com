---
title: HP Microserver Gen8
date: 2019-12-29 20:04:01
tags:
---

HP Gen8服务器买回来之后，一直没怎么折腾。原因有两个，一个是忙，一个是CPU啥的都太贵的。

这次趁周末，所有的CPU啥的都成了白菜价，就折腾了一把：

1. CPU，GEN8的绝配是E3-1265l v2, 当初的售价在1800左右，现在便宜了，淘宝上388入手。之所以说是绝配，一来是因为这块U是低功耗的，45w, 跟原装的G1610T的30W只多了10w,散热应该不用担心。二来性能没有比这块更强的了
2. 内存，闲鱼上买了一条原装的4G的，70块包邮
3. 升级了System ROM， HPIP (HP Intelligent Provisioning), 还有iLO



升级所有的固件，有一个SSP包可以安装，不过支持GEN8的最后的一个SSP包，也是两年前的了

P03093_001_spp-Gen8.1-SPPGen81.4.iso （可以在 https://www.chiphell.com/thread-1796234-1-1.html 下载）


GEN8最大的坑，就是噪音问题。很多人已经总结的很好了，就是GEN8内置的raid卡，如果打开了，并且把硬盘设置成了raid0, 那么很多系统是没法读取硬盘的smart信息的，硬盘也没法休眠，一直处于raid卡的唤醒中。但是如果把raid卡禁用了，支持采用ACHI模式，风扇的转速又居高不下，噪音太大。

我曾经把iLO升级到了最新版本2.72, 然后把system rom升级到2019.04.04， 然后硬盘采用ACHI模式。发现风扇的转速在15%左右。

想追求更低的噪音，就刷了破解版的1.32的iLO，发现风扇的转速只有8%， 比15%安静了不少。问题也很突出，iLO只有1.3.2版的，2.7.2支持了HTML5的remote console。好在ilo也不太常用，还是安静一点更重要，就坚持使用这个1.32的ilo了

见图：

![Firmware](/img//gen8/firmware.png)

![Storage](/img/gen8/storage.png)

![fan](/img/gen8/fan.png)


附破解版1.32 ilo：

[iLO-1.32-cracked](/img/gen8/FW_ ilo4 firmware_1.32_hacked.zip)

