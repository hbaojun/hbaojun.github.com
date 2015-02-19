---
layout: post
title: 'Archlinux中的compiz及LANG的配置'
date: '2012-09-08 13:45:00'
comments: true
categories: ['Linux']
---
1. 在X window环境下,点击CompizConfig,却不能弹出配置compiz的配置界面,以及在终端中输入ccsm,会弹出错误:&nbsp;
<!--more-->
<code>
  (ccsm:10326): Gtk-WARNING **: Locale not supported by C library.  
  Using the fallback 'C' locale.  
  Info: No sexy-python package found, don't worry it's optional.  
  Traceback (most recent call last):  
  File "/usr/bin/ccsm", line 39, in   
  import ccm    
  File "/usr/lib/python2.5/site-packages/ccm/__init__.py", line 1, in   
  from ccm.Conflicts import *  
  File "/usr/lib/python2.5/site-packages/ccm/Conflicts.py", line 26, in   
  from ccm.Constants import *  
  File "/usr/lib/python2.5/site-packages/ccm/Constants.py", line 83, in   
  locale.setlocale(locale.LC_ALL, "")  
  File "/usr/lib/python2.5/locale.py", line 478, in setlocale  
  return _setlocale(category, locale)  
  locale.Error: unsupported locale setting  
</code>
通过https://bbs.archlinux.org/viewtopic.php?id=45398 网页提供的解决方法,用sudo locale-gen运行后,重启后可以运行ccsm程序了.
2. 由于本人有时在CLI下有时又在GUI下,在GUI下喜欢系统配置为中文,毕竟看中文已经看的很熟悉了,哈哈.在CLI下如果定义环境为中文,会出现很多乱码,看起来及其不爽.所以需要在CLI及在GUI下LANG变量定义不同.
原本是在~/.bashrc中定义的,但是这无论是在CLI及GUI中都是一样的.不能满足要求.因为启动x的时候,要之心~/.xinitrc, 所以将LANG 及LANGUAGE定义到~/.xinitrc中.
<code>
export LANG=zh_CN.GB18030  
export LANGUAGE=zh_CN.GB18030:zh_CN.GB2312:zh_CN  
exec ck-launch-session startlxde
</code>  

在Archlinux + LXDE + Compiz环境下,在字符界面保持环境为英文,但是在图新界面环境下保持环境变成了中文.
