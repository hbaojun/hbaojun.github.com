---
layout: post
title: Shell学习笔记
description: 记录一些Shell入门的知识，计较基础
date: '2014-12-27 12:00:00'
categories: ['Linux']
tags: [Linux, Shell, 入门]
---

##Shell介绍##
Shell是Linux内核的外壳程序，用户通过Shell向Linux内核发送相关指令来完成一系列任务。Shell是一个命令语言解释器，它拥有自己内建的Shell命令集。
<!--more-->
<img src="/images/kernel-shell.png" alt="Linux和Shell结构图" width="200" height="200" align="middle" />  
linux系统中shell的种类，查看/etc/shells文件：
<pre class="prettyprint">
[huang@arch shell]$ cat /etc/shells 
#
# /etc/shells
#
/bin/sh
/bin/bash
# End of file
</pre>
查看bash中内置的命令：
<pre class="prettyprint">
[huang@arch ~]$ help
</pre>
<p>
<img src="/images/inner-command.png" alt="Linux和Shell结构图" width="400" height="300" align="middle" />  
</p>
Bash脚本文件头
<pre class="prettyprint">
#!/bin/bash
</pre>
然后在完成的bash文件后，执行命令
<pre class="prettyprint">
sudo chmod u+x ./***.sh
</pre>
一个简单的输出Hellow World的shell脚本：
<pre class="prettyprint">
#!/bin/bash
# comment
echo "Hello World"
然后在命令行下输入：
[huang@arch shell]$ sudo chmod u+x ./helloworld.sh 
执行shell脚本结果：
[huang@arch shell]$ ./helloworld.sh ## 或者使用source helloworld.sh命令 
Hello World
</pre>
###管道 
管道，简单的来说就是将一个命令输出的结果作为另外一个命令的输入，中间使用管道来连通，在linux中使用“|”。
下面使用管道命令来只显示当前路径下文件夹的命令：  
<pre class="prettyprint">
[huang@arch ~]$ ls -l | grep ^d
drwxr-xr-x  2 huang huang    4096 12月 27 14:40 Desktop
drwxr-xr-x  2 huang huang    4096 12月 13 21:22 Documents
drwx------  2 huang huang    4096 12月 15 20:41 Downloads
drwxr-xr-x 13 huang huang    4096 12月 22 17:08 KuaiPan
drwx------  2 huang huang    4096 12月 22 17:35 Mail
drwxr-xr-x  8 huang huang    4096 12月 24 17:14 work
drwx------  2 huang huang    4096 12月 22 20:13 下载
</pre>

###重定向###
linux默认的输入是键盘、鼠标等;默认输出是显示器。重定向是改变原有的输出或者输入，一般使用">"或者"<"符号来完成。同时，有如下句柄可供使用
<pre class="prettyprint">
STDIN         0   键盘输入
STDOUT        1   标准输出
STDERR        2   标准错误
</pre>
重定向是改变原有的输入或者输出。

<pre class="prettyprint">
">"   输出重定向，将原本的输出重定向到一个文件中  
[huang@arch ~]$ ls > ./test.txt ##将ls命令输出重定向到test.txt文件中，如果没有该文件则创建一个新文件 

利用">"输出重定向符快速创建一个新的空文件：  
[huang@arch ~]$ > ./test2.txt ##作用同touch ./test2.txt相同
如果test2.txt文件存在，则将该文件变为一个空文件
</pre>

利用'>'来简单编辑文件
<pre class="prettyprint">
[huang@arch shell]$ cat > test.txt
huang
bao 
jun
使用Ctrl+D终止文件的输入，然后输出test.txt文件  
[huang@arch shell]$ cat ./test.txt 
huang
bao
jun
</pre>
使用EOF来作为文件输入的终止符，完成文件的简单编辑工作  
<pre class="prettyprint">
[huang@arch shell]$ cat > test3.txt << EOF
> HUANG
> BAO
> JUN
> EOF
然后输出编辑后的文件：  
[huang@arch shell]$ cat ./test3.txt 
HUANG
BAO
JUN
</pre>
把一个文件内容读入，然后输出到另外一个文件里，如果该文件没有则创建新文件

<pre class="prettyprint">
[huang@arch shell]$ cat > test4.txt < test2.txt
[huang@arch shell]$ cat ./test4.txt 
#########################################################################
# File Name: ./helloworld.sh
# Author: hbaojun
# mail: hbaojun.huang@gmail.com
# Created Time: 2014年12月27日 星期六 15时13分05秒
#########################################################################
#!/bin/bash
echo "Hello World"
</pre>



