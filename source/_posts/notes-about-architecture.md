---
title: 闲话架构
date: 2019-01-09 15:14:05
tags:
---
到底什么是架构？软件架构到底是为了什么，要做什么？

![Architecture](/img/2019/microservices-insight-diagram.png)

## 架构为了业务
抛开业务谈架构，是没有价值的，架构不能离开业务单独存在。

因为业务的不同，架构也是多种多样。

架构的最终目标，是为了支撑业务，不能满足业务发展的架构，不是一个好架构

## 架构为了协作
架构的目的，是为了使得团队规模变大时成员间的协作也能够顺利进行。
如果一个团队，就那么几个人，那么讨论不同架构的价值意义很小。这时候，可能一个单体应用，是最适合的方法。

当团队规模变大时，我们需要在架构上将不同成员的工作解耦，使得每个人可以相对独立的完成自己的工作，而不用相互之间有很强的依赖性。

所以架构的要求，要能做到解耦，从而使得协作变得容易。


## 架构需要不断演化

公司的业务和团队的规模总是在不断的变化。这种变化，使得架构要解决的问题也总是不一样的，所以架构要不断的演化。

不存在这么一个理想的架构，它在公司不同的发展阶段都是最好的。

架构要演化，就需要投入。

好的架构要能做到未雨绸缪，提前做好变化，从而能迎接团队、业务的变化。