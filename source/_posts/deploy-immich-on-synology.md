---
title: 在群晖里部署Immich
date: 2023-10-24 10:37:04
tags:
---

群晖是一个非常不错的NAS系统。自带了Synology Photos, 也是一个非常不错的管理照片的软件。

可是群晖这个Photos的功能，总是有一些不如人意的地方，于是就琢磨能不能在群晖上部署三方的照片管理软件。

关于三方的照片管理软件，这里有一个比较详细的对比，如果有兴趣了解更多的话，可以看看：

**Free and OpenSource Photo Libraries**

> https://meichthys.github.io/foss_photo_libraries/

比较了几个之后，对Immich和Photoprism还比较满意，最后选择Immich。

> https://immich.app/

主要原因有几个：

* 人脸识别的功能格外强大。对比之后，感觉比Google Photos的准确率都高不少，自己也可以自由选择不同的模型来提高精度
* 功能和界面通Google Photos非常相似，可以无缝切换
* 带有照片地图的功能，可以通过地图来看各个地方拍摄照片，挺有意思...

下面来说说在群晖里如何部署Immich.

## 安装Container Manager

Immich支持docker compose的模式来部署。

群晖的Container manager，现在支持“项目”的方式来部署docker了。

> 创建项目
> 通过项目仪表板可以使用 Compose 文件创建、操作和管理多容器 Docker 项目。
> 

![](/img/immich/dockers.jpg)

安装完Container manager之后，群晖会在磁盘里创建两个目录：

1. /volume1/@docker   系统隐藏目录，Container Manager使用
2. /volume1/docker	用户来保存docker相关文件的地方

## Immich的部署文档

首先阅读Immich的部署文档：

> https://immich.app/docs/install/docker-compose

Immich的External Library功能：

> https://documentation.immich.app/docs/features/libraries


下面开始部署。

## 创建Immich需要的数据目录

部署Immich，只需要指定图片上载目录就可以了，这个目录在.env文件里指定。

但是Immich会使用docker系统自动创建的3个volumes:

```volumes:
  pgdata:
  model-cache:
  tsdata:
```
所以建议把这三个目录也创建好了，直接替换原始YAML里volume, 使得所有的Immich数据都放在一起。

最终的文件目录如下：

* 4个目录需要手工创建
* .env文件需要手工上载
* compose.yaml会由container manager自动创建

![](/img/immich/folders.jpg)

## 设置YAML文件和env文件

YAML文件。修改的地方，主要就是几个service的volumes设置。

**immich-server 和   immich-microservices还增加了群晖照片目录的只读挂载，这样就可以在Immich里访问群晖照片里的文件了**

>       - /volume1/photo:/mnt/media/synology:ro


```
version: "3.8"

services:
  immich-server:
    container_name: immich_server
    image: ghcr.io/immich-app/immich-server:${IMMICH_VERSION:-release}
    command: ["start.sh", "immich"]
    volumes:
      - ${UPLOAD_LOCATION}:/usr/src/app/upload
      - /volume1/photo:/mnt/media/synology:ro
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - .env
    depends_on:
      - redis
      - database
      - typesense
    restart: always

  immich-microservices:
    container_name: immich_microservices
    image: ghcr.io/immich-app/immich-server:${IMMICH_VERSION:-release}
    # extends:
    #   file: hwaccel.yml
    #   service: hwaccel
    command: ["start.sh", "microservices"]
    volumes:
      - ${UPLOAD_LOCATION}:/usr/src/app/upload
      - /volume1/photo:/mnt/media/synology:ro
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - .env
    depends_on:
      - redis
      - database
      - typesense
    restart: always

  immich-machine-learning:
    container_name: immich_machine_learning
    image: ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION:-release}
    volumes:
      - /volume1/docker/immich/mlcache:/cache
    env_file:
      - .env
    restart: always

  immich-web:
    container_name: immich_web
    image: ghcr.io/immich-app/immich-web:${IMMICH_VERSION:-release}
    env_file:
      - .env
    restart: always

  typesense:
    container_name: immich_typesense
    image: typesense/typesense:0.24.1@sha256:9bcff2b829f12074426ca044b56160ca9d777a0c488303469143dd9f8259d4dd
    environment:
      - TYPESENSE_API_KEY=${TYPESENSE_API_KEY}
      - TYPESENSE_DATA_DIR=/data
      # remove this to get debug messages
      - GLOG_minloglevel=1
    volumes:
      - /volume1/docker/immich/tsdata:/data
    restart: always

  redis:
    container_name: immich_redis
    image: redis:6.2-alpine@sha256:70a7a5b641117670beae0d80658430853896b5ef269ccf00d1827427e3263fa3
    restart: always

  database:
    container_name: immich_postgres
    image: postgres:14-alpine@sha256:28407a9961e76f2d285dc6991e8e48893503cc3836a4755bbc2d40bcc272a441
    env_file:
      - .env
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_DB: ${DB_DATABASE_NAME}
    volumes:
      - /volume1/docker/immich/pgdata:/var/lib/postgresql/data
    restart: always

  immich-proxy:
    container_name: immich_proxy
    image: ghcr.io/immich-app/immich-proxy:${IMMICH_VERSION:-release}
    environment:
      # Make sure these values get passed through from the env file
      - IMMICH_SERVER_URL
      - IMMICH_WEB_URL
    ports:
      - 8080:8080
    depends_on:
      - immich-server
      - immich-web
    restart: always

volumes:
  pgdata:
  model-cache:
  tsdata:

```

.env文件

```
# You can find documentation for all the supported env variables at https://immich.app/docs/install/environment-variables

# The location where your uploaded files are stored
UPLOAD_LOCATION=/volume1/docker/immich/upload

# The Immich version to use. You can pin this to a specific version like "v1.71.0"
IMMICH_VERSION=release

# Connection secrets for postgres and typesense. You should change these to random passwords
TYPESENSE_API_KEY=some-random-text
DB_PASSWORD=postgres

# The values below this line do not need to be changed
###################################################################################
DB_HOSTNAME=immich_postgres
DB_USERNAME=postgres
DB_DATABASE_NAME=immich

REDIS_HOSTNAME=immich_redis
```

## 在Immich里允许用户访问外部目录

首先，管理员需要设置用户权限，使得用户可以访问外部目录。

> Administration -> Users -> Edit -> External Path

![](/img/immich/user-1.jpg)

![](/img/immich/user-2.jpg)


## 在用户设置里，添加external library

点击右上角的用户图标，然后选择

> “Account Settings"

![](/img/immich/external-1.jpg)

> Libraries -> Create External Library

添加external library, 并设置名字和路径(/mnt/media/synology)：

![](/img/immich/external-2.jpg)

因为群晖会在图片目录里创建很多隐藏的文件夹，用来保存缩略图等信息，所以需要把这些目录也都给排除了.

```
 Exclusion syntax: **/@eaDir/**
```

![](/img/immich/external-3.jpg)

## 使用Immich

有时候，群晖会提醒安装Web Station, 但是Immich并不需要这个。部署完毕之后，就可以直接访问:8080端口（看你YAML里的设置）来访问Immich了

![](/img/immich/immich.jpg)