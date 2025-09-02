---
title: 北京三家宽带运营商的简单对比
date: 2025-09-02 16:00:59
tags:
---

# 北京三家宽带运营商的简单对比

联通、电信、移动三家运营商，到底选哪家呢？除了价格外，各家速度怎么样呢？

这里比较了从两个VPS(美国和韩国)，回程到北京三家运营商，各自的traceroute结果。

## 美国VPS的traceroute结果

```
----------------------------------------------------------------------
北京电信
traceroute to 219.141.147.210, 30 hops max, 52 bytes payload, ICMP mode
1   140.204.226.141 AS31898  [OC-195]         美国 亚利桑那州 凤凰城  cloud.oracle.com
                                              0.31 ms / 0.31 ms / 0.26 ms
2   62.115.13.10    AS1299   [ARELION-NET]    美国 亚利桑那州 凤凰城  arelion.com
    oracle-ic-361031.ip.twelve99-cust.net     0.56 ms / 0.66 ms / 0.67 ms
3   62.115.13.9     AS1299   [ARELION-NET]    美国 亚利桑那 凤凰城  arelion.com
    phx-b5-link.ip.twelve99.net               1.68 ms / 1.41 ms / 1.97 ms
4   62.115.125.72   AS1299   [ARELION-NET]    美国 加利福尼亚 洛杉矶  arelion.com
                                              9.79 ms / 60.14 ms / * ms
5   62.115.185.213  AS1299   [ARELION-NET]    美国 加利福尼亚 洛杉矶 Telia-CT-Peer arelion.com
                                              11.70 ms / 12.00 ms / 96.93 ms
6   202.97.92.17    AS4134   [CHINANET-BB]    中国 北京   www.chinatelecom.com.cn  电信
                                              180.72 ms / 180.74 ms / 180.73 ms
7   *
8   *
9   *
10  106.120.254.2   AS4847   [CHINANET-GD]    中国 北京   chinatelecom.cn
                                              184.60 ms / 184.52 ms / 212.42 ms
11  219.141.147.210 AS4847   [CHINATELECOM-BJ] 中国 北京   chinatelecom.cn
                                              186.38 ms / 188.04 ms / 188.87 ms
----------------------------------------------------------------------
北京联通
traceroute to 202.106.50.1, 30 hops max, 52 bytes payload, ICMP mode
1   140.204.226.175 AS31898  [OC-195]         美国    cloud.oracle.com
                                              0.24 ms / 0.31 ms / 0.25 ms
2   62.115.13.10    AS1299   [ARELION-NET]    美国 亚利桑那州 凤凰城  arelion.com
    oracle-ic-361031.ip.twelve99-cust.net     0.69 ms / 0.71 ms / 0.74 ms
3   62.115.13.9     AS1299   [ARELION-NET]    美国 亚利桑那 凤凰城  arelion.com
    phx-b5-link.ip.twelve99.net               1.75 ms / 1.51 ms / 1.45 ms
4   62.115.125.72   AS1299   [ARELION-NET]    美国 加利福尼亚 洛杉矶  arelion.com
    lax-b22-link.ip.twelve99.net              19.15 ms / 9.57 ms / 9.55 ms
5   62.115.140.226  AS1299   [ARELION-NET]    美国 加利福尼亚 洛杉矶  arelion.com
                                              9.40 ms / 9.24 ms / 9.21 ms
6   62.115.140.237  AS1299   [ARELION-NET]    美国 德克萨斯 达拉斯  arelion.com
                                              157.63 ms / 157.42 ms / 158.61 ms
7   62.115.137.44   AS1299   [ARELION-NET]    美国 佐治亚州 亚特兰大  arelion.com
                                              159.34 ms / 160.15 ms / 168.56 ms
8   62.115.137.54   AS1299   [ARELION-NET]    美国 佐治亚 亚历山大  arelion.com
                                              157.30 ms / 157.33 ms / 157.44 ms
9   *
10  62.115.140.104  AS1299   [ARELION-NET]    法国 法兰西岛大区 巴黎  arelion.com
                                              149.25 ms / 149.29 ms / 149.21 ms
11  62.115.123.12   AS1299   [ARELION-NET]    德国 黑森州 美因河畔法兰克福  arelion.com
                                              156.95 ms / 157.09 ms / 156.98 ms
12  62.115.124.117  AS1299   [ARELION-NET]    德国 黑森州 美因河畔法兰克福  arelion.com
                                              156.77 ms / 157.04 ms / 157.25 ms
13  219.158.34.241  AS4837   [CU169-BACKBONE] 德国 黑森 美因河畔法兰克福  chinaunicom.cn
                                              244.99 ms / 245.00 ms / 244.97 ms
14  219.158.19.125  AS4837   [CU169-BACKBONE] 中国 广东 广州  chinaunicom.cn  联通
                                              249.40 ms / 248.93 ms / 248.87 ms
15  *
16  *
17  *
18  *
19  202.106.50.1    AS4808   [UNICOM-BJ]      中国 北京  丰台区 中国联通  联通
                                              247.81 ms / 247.85 ms / 247.94 ms
----------------------------------------------------------------------
北京移动
traceroute to 221.179.155.161, 30 hops max, 52 bytes payload, ICMP mode
1   140.91.194.140  AS31898  [ORACLE-CLOUD]   美国 亚利桑那州 凤凰城  cloud.oracle.com
                                              0.29 ms / 0.30 ms / 0.26 ms
2   4.7.247.122     AS3356                    美国 亚利桑那州 凤凰城  lumen.com
                                              1.33 ms / 1.58 ms / 1.30 ms
3   4.7.247.121     AS3356                    美国 亚利桑那 凤凰城  lumen.com
    lag-104.bear2.Phoenix1.Level3.net         1.50 ms / 1.52 ms / 1.52 ms
4   4.69.219.45     AS3356                    美国 加利福尼亚 洛杉矶  lumen.com
                                              10.69 ms / 10.10 ms / 15.74 ms
5   4.68.75.218     AS3356                    美国 加利福尼亚 洛杉矶  lumen.com
                                              10.08 ms / 10.40 ms / 10.24 ms
6   223.120.6.217   AS58453  [CMI-INT]        美国 加利福尼亚 洛杉矶  cmi.chinamobile.com  移动
                                              10.19 ms / 10.25 ms / 10.04 ms
7   223.120.12.214  AS58453  [CMI-INT]        中国 上海  CMI-CM-Peer cmi.chinamobile.com  移动
                                              200.95 ms / 201.42 ms / 201.06 ms
8   221.183.55.110  AS9808   [CMNET]          中国 北京  X-I chinamobileltd.com  移动
                                              200.55 ms / 200.48 ms / 200.56 ms
9   221.183.25.201  AS9808   [CMNET]          中国 北京  I-C chinamobileltd.com  移动
                                              203.08 ms / * ms / * ms
10  *
11  221.183.46.178  AS9808   [CMNET]          中国 北京   chinamobileltd.com  移动
                                              195.92 ms / 196.76 ms / 196.13 ms
12  221.183.130.142 AS9808   [CMNET]          中国 北京   chinamobileltd.com  移动
                                              207.00 ms / 206.88 ms / * ms
13  221.179.155.161 AS56048  [CMNET]          中国 北京   bj.10086.cn  移动
                                              198.36 ms / 198.29 ms / 198.40 ms

```

