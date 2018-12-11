---
title: 使用Fresco库时，显示超大图片时效果差的解决方法
date: 2018-12-11 17:37:34
tags:
---

使用Fresco来处理和显示图片很方便。可是最近遇到一个问题，Fresco显示大图片时，效果特别差，模糊感特别强烈。

后来终于找到了解决办法：

> https://github.com/facebook/fresco/issues/916

Fresco's max supported width/height in resizing
If you ResizeOptions, the converted one has a max size of 2048px, which makes wide or long image's quality low. If you can cut the source into smaller one, its quality will be better.

后来Fresco改进了ResizeOptions了，可以设置maxBitmapSize了。

> https://frescolib.org/javadoc/reference/com/facebook/imagepipeline/common/ResizeOptions.html

如果不担心收到的图片过于大的话，下面这个方法就很简单粗暴了：

> ImageRequestBuilder.newBuilderWithSource(Uri.parse(uri)).setResizeOptions(new ResizeOptions(Integer.MAX_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE))`

注意: 如果开启了硬件加速，android的OpenGL对图片的最大尺寸有要求。如果超过这个最大的size，图片直接显示空白，程序也不会报错。 参见： 

> https://stackoverflow.com/questions/15313807/android-maximum-allowed-width-height-of-bitmap

> https://stackoverflow.com/questions/7428996/hw-accelerated-activity-how-to-get-opengl-texture-size-limit


解决方法就是把图片动态切成多个小图，显示成多个图片，然后拼接在一起。

这里有一个例子：

>
>https://github.com/zfdang/zSMTH-Android/blob/master/app/src/main/java/com/zfdang/zsmth_android/fresco/WrapContentDraweeView.java

