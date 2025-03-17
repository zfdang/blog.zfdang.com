---
title: 在安卓程序里运行二进制代码
date: 2025-03-17 08:06:50
tags:
---


# 在安卓程序里运行二进制代码

在安卓应用里运行可执行程序

run binary file in android app

这里以《象棋鱼》程序运行pikafish引擎为例子

相关的文件：

```
https://github.com/zfdang/chinese-chess-fish-android/tree/master/app/src/main/pikafish/

https://github.com/zfdang/chinese-chess-fish-android/blob/master/app/build.gradle.kts

https://github.com/zfdang/chinese-chess-fish-android/blob/master/app/src/main/java/org/petero/droidfish/engine/PikafishExternalEngine.java

https://github.com/zfdang/chinese-chess-fish-android/blob/master/app/src/main/java/org/petero/droidfish/engine/ExternalEngine.java
```


## pikafish引擎运行的问题

《象棋鱼》程序会在程序里启动pikafish进程，并通过uci协议和pikafish进程进行通讯。

在Android Q之前，安卓程序可以将pikafish从assets里复制到data目录，然后运行data目录里的二进制文件。

但是Android Q之后，为了安全，程序就不允许运行data目录里的文件了。

	error=13, Permission denied

From Android Q onwards, you cannot execute binaries in your app's private data directory

https://stackoverflow.com/questions/60370424/permission-is-denied-using-android-q-ffmpeg-error-13-permission-denied

```
The change to block exec() on application data files for targetAPI >= Q is working-as-intended.
Please see https://android-review.googlesource.com/c/platform/system/sepolicy/+/804149 for background on this change.
 Calling exec() on writable application files is a W^X (https://en.wikipedia.org/wiki/W%5EX) violation
 and represents an unsafe application practice.
Executable code should always be loaded from the application APK.

While exec() no longer works on files within the application home directory, it continues
to be supported for files within the read-only /data/app directory. In particular, it
should be possible to package the binaries into your application's native libs directory
and enable android:extractNativeLibs=true, and then call exec() on the /data/app artifacts.
 A similar approach is done with the wrap.sh functionality,
documented at https://developer.android.com/ndk/guides/wrap-script#packaging_wrapsh .

Additionally, please be aware that executables executed via exec() are not managed according
 to the Android process lifecycle, and generally speaking, exec() is discouraged from Android
applications. While not Android documentation, Using "exec()" with NDK covers this in some
detail. Relying on exec() may be problematic in future Android versions.
```


## Android Q之后的解决方法

	https://withme.skullzbones.com/blog/programming/execute-native-binaries-android-q-no-root/

这篇文章里，介绍了一种方法，将pikafish文件作为jniLibs，复制到程序的lib目录里运行，这种方法是Android新版本也允许的。

《象棋鱼》里的具体代码为：

### app/build.gradle.kts

创建一个task, 将src/main/pikafish/里的所有文件都打包成native-libs.jar

这个task将作为preBuild的依赖存在。

```
tasks.register<Jar>("nativeLibsToJar") {
    description = "create a jar archive of the native libs"
    destinationDirectory.set(layout.buildDirectory.dir("native-libs"))
    archiveBaseName.set("native-libs")
    from(fileTree("src/main/pikafish/") {
        include("**/*")
    })
    into("lib/")
}

tasks.named("preBuild") {
    dependsOn(tasks.named("nativeLibsToJar"))
}
```

在《象棋鱼》的依赖里，添加生成的native-libs.jar

```
    implementation(files("$buildDir/native-libs/native-libs.jar"))
```

### src/main/pikafish/的内容

按照架构，将要运行的二进制程序放到对应的目录里。这里只支持arm64-v8a, 所以其他目录都为空。


```
❯ pwd
app/src/main/pikafish
❯ tree
.
├── arm64-v8a
│   ├── libpikafish-armv8-dotprod.so
│   ├── libpikafish-armv8.so
│   ├── libpikafish.ini.so
│   └── libpikafish.nnue.so
├── armeabi-v7a
│   └── arm32.txt
├── x86
│   └── X86.txt
└── x86_64
    └── x86_64.txt

5 directories, 7 files
```

### 调用代码

app/src/main/java/org/petero/droidfish/engine/ExternalEngine.java

```
    String nativeLibraryDir = ChessApp.getContext().getApplicationInfo().nativeLibraryDir;
	String PikafishEngineFile = "libpikafish-armv8-dotprod.so";
    File binFile = new File(nativeLibraryDir, PikafishEngineFile);

    String exePath = binFile.getAbsolutePath();
    Log.d("ExternalEngine", "Starting engine: " + exePath);

    String engineWorkDir = new File(exePath).getParentFile();

    ProcessBuilder pb = new ProcessBuilder(exePath);
    pb.directory(engineWorkDir);
    synchronized (EngineUtil.nativeLock) {
        engineProc = pb.start();
    }
    reNice();
```


## 上述方法在debug/release版本的差异

上面的方法，确实可以把目录里的任意文件都打包进apk里去。

debug版本在安装时，所有的文件也可以正常的安装到lib目录里去

但是，release版本，在安装到设备的时候，会过滤非libxxx.so格式的文件！！！只有符合这个格式的，才会被复制到lib里去

所以如果你的可执行程序或者其他文件不符合这个规则，目前的解决方法是只能改名字了


## 最终的二进制文件目录

```
Starting engine: /data/app/~~PJhGbsOzqIChNCREMdzKoQ==/com.zfdang.chess-6oDqfHyzJXlrztkqRcwi-Q==/lib/arm64/libpikafish-armv8.so
setOption: evalfile /data/app/~~PJhGbsOzqIChNCREMdzKoQ==/com.zfdang.chess-6oDqfHyzJXlrztkqRcwi-Q==/lib/arm64/libpikafish.nnue.so

```