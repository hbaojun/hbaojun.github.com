---
layout: post
title: XTerm的简单配置
description: 简单记录了XTerm的一些基本简单配置
date: '2014-06-25 12:00:00'
categories: ['Linux']
tags: [XTerm, Linux, GNU]
---


这次在重装了系统之后，着重尝试了一下XTerm终端，经过一番的配置感觉很不错，功能和外观同桌面系统自带的terminal几乎一样，至少现在本人还没有看到较大的差别。  
<!--more--> 
优点：Xterm与MATE-terminal相比，体积较小，使用配置文件配置(~/.Xresources),非常灵活;  
缺点：Xterm开始时，外观非常丑陋，看起来非常不舒服，这个也是我最初没有使用它的原因;另一个就是它上手没有MATE-terminal快，后者简单配置非常直观，很适合初学者，而且最初的外观还不错，不用配置使用也是可以的。  
其他的话就不说了，下面贴出自己的XTerm配置，主要都是来自网上，然后做了少许修改，个人感觉很满意。  
<pre class="prettyprint" >
xterm.termName: xterm-256color 
xterm*VT100.geometry: 90x50
xterm*scrollBar: false 
xterm*rightScrollBar: true 
xterm*loginshell: true 
xterm*cursorBlink: true 
xterm*background: black 
xterm*foreground: gray 
xterm.borderLess: true 
xterm.cursorBlink: true 
xterm*colorUL: yellow 
xterm*colorBD: white  
!font and locale
xterm*locale: true
xterm.utf8: true 
xterm*utf8Title: true 
xterm*fontMenu*fontdefault*Label: Default 
xterm*faceName:DejaVu Sans Mono:antialias=True:pixelsize=14 
xterm*boldFont:Sans:style=book:pixelsize=13 
xterm*faceNameDoublesize:WenQuanYi Zen Hei:antialias=True:pixelsize=13
xterm*xftAntialias: true
xterm.cjkWidth:true 
xterm*preeditType: Root   
!mouse selecting to copy, ctrl-v to paste
!Ctrl p to print screen content to file
xterm*VT100.Translations: #override 
Alt <KeyPress> v: insert-selection(CLIPBOARD,PRIMARY,CUT_BUFFER0) \n
<BtnUp>: select-end(CLIPBOARD,PRIMARY,CUT_BUFFER0) \n
Ctrl <KeyPress> p: print() \n
</pre>
