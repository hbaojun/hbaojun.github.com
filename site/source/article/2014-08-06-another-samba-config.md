---
layout: post
title: Samba配置续
description: 学习配置Samba的一些基本配置技巧
date: '2014-08-06 12:00:00'
categories: ['Linux']
tags: [Linux, Samba, 共享]
---

续上篇博文，接下来继续介绍Samba一些比较常用的配置选项. 
<!--more-->
**增加匿名共享目录**  
根据实际应用环境的需求，当需要增加一个新的共享的目录给工作组中所有用户时，可以给出一下配置部分：
<pre class="prettyprint">
;security = share  ##安全等级share已经在版本4.1.11中不推荐使用
[download]
    comment = share download files ##共享说明
    path = /home/huang/Downloads   ##共享文件目录路径
    public = yes ##对外公开，匿名用户可以访问
</pre>
按照上述对download的配置配置，访问用户不需要输入用户名和密码即可登录到Samba服务器中,并且可以访问download文件夹。下面是在树莓Pi中匿名用户登录的结果，其中不需要输入密码，直接ENTER键即可;
<pre class="prettyprint">
pi@raspberrypi ~ $ smbclient -L //192.168.4.53/share
Enter pi's password:
Anonymous login successful ##匿名用户登录成功
Domain=[C213] OS=[Unix] Server=[Samba 4.1.11]
        Sharename       Type      Comment
        ---------       ----      -------
        IPC$            IPC       IPC Service (Samba Server)
        download        Disk      share download files
</pre>
**增加受限用户访问目录** 
不同与上面的共享目录，下面新建另一个首先用户访问目录，只有Samba服务器中的arch才能访问到Arch目录，相关的配置如下:
<pre class="prettyprint">
 [Arch]
    comment = arch doc	##说明可有可无
    path = /home/huang/F  ##共享文件目录
    public = no           ##匿名用户不能访问
    valid users = arch	##只有arch用户才能访问，系统首先要添加arch用户，并且添加到Samba中
</pre>
根据上面的访问配置文件，用户登录Samba服务器所使用的用户名，同时也是服务器系统中真实的用户名。所以，在用户在客户机中登录Samba服务器时，是需要知道系统服务器中真实用户名的，但其登录Samba服务器所使用的密码是另外独立设定的，强烈建议跟系统中的密码不一致.虽然两个登录密码保持不一致，但Samba用户知道服务器系统真实账号，仍然容易遭受到口令猜测攻击。下面将介绍用户映射来提升系统安全级别。  

**用户映射**  
在安全要求级别比较高德情况下，为防止攻击者利用Samba用户名猜测出相应系统用户对应的密码，Samba服务器允许设置系统账户同Samba用户的映射。分配给普通Samba用户的都是虚拟账户，其用户名在系统服务器中并不存在。Samba用户使用虚拟账户成功登录之后，该虚拟用户根据Samba配置文件中的配置映射成相应的系统账户，并在分享目录中享有该系统账户对应的权限。
在这种情况下，普通Samba用户知道的仅仅是Samba服务器中虚拟的用户名，跟系统真实的用户名无任何相关的语义关系，防止了攻击者利用Samba用户对服务器系统的攻击，大大提升了系统的安全级别。相应的具体配置如下：
<pre class="prettyprint">
 [global]
	  username map=/etc/samba/smbusers     ##用户映射文件
</pre>
创建并且编辑/etc/samba/smbusers文件，在该文件中添加系统用户与虚拟用户映射关系： 
<pre class="prettyprint">
 arch = user1 user2     ##arch系统用户,user1和user2虚拟用户
</pre>
然后Samba用户使用虚拟用户登录系统即可。下图是在用虚拟用户登录成功的截图。
<img src="/assets/image/vitual_user_map_login.png" alt="虚拟用户登录Samba服务器" align="middle" />
可以看到arch对应的是Home Directories，可见user1登录到Samba服务器对应的用户身份是arch用户。、

