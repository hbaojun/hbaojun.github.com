---
layout: post
title: 'archlinux修改小配置'
date: '2012-09-10 13:57:00'
comments: true
categories: ['Linux']
---

1. 在中文环境下windows盘中文件乱码.
在上篇博客中我写到,在~/.xinitrc 文件开始添加:
<code>LANG=zh_CN.GB18030</code>
<!--more-->
但是这这种情况下,'mount  - t ntfs  /dev/sda*'之后,显示windows盘中中文文件为乱码,所以修了这种LANG的定义：
<code>LANG=zh_CN.UTF-8
LANGUAGE=zh_CN.UTF-8:zh_CN.GBK18030:GBK
</code>   
然后在LANGUAGE中添加zh_CN.UTF-8到前面,然后后面添加一个冒号.修改之后注销重新启动X window,重新mount之后,就可以显示windows xp下的中文了.

2. 在启动 X window后,在 Ctrl + Alt +F1,返回到字符界面,可以看到:
<code>
end_request: I/O error, dev fd0, sector 0     
Buffer I/O error on device fd0, logical block 0
</code>
在命令行下查看是否加载了floopy模块:
<code>sudo lsmod | grep -i floppy </code>
如果返回的是:  
<code>floppy 64346 0</code>
大家可以参考这边<a href="http://www.liurongxing.com/end_request-io-error-on-device-fd0sector-0-buffer-io-error-on-device-fd0logical-block-0.html">博客</a>的内容,我使用的主要是在修改/boot/grub/grub.cfg文件.
<code>linux /boot/vmlinuz-linux modprobe.blacklist=floppy root=UUID=db4ad3d6-c2f8-4010-b5ea-2ea5907db5bb ro quiet
</code>
重启之后就没有这种报错了.
