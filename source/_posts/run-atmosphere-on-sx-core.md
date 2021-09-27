---
title: 在续航版硬破解Switch上运行Atmosphere大气层系统
date: 2021-02-13 11:03:14
tags: 
- Switch
- Atmoshpere
---

## SWITCH破解的现状

Switch的游戏机，到目前为止，有几个不同硬件版本的主机:

* 工程代号是Erista的老版游戏机；
* 工程代号是Mariko的新版主机，包括续航版和Lite版；在2019年中发布；

针对Erista的老版游戏机，可以采用软接的方式进行破解；软接之后可以引导第三方系统，从而可以运行Atmosphere大气层系统，来玩破解游戏。

但是对于Mariko硬件版本的新游戏机，目前唯一的破解方式是采用焊接额外芯片的方式，进行“硬破解”，然后运行SX OS系统来玩破解游戏。

## 硬破解的方法

这个提供焊接芯片，并且提供了相应的破解系统的组织叫做Team Xecuter，提供的芯片的名字叫做SX Core, 提供的破解系统叫做SX OS.

SX的官网: https://sx.xecuter.com/

SX CORE芯片：

![SX CORE芯片](/img/2021/sx-core.png)

破解的流程一般是: 

1. 分别购买Switch机器和破解芯片SX CORE
2. 自行安装或者找人安装SX CORE芯片；操作比较复杂，需要拆机，然后把芯片焊接上去；
3. 在TF卡安装SX OS系统(boot.dat), 并且去SX的官网去申请License
4. 运行SX OS系统，开始游戏；在SX OS系统里，可以用SX Installer来安装游戏。

有几点说明：

1. SX CORE芯片是基于硬件的破解，目前对于Mariko硬件版本的主机都有效，不区分Switch的软件版本；
2. 但是SX OS需要随着Switch软件版本的升级而持续升级；
3. 目前SX OS的版本是3.1.0, 只能支持Switch 11.0.0的软件版本。如果不幸升级系统到了11.0.1软件版本, 那么目前SX OS的最新版也是无法支持的；
4. SX Team在去年底，被反盗版了。所以目前SX OS系统的进一步维护基本停滞了；并且SX CORE芯片的供应也出了问题，不太容易购买到了；
5. Switch的游戏，一般会对系统的软件版本有要求，基本新游戏或者新的更新都会要求最新的系统版本；

那么问题来了：对于这些已经硬破解了的Switch主机，之后还能玩新的游戏，或者更新游戏么？

一种做法是，对新游戏或者新更新进行破解，让它们不再需要最新版的SWITCH OS版本。这种游戏目前被称为Patched版本，对Switch OS版本的需求被改到了11.0.0, 也就是SX OS能支持的最高版本。

但这种方式俨然不是长久之计，以后如果游戏真的用到了新OS版本里的功能，就没法这么干了。

## 在硬破解的Switch上运行Atmoshpere大气层系统

SX Team被反盗版端了。但是Atmosphere系统，采取了打法律擦边球的方式，不能直接被启动，也不直接支持玩盗版游戏，所以目前还比较活跃，没被取缔。最新版0.18.0已经支持Mariko版本的主机，和11.0.1的OS版本了。

Atmosphere大气层系统： https://github.com/Atmosphere-NX/Atmosphere

在使用了SX CORE芯片硬破解的机器上，如果能引导Atmosphere大气层系统, 是不是就完美的解决这个问题了呢？

SX CORE芯片在开机后，会去加载TF卡上boot.dat的文件，这个文件是SX OS的系统；如果SX OS支持加载Atmosphere系统，是不是就可以实现这个目标了呢？

但是非常不幸，SX OS系统在某次更新后禁止加载Atmosphere的payload了！但是依然可以加载其他的payload, 比如Hekate；Hekate作为一个switch的bootloader，可以加载Atmosphere!

另外，SX team除了提供SX OS外，还提供了一个SX Gear的简单系统，这个系统唯一的功能就是在启动后，加载另外的一个payload，并且不需要License. 

所以最后的解决方法就是:

--> SX CORE芯片
--> 加载 SX Gear (/boot.dat)：缺省加载payload.bin, 可以在boot.ini(/boot.ini)里配置自动加载Hekate(/hekate_ctcaer_5.5.4.bin)
--> 加载Hekate(/hekate_ctcaer_5.5.4.bin)，可以在配置(/bootloader/hekate_ipl.ini)里配置Atmosphere系统，或者其他整合好的系统
--> 加载fusee-primary.bin
--> 加载Atmoshpere系统或者其他整合好的三方系统

经过这么一个长链之后，Atmosphere大气层系统就被启动起来了。

上述的一些配置，可以参考下面的文件(注意：不是完整的系统，只涉及了SX Gear及其配置, Hekate及其配置，fusee-primary.bin)：

https://blog.zfdang.com/img/2021/TF.zip

对应的几个软件的下载地址为：

SX Gear: https://sx.xecuter.com/download/SX_Gear_v1.1.zip
SX Gear本地备份：https://blog.zfdang.com/img/2021/SX_Gear_v1.1.zip
Hekate: https://github.com/CTCaer/hekate
Atmosphere: https://github.com/Atmosphere-NX/Atmosphere
Signature Patches: https://github.com/ITotalJustice/patches
ShallowSea, 一个整合了Atmosphere、玩破解游戏补丁、各种Homebrew App的集成包: https://github.com/carcaschoi/ShallowSea


### NOTE

如果之前使用过大白兔升级过系统，貌似 BOOT0, BOOT1会被破坏掉，导致无法正常引导Atmosphere大气层系统。

这时候，替换虚拟系统里的BOOT0, BOOT1就可以了。11.0.0的系统，可以使用这两个文件替换：

11.0.0的BOOT文件备份：https://blog.zfdang.com/img/2021/boot-backup.zip

然后替换TF卡里的这两个文件：

emuMMC/SD00/eMMC/BOOT0
emuMMC/SD00/eMMC/BOOT1

## 支持Switch国行版

Switch国行版的出现，让国内玩switch游戏，变得更容易，虽然游戏的数量很有限，但是国外的游戏卡都可以直接玩，问题也不大。

所以还是要支持正版！