结论： 电信 > 移动 >> 联通。

1. 电信的路由非常直接，凤凰城->洛杉矶->北京，总用时186ms, 考虑到中美的距离，这个延时算是不错的了。
2. 移动的路由也还不错，凤凰城->洛杉矶->上海->北京，比电信多了上海的节点，延时193ms, 也还可以。
3. 联通的路由就很奇葩了，凤凰城 -> 洛杉矶 -> 达拉斯 -> 亚特兰大 -> 巴黎 -> 法兰克福 -> 广州 -> 北京，在美国转了几个州，然后跑到法国、德国，又从广州绕回了北京，延时247ms，比电信长了一半左右。


## 韩国VPS的traceroute结果

```
----------------------------------------------------------------------
北京电信
traceroute to 219.141.147.210, 30 hops max, 52 bytes payload, ICMP mode
1   140.91.214.3    AS31898  [ORACLE-CLOUD]   韩国 首尔特别市 首尔  cloud.oracle.com
                                              0.19 ms / 0.31 ms / 0.23 ms
2   154.18.20.59    AS174    [COGENT-BONE]    韩国 首尔   cogentco.com
                                              3.33 ms / 0.81 ms / 0.80 ms
3   *
4   *
5   154.54.86.137   AS174    [COGENT-BONE]    美国 加利福尼亚 圣何塞  cogentco.com
                                              136.75 ms / 136.71 ms / 136.94 ms
6   38.104.138.106  AS174                     美国 加利福尼亚 圣克拉拉  cogentco.com
                                              422.47 ms / 379.08 ms / 339.23 ms
7   *
8   *
9   202.97.61.137   AS4134   [CHINANET-BB]    中国 北京   www.chinatelecom.com.cn  电信
                                              161.16 ms / * ms / * ms
10  *
11  106.120.254.2   AS4847   [CHINANET-GD]    中国 北京   chinatelecom.cn
                                              188.12 ms / 173.28 ms / 171.49 ms
12  219.141.147.210 AS4847   [CHINATELECOM-BJ] 中国 北京   chinatelecom.cn
    bj141-147-210.bjtelecom.net               166.81 ms / 165.82 ms / 165.92 ms

----------------------------------------------------------------------
北京联通
traceroute to 202.106.50.1, 30 hops max, 52 bytes payload, ICMP mode
1   140.91.214.2    AS31898  [ORACLE-CLOUD]   韩国 首尔特别市 首尔  cloud.oracle.com
                                              0.25 ms / 0.27 ms / 0.26 ms
2   154.18.20.59    AS174    [COGENT-BONE]    韩国 首尔   cogentco.com
                                              0.74 ms / 2.43 ms / 1.15 ms
3   *
4   *
5   154.54.86.137   AS174    [COGENT-BONE]    美国 加利福尼亚 圣何塞  cogentco.com
    be3696.ccr41.sjc03.atlas.cogentco.com     136.77 ms / 136.35 ms / 136.62 ms
6   38.88.224.14    AS174                     美国 加利福尼亚 帕洛阿尔托 / 圣何塞  cogentco.com
                                              180.82 ms / 179.54 ms / 181.64 ms
7   219.158.117.1   AS4837   [CU169-BACKBONE] 中国 北京   chinaunicom.cn  联通
                                              177.09 ms / 177.44 ms / 177.12 ms
8   219.158.16.77   AS4837   [CU169-BACKBONE] 中国 北京   chinaunicom.cn  联通
                                              184.65 ms / 184.60 ms / 184.61 ms
9   219.158.18.65   AS4837   [CU169-BACKBONE] 中国 北京   chinaunicom.cn  联通
                                              179.40 ms / 184.10 ms / 179.50 ms
10  *
11  202.106.50.1    AS4808   [UNICOM-BJ]      中国 北京  丰台区 中国联通  联通
                                              185.23 ms / 185.20 ms / 185.16 ms

----------------------------------------------------------------------
北京移动
traceroute to 221.179.155.161, 30 hops max, 52 bytes payload, ICMP mode
1   140.91.214.30   AS31898  [ORACLE-CLOUD]   韩国 首尔特别市 首尔  cloud.oracle.com
                                              0.23 ms / 0.26 ms / 0.23 ms
2   116.0.79.170    AS6453   [TATA-COMMUNICATIONS] 印度    tatacommunications.com
                                              0.90 ms / 0.85 ms / 0.98 ms
3   *
4   *
5   209.58.61.34    AS6453   [TATAC-ARIN]     日本 东京都 东京  tatacommunications.com
                                              31.36 ms / 31.27 ms / * ms
6   209.58.61.43    AS6453   [TATAC-ARIN]     日本 东京都 东京  tatacommunications.com
                                              31.62 ms / 31.64 ms / 31.78 ms
7   223.120.14.182  AS58453  [CMI-INT]        中国 北京   cmi.chinamobile.com  移动
                                              83.27 ms / 83.21 ms / 83.35 ms
8   221.183.55.106  AS9808   [CMNET]          中国 北京  X-I chinamobileltd.com  移动
                                              82.97 ms / 83.00 ms / 82.94 ms
9   221.183.46.250  AS9808   [CMNET]          中国 北京  I-C chinamobileltd.com  移动
                                              84.87 ms / 135.30 ms / * ms
10  *
11  221.183.46.174  AS9808   [CMNET]          中国 北京   chinamobileltd.com  移动
                                              85.95 ms / 85.79 ms / 85.67 ms
12  221.183.130.134 AS9808   [CMNET]          中国 北京   chinamobileltd.com  移动
                                              87.53 ms / 86.80 ms / 87.39 ms
13  221.179.155.161 AS56048  [CMNET]          中国 北京   bj.10086.cn  移动
                                              87.94 ms / 87.13 ms / 87.00 ms
----------------------------------------------------------------------

```

结论： 移动 >>  电信 > 联通。

1. 移动路由，首尔->东京->北京，总用时87ms，延时非常不错。
2. 电信的路由，首尔->圣何塞->圣克拉拉->北京，绕道美国了，延时166ms。
3. 联通的路由，首尔->圣何塞->圣何塞->北京， 同样绕道美国，延时185ms。

## 小结

之前都说“南电信，北联通，移动在中间”，单纯就这次测试来看，联通在两次测试里都垫底，电信的表现不错，移动的表现有惊喜！


