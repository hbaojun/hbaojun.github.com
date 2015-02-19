---
layout: post
title: 'Archlinux上U盘及hostname修改'
date: '2012-10-15 18:57:00'
comments: true
categories: ['Linux']
---

我自身的电脑是thinkpad T42比较古老的型号了，当然配置也是比较低的，只能说满足自己日常的办公需要，看文档，写小程序或者看看普通的电影。要看什么高清就难为它了，已经辛辛苦苦工作好多年了，还在发挥自己的余热，不简单！
<!--more-->
1.U盘的识别问题
ThinkPad t42 USB接口只支持USB 1.1,就是说传输速度几乎难以达到1M/s的速度。在windows下还好,可以自动识别挂载，跟使用USB 2.0几乎没有任何差别。问题在archlinux上问题就来了。启动电脑之后，将U盘插入到USB接口，在终端中会不停的显示：

<code>unable to enumerate usb device on port 4</code>

会不停的显示下去，而且用mount挂在 sdb1时是会报错的。看到网上有人提供的解决办法，确实很有效：
首先，进入'/sys/bus/pci/drivers/ehci_hcd/'目录下,可以看到类似与0000:00:xx.x 的一项，本机的是: 0000:00:1d:7.
然后在/etc/rc.local文件中添加一行：

<code>
echo -n "0000:00:xx:x" &gt; /sys/bus/pci/drivers/ehci_hcd/unbind
</code>

其中"0000:00:xx:x"要替换成本机的情况。其中本人电脑的就是：

<code>echo -n "0000:00:1d:7" &gt; /sys/bus/pci/drivers/ehci_hcd/unbind</code>

2.主机名称问题
本来这算是不上什么问题，在以前hostname是在/etc/rc.conf文件中配置的，但是由于archlinux系统的更新，更换了配置的地点。现在在/etc/rc.conf文件中配置：

<code> HOSTNAME=arch  </code>

仍然可以正常使用，但是在系统启动的时候用高亮的字体是在/etc/rc.conf中配置hostname这种方式是不提倡使用，会被淘汰掉，但是现在系统仍然保留支持。（跟Java中的某些类的使用类似）

现在使用/etc/hostname文件中类替换/etc/rc.conf文件中的配置。在我的系统中是没有这个文件的，所以要重新建立。另外用hostname命令来修改主机名称，在系统重启之后仍然是这样，修要重新设置，因此这种配置方式不太好。
并且在文件中输入：

<code>arch</code>就可以了。不需要其他额外的字符，很简单。但是大家仍然要记得在/etc/hosts文件中在localhost 后面添加系统别名 arch.

最后提另外一点内容，就是如果在教育网的同学，开启IPV6,设置hosts文件实现ipv6翻墙。如果要看youtube的话，速度是非常快的，可以媲美优库的速度。而且Gmail服务经常会收到干扰，用这个不会收到影响，非常好。而且现阶段ipv6使用较少，速度非常快，可以推荐一下。附带一下在<a href="http://code.google.com/p/ipv6-hosts/">google code</a>上的一个提供所有常用ipv6 hosts文件列表，无论是在linux还是在windows下都可以使用，很爽，值得推荐！！！ 
