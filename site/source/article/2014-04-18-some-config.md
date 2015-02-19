---
layout: post
title: Linux的小技巧
description: 简单记录了Linux的配置
date: '2014-04-18 12:00:00'
categories: ['Linux']
tags: [配置, Linux, GNU]
---

**cd**命令在最近两个目录之间切换  
<pre class="prettyprint">
[huang@arch hbaojun]$ pwd
/home/huang/work/hbaojun  
[huang@arch hbaojun]$ cd - 
/home/huang  
[huang@arch ~]$ cd -
/home/huang/work/hbaojun
</pre>
<!--more-->
利用alias来设置别名，替换长输入的命令,在~/.bashrc中设置：
<pre class="prettyprint">
alias cd1='cd ..'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
</pre>
以后系统中直接用cd1来替换cd ..命令。
今天还看了一下Archlinux中[CoreUtilities](https://wiki.archlinux.org/index.php/Core_utilities)中的有关内容，其中有关语法高亮是非常有用，只是其中的内容只有长时间使用的话才记得，偶尔看一下，预防自己轻易的忘记吧。

