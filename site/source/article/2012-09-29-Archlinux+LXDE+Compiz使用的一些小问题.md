---
layout: post
title: 'Archlinux LXDE+Compiz使用的一些小问题'
date: '2012-09-29 15:58:00'
comments: true
categories: ['Linux']
---

<p>最新使用Archlinux遇到一些小问题,幸好这些问题都被解决了.下面对这些问题进行一点简单的总结.
1. 壁纸问题
遇到的壁纸问题就是壁纸跟黑屏不断的闪烁,而且CPU使用率很高,一会壁纸,一会是黑色背景屏幕.google了很多也没有找到解决的办法.最后在无意之间设置了一下结果好了.
<!--more-->
1.将compiz重新安装
2.到compiz Fusion Icon中启用壁纸功能,然后设置好壁纸.
3.然后到桌面右键设置壁纸跟上面一步中壁纸设置成一样.然后就不会跳闪了.</p><ol><li><p>Gvim的配置文件问题
使用gvim首先问题便是配置文件的配置问题.vim软件之所以强大就是因为其配置后使用非常方便,强大的快捷键及插件功能,能实现强大的扩展功能.
用gvim自带设置默认的字体没打开一个文件真是惨不忍睹,看着实在恶心.但是设置字体的时候,我在新建.gvimrc文件中用:set guifont? 命令,返回:

<code>
guifont=DejaVu Sans Mono:h10:cANSI
</code>

但是直接将这一行复制到.gvimrc文件中,打开gvim没有任何效果.可见设置错误.
经过个google后,这些空行在gvim配置文件中默认被认为是分割符.真正的要被设置为:

<code>
set guifont=DejaVu Sans Mono 10   ##可以网上搜索
</code>

便可以.至于其他的配置可以参考VIM的配置文件,网上有好多.</p></li><li><p>用Claws Mail连接Gmail的问题
不知道最近为什么,从教育网连接Gmail收发电子邮件总是连接SLL 955端口超时.开始以为是客户端配置有问题,将邮件账户删除了重新配置,安装thunderbird 客户端收发电子邮件等等方式都行不通,实在找不到啥原因了.
由于在教育网,利用ipv6翻墙很容易,昨天恰好修改hosts文件,在这个文件中找到了另外一个Gmail的pop3服务器: pop.googlemail.com ,利用的是ipv6.把原有的pop.gmail.com替换掉,然后试着重新接受新邮件,没有出现SSL 995连接超时提示,顺利接收新邮件.</p></li></ol>
