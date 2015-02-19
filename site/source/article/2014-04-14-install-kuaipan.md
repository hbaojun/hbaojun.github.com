---
layout: post
title: ArchLinux下安装快盘
description: 
date: 2014-04-13
categories: ['Linux']
tags: [快盘, Linux]
---

前两天把同步到网盘的资料整理了一下，需要同步到网上去。我个人可能是个网盘控吧，我把同一个文件夹同时用快盘和Dropbox同步。起初要这么做一是因为我平时需要同时在Windows和Linux操作系统下，所收集到的资料也同时需要在两个平台上使用，所以这些文件在两个操作系统下都需要一份，并且同步；<!--more-->二是在windows下快盘的同步速度不错，而且很早就开始使用了，在Linux下，Dropbox恰好有客户端，可以直接使用。所以我采用的方案是3台电脑之间互相同步。  

电脑A安装有ArchLinux操作系统，上面安装Dropbox程序;(校园网)  

电脑B安装有Windows金山快盘;(校园网)  

电脑C上安装有Dropbox和金山快盘;(电信网)

在校园网中，个人感觉用Dropbox的速度非常慢，特别是在windows7下，同步起来速度可以用龟速来形容;在linux下个人感觉速度还可以将就。Dropbox在电信网的速度还不错。  

金山快盘在电信和校园网的速度个人测试都比较理想，速度还是不错的。  

昨天在archlinux下用yaourt搜索了一下"kuaipan"这个关键词，结果找到了在Ubuntukylin下使用的金山快盘，二话不说，赶紧安装了事。  
安装过程很简单，使用  
<pre class="prettyprint">
sudo yaourt -S kuaipanky4uk
</pre>
就搞定。  
下面附带了几张快盘的截图:  
<img src="/images/kuaipan-setup.png" alt="快盘登录界面" align="middle">
快盘登录界面  
<img src="/images/settingfinished.png" alt="快盘设置完毕" align="middle">
快盘帐号设置完毕界面   
<img src="/images/kuaipan-status.png" alt="快盘状态栏图标" align="middle">   
快盘在系统状态栏的图标.我个人电脑将它设置为开机自启动。   

