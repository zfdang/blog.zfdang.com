---
title: MacOS下Cisco AnyConnect频繁要求管理员权限的解决方法
date: 2018-09-23 14:50:35
tags:
- MacOS
---

MacOS下，Cisco AnyConnect客户端，经常要求输入管理员密码，并且没办法记住用户名或者密码，特别讨厌。

Mac OS wants to make changes. Type an administrator's name and password to allow this:

![MacOS wants to make changes](/img/cisco-any-connect.png)

后来终于找到了解决的方法：

**https://discussions.apple.com/thread/6995022**

> • Launch /Applications/Utilities/Keychain Access
> 
> • Select "System" from the Keychains menu in the upper left
> 
> • Select "Certificates" from the Category menu in the lower left
> 
> • Find the entry that corelates to your computer's name in the list on the right, and click on the disclosure triangle.
> 
> • Secondary click on the "Private Key" entry that appears and select "Get Info" from the contextual menu that appears.
> 
> • Select the Access Control tab.
> 
> • You can then *either* add AnyConnect to the the list at the bottom of the screen (more secure, but you will need to repeat this process anytime the version of AnyConnect changes), *or* toggle the radio button to "Allow all applications to access this item".

如下图：

![Keychain](/img/keychain.png)

完美解决！
