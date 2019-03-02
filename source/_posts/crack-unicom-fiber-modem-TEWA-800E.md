---
title: 破解北京联通的光猫TEWA-800E
date: 2019-03-02 16:59:16
tags:
---
最近更换了联通的光猫，型号是TEWA-800E, 结果发现联通小哥给装好以后，PPPoE的连接直接在光猫上进行了，自己的路由器只能拿到内部192.168.1.x的内部IP。这个没法接受啊

以路由器上标注的账号登录，只能是普通用户模式，很多设置的选项都不存在。搜了一下，发现现在已经有办法可以以CUAdmin/CUAdmin模式登录了。破解主要集中在两点：

1. 页面不显示用户名, 只有输入密码的地方，因为“user_name"这个field已经被固定设置为"user". 第一步就是要把这个field value给改成CUAdmin了 （F12找到"user_name"，将value修改为CUAdmin）
2. 页面有javascript, 当提交登录时，如果用户名不是user, 就提示错误并且禁止提交 （F12在Sources中找到一段限制非user用户不能登录的function定义，拷贝到Console中，删掉有关用户名限制的if判断，重新定义这个function）


上面这两个都可以通过dev tools直接修改。具体可以参考：

https://guanggai.org/thread-563-1-1.html

以管理员登录后，改变Internet的设置，改成桥接模式就可以了。注意光猫里面的设置会有很多不同的连接，需要首先在“连接名称”里，选择了"2_INTERNET_xxx"这个选项，然后再改设置。如下图：

![光猫设置](/img/2019/fiber-modem.jpg)

DHCP也可以关闭

然后重启，就可以在自己的路由器上进行PPPoE拨号了