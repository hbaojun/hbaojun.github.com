---
layout: post
title: Samba配置文件
description: 学习配置Samba的一些基本配置技巧
date: '2014-08-07 12:00:00'
categories: ['Linux']
tags: [Linux, Samba, 配置]
---

前面的内容简单介绍了Samba简单的应用，适合从来没有接触过Samba(跟我一样)配置的同学。这篇博文就对Samba配置文件做一个简单的总结。
<!--more-->
其实,Samba服务器的配置是非常复杂的，因为要满足多种不同的需求，但通常所使用的配置还是比较简单的。刚安装完Samba服务器，打开/etc/samba/smb.conf文件可以看到大概如下的配置文件
<img src="/images/samba_config_file.png" alt="Samba配置文件" align="middle" />  
**global配置**  
<pre class="prettyprint">
 [global]
	##工作组或者域
	workgroup = C213   
	##主机名，在网络邻居中查看到的主机名称
	netbios name = server  
	##Samba服务器的注释，可以添加"%v"来显示Samba服务器的版本号
	server string = Samba server   
	##现在常用的两种安全级别,share已经被丢弃，如果直接将security注释，可以匿名访问
	security = user/server   
	##使用server选项时配置的密码服务器(security=server),使用NetBios名称
	;password server = <NT-Server-Name>   
	##准许访问Samba服务器的网段地址等，也可以设置为具体IP地址的主机或者某个网域的主机访问
	hosts allow = 192.168.1 192.  
	##有关共享打印的配置，一般用不上，注销后不能添加远程打印机
	printcap name = /etc/printcap
	load printers = yes  
	##日志文件,将日志文件分散成多个，方便查看日志，维护系统，其中‘%m'表示主机，
	##某一个主机访问Samba服务其，就生成其主机名为名称,log为后缀的日志文件，可以对该选项进行修改，
	##例如使用'%I'替换'%m',就是使用IP地址为名称
	log file = /var/log/samba/%m.log
	max log size = 50 ##日志文件最大不能超过50(Kb)  
	##登录密码是否加密及Samba用户密码文件位置，默认已经开启
	encrypt passwords = yes
	smb passwd file = /etc/samba/smbpasswd  
	##包含额外的Samba配置文件位置，可以利用'%I'选项或者’%m'选项来针对不同登录身份的用户设置不同权限
	##例如，‘%m’是针对不用的登录主机名，'%I'是针对不同的登录IP地址来区分，加载不同的配置文档
	include=/etc/samba/smb.conf.%I  
	##指定提供Samba服务的网段，一般适用于多块网卡的服务器
	interfaces = 192.168.4.53/24  
	##主机名解析顺序，wins服务器解析，客户机IP地址和主机名都保存在wins服务器上
	##lmhosts是本地文件，IP与主机名对应关系，bcast是广播局域网所有的主机,3个选项依序执行
	name resolve order = wins lmhosts bcast  
	##上面一行配置使用了wins，下面wins服务器的配置相应打开
	wins server = w.x.y.z  
	##是否做wins服务器，如果做wins服务器，Samba服务器上要保存本地局域网中客户机的主机名同IP
	##地址的对应关系
	wins support = yes  
	##wins代理配置，默认是no;如果开启，局域网中至少需要一台wins服务器
	;wins proxy = yes  
	##设置Samba服务器是否通过dns服务器来查询NetBios名与IP地址
	dns proxy = no  
	##允许主机访问的地址或者主机名等
	hosts.allow = 192.168. EXCEPT 192.168.4.2  
	##禁止访问Samba服务器的IP地址或主机名等
	hosts.deny = 192.168.3  
	##Windows中是否保持大小写的状态，这些是分享的基础,默认设置为no
	;preserve case = no
	;short preserve case = no  
	##默认字母小写和字母大小写敏感设置
	default case = lower
	case sensitive = no  
</pre>
全局经常用到的选项上面基本上都涉及到了，生产为了满足实际的需求就需要灵活运用上述的全局配置和下面的文件共享配置部分，并且要时刻注意系统用户权限的设定。
**分享目录设置**
目录分享设置可以简单的分为用户home目录分享和用户设定目录分享。
下面的描述块主要描述了用户home目录的分享设置
<pre class="prettyprint">
[homes]
   comment = Home Directories ##注释信息
   ##共享是否可见,设置为no只会出现一个用户名的文件，如果为yes，则还会出现一个homes的文件夹
   browseable = no
   ##不可写
   writable = no
</pre>
在上面的字段中没有指定用户Home目录的路径信息，具体的可以看上面配置的相应注释。
下面接着描述用户自定义的文件共享设置。
<pre class="prettyprint">
 [doc_name] ##设定共享目录名称
	path = /**           ##共享目录对应的路径
	valid users = A B @C ## 合法访问Samba服务器的用户名和用户组C
	public = yes|no      ##是否公开访问
	read only = yes|no   ##是否只读
	writable = yes|no    ##文件夹是否可写
    read list =    ##读权限的用户列表
	write list =   ##具有写权限的用户列表
	hosts deny =   ##局部拒绝访问配置
	hosts allow =  ##局部拒绝访问配置
    create mode = 0770    ##指定创建文件的权限
    directory mode = 0770 ##制定创建文件夹的权限
</pre>

**共享打印服务**  
共享打印服务其实比较少使用，这里略过描述。


**安全访问控制**
下面简单给出使用hosts来控制安全访问基本技巧，详细叙述如下：  
<pre class="prettyprint">
 [global] ##全局访问控制
	hosts allow = ALL
	hosts deny = 192.168.4.
## 如果只看global两行配置，虽然有deny，但是deny的网段依然在allow中，
## 所以所有的网段都可以访问Samba服务器  
[doc name1] ##局部访问控制
	hosts allow = 192.168.4.53
	hosts deny = 192.168.4. 
## 结合global和局部配置，同样都可以访问到Samba服务器。如果没有global中的host allow和deny配置，
## 只根据局部配置,192.168.4.53的IP用户才能访问Samba服务器   
[doc name2] ##局部访问控制 
	hosts allow = 192.168.4. 
	hosts deny = 192.168.4.5 
## 上面局部hosts设定效果是失效的
</pre>
上面的设定可以根据“允许优先”这个规则，只要包含在hosts allow中的，就可以访问共享目录。
其中，hosts设定可以使用如下的内容:  
1. 使用IP地址或者IP地址字段(192.168.4.5 192.168.4.)  
2. 使用域名或主机名来限制，例如.arch.com arch 是匹配域名地址*.arch.com和arch主机  
3. 使用统配符来设置，例如ALL, LOCAL, *, ?等  

对Samba服务器的所有介绍告一段落，这几天是边学习边摸索着进行，中间或许有纰漏的地方或者不尽如人意的地方，希望以后在实际应用中继续完善。  
