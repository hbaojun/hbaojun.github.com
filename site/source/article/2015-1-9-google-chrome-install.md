---
layout: post
title: Kali安装google chrome
description: 安装完Kali系统后，准备安装google chrome,遇到一点小问题   
date: '2015-01-09 12:00:00'
categories: ['Linux']
tags: [Linux, Kali, google chrome]
---

###google chrome ###
在安装完Kali之后,只有自带的浏览器iceweasel,简单配置就是安装中文包,将它汉化.但是在linux系统下,论浏览器外观还是chrome浏览器看着最舒服,而且还有很坑的一点就是flash插件,特别是在看网易云课堂的时候,安装flash插件后还是提醒版本太低,不能通过浏览器查看视频.但是用google chrome可以看.
<!--more-->
在kali系统中,不能通过命令直接安装,使用apt-get install 会找不到,使用apt-cache search 命令只能找到开源的chromium版本.最后还的到官网把64位版本下载下来离线安装.至于下载地址google 一下就可以找到.

###安装过程###
下载下来的文件google-chrome-stable_current_amd64.deb,开始使用命令安装
<pre class="prettyprint">
huang@kali:~$ sudo dpkg -i ./google-chrome-stable_current_amd64.deb 
dpkg：警告：'ldconfig' not found in PATH or not executable
dpkg：警告：'start-stop-daemon' not found in PATH or not executable
dpkg: error: 2 expected programs not found in PATH or not executable
Note: root's PATH should usually contain /usr/local/sbin, /usr/sbin and /sbin
</pre>
由于在Kali中对root和普通用户所使用的PATH不同,导致有些命令在普通用户执行不了.因此要切换成root再来安装.
<pre class="prettyprint">
huang@kali:~$ sudo su -
root@kali:~#     //切换成root用户
</pre>
使用root账户来安装google chrome:  
<pre class="prettyprint">
root@kali:/home/huang#dpkg -i ./google-chrome-stable_current_amd64.deb 
Selecting previously unselected package google-chrome-stable.
(正在读取数据库 ... 系统当前共安装有 315419 个文件和目录。)
正在解压缩 google-chrome-stable (从 .../google-chrome-stable_current_amd64.deb) ...
dpkg: dependency problems prevent configuration of google-chrome-stable:
google-chrome-stable 依赖于 libappindicator1；然而：
未安装软件包 libappindicator1。
dpkg: error processing google-chrome-stable (--install):
依赖关系问题 - 仍未被配置
正在处理用于 man-db 的触发器...
正在处理用于 desktop-file-utils 的触发器...
正在处理用于 gnome-menus 的触发器...
正在处理用于 menu 的触发器...
在处理时有错误发生：
google-chrome-stable
</pre>
解决的办法是直接在root账户下,使用命令:   
<pre class="prettyprint">
root@kali:/home/huang# apt-get -f install
</pre>
会将缺省的依赖项都补充安装上,google chrome安装完成了.
