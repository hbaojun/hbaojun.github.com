---
layout: post
title: Mplayer的简单配置
description: 简单记录了Mplayer的一些基本简单配置
date: '2014-07-08 12:00:00'
categories: ['Linux']
tags: [Mplayer, Linux, GNU]
---

今天无意之中用mplayer看了电脑中的一个MV，但是发现在i3-wm之下，画面很卡顿，非常不流畅。而且声音也是跟画面一样出现异常的情况，感觉这个情况很诡异。抱着不把问题解决是不罢休的精神，开始了折腾之旅。 
<!--more-->
首先是怀疑mplayer的配置有问题，于是开始小修了一下～/.mplayer/config文件，但是问题还是没有解决。 
 
于是把目光投到是不是本电脑的显卡驱动没有装好？很有可能。于是上网查ATI Radeon的驱动。而且我这个本子是古董级产品了--ThinkPad T42,硬件已经很老了，到现在还被使用的很少了吧？上网查了一下，修改了/etc/X11/xorg.conf.d/20-radeon.conf文件，中途还出现一些错误，但最终问题还是没有解决。
 
幸好本机装了smplayer程序。我用它播放该视频的时候，中途没有出现任何卡顿的现象。于是就想办法能不能查看smplayer的配置文件。从网上搜了很长时间没有找到，(尼吗，google被墙，难道靠baidu还想搜出来??)   

找了好长时间还是没有找到smplayer的配置文件。但确定了smplayer是调用mplayer的。中间的插曲是我使用CLI调用smplayer 
<pre class="prettyprint">
smplayer -vo help
</pre>
结果弹出smplayer播放错误的信息。仔细一看原来smplayer使用的vo是x11.赶紧把~/.mplayer/config文件修改一下试试。结果一试就OK了.一个疑惑是我在最开始的时候就把vo修改成x11过，但是当时还卡顿，播放不流畅。算了，把mplayer的配置文件附上，方便以后查阅。

<pre class="prettyprint" >
# video settings 
vo=x11

# horizontal frequency range (k stands for 1000)
monitor-hfreq = 31.5k-50k,70k

# vertical frequency range
monitor-vfreq = 50-90

# dotclock (or pixelclock) range (m stands for 1000000)
monitor-dotclock = 30M-300M

# Enable software scaling (powerful CPU needed) for video output
# drivers that do not support hardware scaling.
zoom=yes

# standard monitor size, with square pixels
monitoraspect=4:3

# audio settings
ao=alsa

# Drop frames to preserve audio/video sync.
framedrop = yes

# Resample the font alphamap.
# 0     plain white fonts
# 0.75  very narrow black outline (default)
# 1     narrow black outline
# 10    bold black outline
ffactor = 0.75

# cache settings
# Use 8MB input cache by default.
cache = 8192

# Prefill 20% of the cache before starting playback.
cache-min = 20.0

# Prefill 50% of the cache before restarting playback after the cache emptied.
cache-seek-min = 50

# Profiles

[protocol.dvdnav]
vc=ffmpeg12,

mouse-movements=yes

#[vo.vdpau]
vc=ffmpeg12vdpau,ffwmv3vdpau,ffvc1vdpau,ffh264vdpau,ffodivxvdpau,

# Most video filters do not work with vdpau.
vf-clr=yes
</pre>

