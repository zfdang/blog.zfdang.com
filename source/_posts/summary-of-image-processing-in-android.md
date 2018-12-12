---
title: android处理图片的一些问题总结
date: 2013-03-12 09:20:41
tags:
---

**第一个问题是out of memory**

> java.lang.OutOfMemoryError: bitmap size exceeds VM budget

这个据说是VM对一个程序申请的所有的bitmap对象会有一个最大值的要求。解决这个问题有几个方法：

1. 从源文件生成图片时，直接将图片缩小，而不是加载原始大小的图片。如下代码：

            Bitmap bitmap = null;
            if (mUseZoomOut || mUseZoomIn) {
                // decode image size (decode metadata only, not the whole image)
                o = new BitmapFactory.Options();
                o.inJustDecodeBounds = true;
                stream = new FileInputStream(filename);
                BitmapFactory.decodeStream(stream, null, o);
                stream.close();

                // get original image size
                int inWidth =  o.outWidth;
                int inHeight = o.outHeight;
                clog(String.format("Original bitmap size: (%dx%d).", inWidth, inHeight));

                // get size for pre-resized image
                o = new Options();
                o.inSampleSize = Math.max(inWidth/targetWidth, inHeight/targetHeight);
            }

            // decode pre-resized image
            stream = new FileInputStream(filename);
            // o.inPurgeable = true;
            bitmap = BitmapFactory.decodeStream(stream, null, o);
            stream.close();
            clog(String.format("Pre-sized bitmap size: (%dx%d).", bitmap.getWidth(), bitmap.getHeight()));

这里有一个真实的例子：
> https://github.com/zfdang/asm-android-client-for-newsmth/blob/master/src/com/koushikdutta/urlimageviewhelper/UrlImageViewHelper.java

2. 及时删除不需要使用的bitmap对象，不要将所有的对象都cache住

3. 增加程序的heap size。从某个版本开始，android manifest文件里有一个新的属性了：

        android:largeHeap="true"


> android:largeHeap
> 
> Whether your application's processes should be created with a large Dalvik heap. This applies to all processes created for the application. It only applies to the first application loaded into a process; if you're using a shared user ID to allow multiple applications to use a process, they all must use this option consistently or they will have unpredictable results.
> Most apps should not need this and should instead focus on reducing their overall memory usage for improved performance. Enabling this also does not guarantee a fixed increase in available memory, because some devices are constrained by their total available memory.
> To query the available memory size at runtime, use the methods getMemoryClass() or getLargeMemoryClass().

**第二个问题是** Bitmap too large to be uploaded into a texture exception

这个问题下面链接有详细描述：

> http://stackoverflow.com/questions/7428996/hw-accelerated-activity-how-to-get-opengl-texture-size-limit

简单说就是硬件加速的时候，对图片的大小有限制。不同设备可能有不同的最大值。这个问题悲催的地方是，程序貌似没有捕获到这个exception, 结果是程序也不报错，图片也显示不出来。只有看debug log才能发现这个error message.

一个解决的方法是禁止硬件加速，简单粗暴：

	android:hardwareAccelerated="false"


> android:hardwareAccelerated
> Whether or not hardware-accelerated rendering should be enabled for all activities and views in this application — "true" if it should be enabled, and "false" if not. The default value is "true" if you've set either minSdkVersion or targetSdkVersion to "14" or higher; otherwise, it's "false".
> Starting from Android 3.0 (API level 11), a hardware-accelerated OpenGL renderer is available to applications, to improve performance for many common 2D graphics operations. When the hardware-accelerated renderer is enabled, most operations in Canvas, Paint, Xfermode, ColorFilter, Shader, and Camera are accelerated. This results in smoother animations, smoother scrolling, and improved responsiveness overall, even for applications that do not explicitly make use the framework's OpenGL libraries.
> Note that not all of the OpenGL 2D operations are accelerated. If you enable the hardware-accelerated renderer, test your application to ensure that it can make use of the renderer without errors.
> For more information, read the Hardware Acceleration guide.

比较好的解决方法是类似google map的实现：将图片分成不同的块，每次加载需要的块。android提供了一个方法：

http://developer.android.com/reference/android/graphics/BitmapRegionDecoder.html

> public void drawBitmap (Bitmap bitmap, Rect src, RectF dst, Paint paint)

> public Bitmap decodeRegion (Rect rect, BitmapFactory.Options options)

采取上述操作后，就可以加载很多图片，同时也可以显示超级大图了。

也有一个例子，是使用Fresco这个库来显示超长图片的：

> https://github.com/zfdang/zSMTH-Android/blob/master/app/src/main/java/com/zfdang/zsmth_android/fresco/WrapContentDraweeView.java
> 

上面的例子里，图片如果过宽，先会被缩放到合适的宽度；然后根据高度和openGL支持的最大高度，把图片裁剪成多个符合要求的图，然后绘制在一起。
