---
title: 不安装docker desktop的情况下使用docker compose
date: 2025-09-06 08:40:27
tags:
---


你遇到的这个错误：

```
docker: 'compose' is not a docker command.
```

说明你的 Docker CLI 没有启用 Docker Compose v2 插件。在 macOS 上常见原因有以下几种：

# 1. 你安装的是旧版 Docker CLI / Docker Desktop

新版的 Docker Desktop (>= 3.4) 默认自带 docker compose。

如果你用的是旧版，只有 docker-compose（带连字符），没有 docker compose（空格）。

👉 解决方法：升级 Docker Desktop：
下载最新版本：Docker Desktop for Mac

安装后再试：

```
docker compose version
```

# 2. 你是通过 Homebrew 安装 docker-cli 而不是 Docker Desktop

Homebrew 安装的 docker 只是 CLI 工具，不包含 compose 插件，需要单独装：

```
brew install docker-compose
```

⚠️ 注意：Homebrew 把 docker-compose 作为 V1 二进制，所以命令是：

```
docker-compose up
```

（连字符，而不是空格）

# 3. 手动安装 Compose v2 插件

如果你坚持不用 Docker Desktop，可以手动装 Compose v2：

```
# 确保插件目录存在
mkdir -p ~/.docker/cli-plugins

# 获取系统架构
ARCH=$(uname -m)

# 下载 docker compose v2
curl -SL "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-darwin-$ARCH" \
  -o ~/.docker/cli-plugins/docker-compose

# 赋予执行权限
chmod +x ~/.docker/cli-plugins/docker-compose

# 验证安装
docker compose version

```


然后就能用：

docker compose version
docker compose up


✅ 总结：

* 如果你用 Docker Desktop → 推荐升级到最新版，直接用 docker compose。

* 如果你只用 Homebrew CLI → 用 docker-compose（连字符）。

* 如果你想要 v2 但不用 Desktop → 手动装 CLI 插件。