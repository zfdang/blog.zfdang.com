---
title: Moonpay OWS comments
date: 2026-03-25 17:44:34
tags:
---

OWS 是一个很好的“本地 self-custody + agent delegation”第一代标准。它把本地 wallet、agent token、policy、审计这些原本分散的能力整理成了统一模型，这一点很有价值。尤其是在单机、本地 CLI、个人 agent 工具的场景里，OWS 比“私钥放 .env”或者每个工具各管各的做法，明显前进了一大步。

但它的设计边界也非常明确：OWS 更适合“本机 agent”，不适合直接当作“agent-as-a-service”时代的最终安全模型。

核心原因有四个：

* 它信任的是本地 ~/.ows/ vault，而不是一个远程、隔离、可证明的执行环境。
* 它对 agent 的授权主要基于 token，而不是基于强身份或 code attestation。
* 它的 policy enforcement 本质上是 OWS SDK 路径里的逻辑边界，不是密码学边界。
* 在同一 OS 用户下，agent 之间几乎没有真正的隔离，最多只是“别的用户不能访问”，不是“同用户下的不同进程不能访问”。

这意味着：

如果一个 agent 同时拿到了自己的 raw token，又能读取 ~/.ows/keys/<key-id>.json，它理论上可以绕过 OWS 的正常 policy 路径，自己做 HKDF-SHA256 + AES-256-GCM，直接解出对应 wallet secret。换句话说，token 在这个模型里不只是认证凭据，也是解密能力。这就是典型的 token-as-capability 模型。

更进一步，即使 agent 没法解密别人的 wallet secret，在同用户模型下，它仍然可以读取、删除、篡改其他 agent 的 key file、policy file、audit log，形成 DoS、sabotage、审计污染等问题。
所以 OWS 的主要问题，不是“磁盘上的 AES-GCM 会不会被暴力破解”，而是：

* token 泄露
* 同用户进程无隔离
* policy 不是硬密码学边界
* 本地文件系统过于可信

所以我的结论会是：

OWS 作为“本地 agent 钱包标准”是有价值的；
但如果目标是未来的 remote agent、provider-hosted agent、agent marketplace、agent-as-a-service，那么它的安全边界明显不够强，后续必须升级到：

* 强 agent identity
* TEE / remote attestation
* 签名权与 agent runtime 分离
* policy 在更强的执行边界甚至链上结算层被 enforce


换句话说，OWS 是一个不错的起点，但不是终点。
