---
title: 在MacOS里使用sublime text作为缺省的编辑器
date: 2025-05-22 10:25:00
tags:
---

安装了Xcode之后，这厮会把很多文件的缺省打开方式设置为它自己，但是它又是那么的臃肿...

	https://www.darraghoriordan.com/2021/09/15/vscode-default-text-files-mac


## 找到你希望使用的编辑器的名字

	osascript -e 'id of app "Sublime Text"'


com.sublimetext.4

## 安装小工具

	brew install duti


## 更改缺省的打开方式

```
duti -s com.sublimetext.4 public.json all
duti -s com.sublimetext.4 public.plain-text all
duti -s com.sublimetext.4 public.python-script all
duti -s com.sublimetext.4 public.shell-script all
duti -s com.sublimetext.4 public.source-code all
duti -s com.sublimetext.4 public.text all
duti -s com.sublimetext.4 public.unix-executable all
# this works for files without a filename extension
duti -s com.sublimetext.4 public.data all

duti -s com.sublimetext.4 .c all
duti -s com.sublimetext.4 .cpp all
duti -s com.sublimetext.4 .cs all
duti -s com.sublimetext.4 .css all
duti -s com.sublimetext.4 .go all
duti -s com.sublimetext.4 .java all
duti -s com.sublimetext.4 .js all
duti -s com.sublimetext.4 .sass all
duti -s com.sublimetext.4 .scss all
duti -s com.sublimetext.4 .less all
duti -s com.sublimetext.4 .vue all
duti -s com.sublimetext.4 .cfg all
duti -s com.sublimetext.4 .json all
duti -s com.sublimetext.4 .jsx all
duti -s com.sublimetext.4 .log all
duti -s com.sublimetext.4 .lua all
duti -s com.sublimetext.4 .md all
duti -s com.sublimetext.4 .php all
duti -s com.sublimetext.4 .pl all
duti -s com.sublimetext.4 .py all
duti -s com.sublimetext.4 .rb all
duti -s com.sublimetext.4 .ts all
duti -s com.sublimetext.4 .tsx all
duti -s com.sublimetext.4 .txt all
duti -s com.sublimetext.4 .conf all
duti -s com.sublimetext.4 .yaml all
duti -s com.sublimetext.4 .yml all
duti -s com.sublimetext.4 .toml all
```