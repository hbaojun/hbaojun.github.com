---
layout: post
title: eclipse安装PyDev问题 
description: 在eclipse中安装PyDev，但是在Windows的Perference中没有出现Pydev的选项
date: '2014-07-11 12:00:00'
categories: ['python']
tags: [eclipse, python , PyDev]
---

最近要做一个关于SM2的测试，需要用到python脚本语言来完成。去年曾简单的写过一个测试DES算法的脚本，但早已忘的差不多了。现在要重新写一个，所幸功能比较简单，不难完成。但是这次在安装python的开发环境的时候遇到了曾经没有遇到的问题。(电脑重装过，曾经的开发环境已经更改)
<!--more-->
###问题###
在Windows XP SP3,JDK1.6-30使用eclipse LUNA(Java)版本中，安装PyDev 3.6.0和3.0.0都无法在Windows->Perference中出现PyDev的选项。

###尝试解决的办法####
1.更换eclipse的版本
尝试过eclipse LUNA中JEE及CLASSIC版本，但是问题没有得到解决;

2.更换PyDev的版本，3.6.0及3.0.0都曾尝试过，但是问题没有得到解决;

###解决办法###
从前面电脑的配置环境得知，JDK1.6-30，是1.6的版本。从网上查知，如果PyDev的版本在3.0.0及以上的，至少需要JDK1.7;如果是JDK1.6的环境，PyDev只能选择2.x的旧版本。   
经过在两台不同电脑上的尝试，一台安装JDK1.6，PyDev的版本为2.x, 可以正常使用;另外一台JDK1.7,安装PyDev3.6.0正常使用。

