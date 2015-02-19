---
layout: post
title: Kali中xterm字体设置
description: 安装Kali系统，我经常使用xterm终端程序,如果不对xterm做些许配置,其界面是相当丑陋的,但经过简单配置后,感觉它还是比自带的gnome的terminal程序好用.
date: '2015-01-08 12:00:00'
categories: ['Linux']
tags: [Linux, Kali, xterm]
---

在Kali系统中,使用xterm终端遇到很奇怪的问题,就是下划线显示不出来
<img src="/images/xterm-14.png" alt="xterm" align="middle" />
<!--more-->
一样的问题出现在vim中,使用vim打开.Xresource文件,显示的部分同样没有下划线:  

<img src="/images/xterm-vim-14.png" alt="xterm" align="middle" />
<pre class="prettyprint">
xterm*faceName:DejaVu Sans Mono:pixelsize=14
xterm*boldFont:Sans:style=book:pixelsize=13
xterm*faceNameDoublesize:WenQuanYi Zen Hei:antialias=True:pixelsize=13
</pre>

修改.Xresource文件中字体14修改成13或者12后,这个问题得到修正  
<pre class="prettyprint">
xterm*faceName:DejaVu Sans Mono:pixelsize=13
xterm*boldFont:Sans:style=book:pixelsize=13
xterm*faceNameDoublesize:WenQuanYi Zen Hei:antialias=True:pixelsize=13
</pre>
<img src="/images/xterm-12.png" alt="xterm" align="middle" />

在xterm中使用vim查看Xresource文件,可以看到下划线   
<img src="/images/xterm-vim-12.png"  alt="xterm" align="middle" />

