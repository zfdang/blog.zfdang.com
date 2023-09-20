---
title: Chrome技巧：自动填充密码时取消指纹认证
date: 2023-09-20 09:13:27
tags:
---

新版的Chrome, 在自动填充网页的密码时，会要求指纹认证。

这个功能按说挺好，更安全了，可是用户体验很糟糕：每次自动填充密码后，都需要抬手去验证一下指纹...

怎么禁用这个功能呢？那自然需要万能的chrome flags

`chrome://flags/`

然后搜索 **biometric**, 如下图

![禁止指纹认证](/img/2023/biometric-chrome.jpg)


将 **biometric-authentication-for-filling** 禁止了，然后重启Chrome。之后填充密码时，就不会要求指纹认证了...

