---
title: 实体EUICC esim卡在android 16下面的问题
date: 2025-11-29 21:51:55
tags:
---

# 问题

**“写入 profile 后，EasyEUICC 无法再识别实体 eUICC 卡，但禁用 profile 后又能识别”**

 ——这种现象在 EUICC 体系里其实是有明确原因的。

 
# 核心原因

Android 16 上的 LPA（Local Profile Assistant）/ Telephony Service 占用 eUICC 通道，导致第三方工具无法再访问

你现在观察到的现象符合一种典型情况：

> 当某个 eSIM Profile 被激活后，手机系统会独占 eUICC 的通信通道，阻止外部软件（如 EasyEUICC）再次进入 EUICC 的管理通道（ISD-R）

## 详细解释如下
 
### 技术原理
1. EUICC 有两个不同的安全域

* ISD-R（Root / 管理安全域）
	*	外部写 profile、管理卡的入口
	*	EasyEUICC 就是通过 ISD-R 通道与 eUICC 通信。
* ISD-P（Profile 的安全域）
	* 已激活的运营商 profile 工作时占用它。

当 profile 被激活时：

➜ Android 系统的 LPA 和 modem 会自动锁定到 ISD-P 的通道


这是为了保证以下事情：

* 基带稳定性
* profile 的安全性
* 防止外部应用篡改活跃 profile


因此：

* 👉 系统不允许外部工具再访问 ISD-R（管理安全域）
* 👉 EasyEUICC 就检测不到实体卡了（其实卡还在，只是无法进入管理模式）


当你禁用 profile 时，Android 释放了 ISD-P，并重新开放 ISD-R


### 禁用 profile 后：

* Android telephony 切回 "无激活 profile" 状态
* modem 释放占用的 ISD-P
* LPA 不再锁定 eUICC
* 所以外部应用（EasyEUICC）又可以访问 ISD-R 了

于是你看到：

* 禁用 profile → EasyEUICC 又可以识别 eUICC
* 激活 profile → EasyEUICC 再次无法识别


### Android 16（基于 Android U）对 eSIM 访问权限更加严格了

从 Android 14/15/16 开始，Google 加强了以下限制：

* 第三方 app 无权访问 EuiccManager 的管理级 API
* 运营商 profile 激活期间锁定外部通道（APDU 通道）
* 多 profile 并发的时候更严格阻断外部工具访问 eUICC

许多非系统 LPA（如 EasyEUICC）都会受影响。

你看到的行为正是 Android 16 的新策略导致的。

### 为什么激活的 profile 能正常工作，但 EasyEUICC 却认为实体卡“消失”？

因为：

* profile 工作走的是 modem + ISD-P 支持的普通通信（正常注册网络）
* EasyEUICC 需要访问 ISD-R（管理通道）

当 ISD-P 被占用，ISD-R 不允许并发访问，因此：

* ✔ profile 仍能正常注册网络
* ✘ EasyEUICC 无法进入管理通道 → “无法识别 eUICC”

这是完全正常的、安全策略。

# 结论
你遇到的不是 bug，也不是 eSIM 写坏了，而是 Android 16 的正常安全机制。

| 状态          | ISD-R（管理）    | ISD-P（运营商 profile） | EasyEUICC |
| ----------- | ------------ | ------------------ | --------- |
| profile 未激活 | ✔ 空闲         | ✘ 未使用              | ✔ 可以识别    |
| profile 激活  | ✘ 锁定，不开放给第三方 | ✔ 被系统占用            | ✘ 无法识别    |

