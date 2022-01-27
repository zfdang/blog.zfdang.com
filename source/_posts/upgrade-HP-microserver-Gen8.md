---
title:  更新HP MicroServer Gen8的各种固件
date: 2022-01-27 16:26:31
tags:
- NAS
---

作为一款外观经典的微型服务器，HP GEN8一直都是玩家手中的宝贝。最近把家里的这台服务器给升级了一下固件，总结如下：

## iLO

作为HP的服务器，跟PC最大的不同就是有这个iLO。有了它，你就可以用1根电源线和2根网线，把它开启之后扔在角落里，永远不需要跑到它面前做任何操作了。

从这里可以下载:

HPE Integrated Lights-Out 4 (iLO 4)

[https://support.hpe.com/connect/s/product?language=en_US&tab=driversAndSoftware&kmpmoid=1009143853#t=DriversandSoftware](https://support.hpe.com/connect/s/product?language=en_US&tab=driversAndSoftware&kmpmoid=1009143853#t=DriversandSoftware)

**GEN8能使用的是iLO4, 当前版本是2.79, 2021-11-25日发布**

升级之后，需要找一个license, 这样很多高级的功能才能使用。

## Intelligent Provisioning

[https://support.hpe.com/connect/s/product?language=en_US&cc=us&kmpmoid=1008862660&tab=driversAndSoftware&lang=en#t=DriversandSoftware](https://support.hpe.com/connect/s/product?language=en_US&cc=us&kmpmoid=1008862660&tab=driversAndSoftware&lang=en#t=DriversandSoftware)

[GEN8 Intelligent Provisioning Recovery Media](https://support.hpe.com/hpesc/public/swd/detail?swItemId=MTX_bf5521c396f2440bb0cb5efa87)

**GEN8能使用的是1.x版本的IP，当前版本是1.74，2021-07-22发布**

这里下载的是一个ISO, 在iLO里远程加载光盘，然后启动后自动更新服务器固件。

这里有一个简单的升级介绍：

[How to Reinstall or Upgrade Intelligent Provisioning](https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=emr_na-c03458406)

## System ROM (BIOS)

[HPE ProLiant MicroServer Gen8 Server- Drivers & Software](https://support.hpe.com/connect/s/product?language=en_US&ismnp=0&l5oid=5379860&kmpmoid=5390291&cep=on&tab=driversAndSoftware&driversAndSoftwareFilter=8000012)

[2019.04.04 (12 Jun 2019)](https://support.hpe.com/hpesc/public/swd/detail?swItemId=MTX_71b9ad7e388d434fb62f7542e3)

下载之后，在iLO里可以远程升级。

**当前版本2019.04.04， 2019-06-12发布**

## Service Pack for ProLiant (SPP)

官方地址为：

[ Service Pack for ProLiant (SPP)](https://techlibrary.hpe.com/us/en/enterprise/servers/products/service_pack/spp/index.aspx)

**The 2017.04.0 SPP is the last production SPP to contain components for the G7 and Gen8 server platforms**

但是GEN8的文件需要登录，可以从下面的地址下载：

[SPPGen81.4.iso](http://repos.storage37.net/hpsum/iso/P03093_001_spp-Gen8.1-SPPGen81.4.iso)

[SPPGen81.4.iso](https://soft.silinet.net/hp/P03093_001_spp-Gen8.1-SPPGen81.4.iso)

[SPPGen81.4.iso](http://dl1.technet24.ir/Downloads/HP/ServicePack/P03093_001_spp-Gen8.1-SPPGen81.4.iso)

--------

下面两个页面也有下载链接：

http://www.kaixinit.com/server/gen8/1750.html

https://technet24.ir/%D8%AF%D8%A7%D9%86%D9%84%D9%88%D8%AF-%D8%B3%D8%B1%D9%88%DB%8C%D8%B3-%D9%BE%DA%A9-hpe-service-pack-for-proliant-9872

