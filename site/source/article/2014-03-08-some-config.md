---
layout: post
title: Linux的一些配置
description: 简单记录了Linux的配置
date: 2014-03-08
categories: ['Linux']
tags: [配置, Linux, GNU]
---

今天突然想把Windows下的分区挂在到桌面上，以后查看文件非常方便，就把分区挂在消息写到了“/etc/fstab”里了。
<!--more-->
<pre class="prettyprint">
#C
UUID=F63013A730136DBD    /home/huang/Desktop/Disk/C  ntfs-3g  defaults 0 0 
#D
UUID=BAE67752E6770DBF    /home/huang/Desktop/Disk/D  ntfs-3g  defaults 0 0
#E
UUID=F43085CC308595F0    /home/huang/Desktop/Disk/E  ntfs-3g  defaults 0 0
#F
UUID=CA10A5AB10A59F47    /home/huang/Desktop/Disk/F  ntfs-3g  defaults 0 0
</pre>
直接挂在到Desktop文件夹下，在启动桌面之后，会在桌面上显示4个盘符，直接对应了4个分区，打开很方便。但是有一个毛病就是在桌面上会出现Disk这个文件嘉，这是一个小问题。

记录一个linux命令。当访问一个目录时，里面文件项超级多，已经刷屏了还无法显示。这个时候想统计一下目录到底有多少项时，google一下找到相关的命令：  
<pre class="prettyprint">
find ./ -name "*.*" | wc -l

上面的等同于

find ./ | wc -l
</pre>