**WIN7登录Samba问题**  
在使用Win7来登录Samba服务器中，我总是遇到“网络错误”的对话框，显示“Windows无法访问\\192.168.4.53"错误。通过在网上搜索，找到某个 朋友给出的[解决办法](http://www.yesure.net/archives/6877.html).经测试，方法一在本机上有效。  
<img src="/assets/image/huang_login_in_arch_erroe.png" alt="win7登录Samba出错" align="middle" />  
问题的原因在于从Vista系统开始，微软默认只采用NTLM v2协议的认证回应消息了，而目前的NAS系统和Samba还只支持LM或者NTLM。 

解决办法：    
1.在“搜索程序和文件”框中输入”secpol.msc“，打开”本地安全策略“。在”安全设置“树形目录下的”本地策略“下点击”安全选项“，在右侧对话框中查找“网络安全：LAN管理器身份验证级别”项，选择“发送LM和NTLM-如果已协商，则使用NTLMv2会话安全”选项，确定重启。
<img src="/assets/image/win7_set_ntlm.png" alt="win7配置安全策略" align="middle" /> 

2.修改 HKEY\_LOCAL\_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa下的LmCompatibilityLevel的值为1。(注：这项注册表在我的系统中没有找到)  

最后，在控制面板->程序卸载中查找安全更新KB2536276,然后卸载KB2536276,完成重启系统即可。
我自己系统按照修改本地安全策略，然后删除KB2536276安全更新包重启后，解决了上述问题。

**权限设定**  
分享目录权限设定是一个非常重要的问题，直接关系到整个系统文件分享成功与否和分享的安全。只有严格控制分享权限和范围，才能在保证Samba服务正常工作的前提下，所分享的目录不会被不应该查看或者修改的用户查看或者被恶意篡改。下面给几个简单的示例：  
<pre class="prettyprint">
[download]
   comment = share download files
   path = /home/huang/Downloads
   public = yes
[test]
  comment = arch doc
  path = /home/huang/EF 
  public = no 
  valid users = arch 
</pre>
设置共享的download目录和test目录在系统中所对应的路径都在/home/huang中，并且/home/huang权限为766。Samba用户使用arch用户登录Samba服务器,在WIN7中访问Samba服务器共享的download目录和test目录时，就会出现如下错误信息：
<img src="/images/own_right_error.png" alt="download目录错误信息" align="middle" />  
<img src="/images/own_right_error2.png" alt="test目录错误信息" align="middle" />  
只有在服务器系统中对/home/huang目录给其他用户赋予执行的权限，Samba用户在WIN7中才能进入和查看download和test目录。但是不能在这两个共享文件夹创建新文件，即没有写权限。

下面分别对[download]和[test]目录中添加“writable = yes”配置项，重启服务器后，再查看相关目录的权限:
<pre class="prettyprint">
[huang@arch home]$ ls -l 
drwxrw-rwx 35 huang huang 4096 8月 /home/huang 
进入/home/huang中
[huang@arch ~]$ ls -l 
drwxrwxrwx 3 huang huang 4096 8月 Downloads
drwxr-xr-x 35 huang huang 4096 8月 EF 
</pre>
arch用户在WIN7系统下登录Samba服务器，在download目录下可以创建新文件，但是在test目录下仍然不能创建文件，提示“目标文件夹访问被拒绝”。
Samba用户在共享目录能够创建新文件需要同时满足两个条件：  
1.在共享目录配置部分([download]和[test])设定可写(writable = yes);  
2.Samba的用户所对应的服务器系统账户对该目录拥有可写权限.  
只有同时满足上述两个条件，才能在WIN7中成功登录Samba服务器后在共享目录可写。默认创建新文件的拥有者是arch,所属组为arch组。
另外，根据测试，将/home/huang目录中其他用户w权限去掉，不影响Samba用户在download目录中删除和创建新文件。因此，简单的结论就是上层目录(父目录)对最终目录在读和写权限上没有影响，但是执行权限必须拥有，不然Samba用户是不能访问该目录的。当然，系统中的arch用户需要对目录自身拥有读的权限，不然是查看不到文件夹具体内容的。
