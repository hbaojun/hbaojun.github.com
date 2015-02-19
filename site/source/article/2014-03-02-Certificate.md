---
layout: post
title: 数字证书
description: 简单描述数字证书的ASN.1结构
date: 2014-03-02
categories: ['信息安全']
tags: [数字证书, X.509, 信息安全]
---

###1.概念
数字证书是一种由权威公正的第三方机构颁发的用以与用户身份相绑定的电子文档。数字证书与普通证书的区别在于数字证书是一串字节码信息，不包含有任何实物，像我们普通用的身份证、学生证、老年证等。
<!--more-->
###数字证书的应用
实际上，我们在很多时候都会接触到的数字证书。在登录网上银行的时候，需要插入USBKey,在这个USBKey中就保存有个人的数字证书；在支付宝安全保障中，也可以申请数字证书进行账户保护。在电子化办公的环境，只有持有数字证书和与其对应的私钥才能登录系统。
在浏览网页时，网址地址栏有时http会变成https。点击如下图地址栏右侧的“锁”，就可以看到数字证书的一些信息.
![地址栏](/images/certificate/add.png)

Firefox登录支付宝,点击地址栏左边的lock形状，就可以看到如上图的信息。显示该页面在互联网上传输之前经过加密的。
![Firefox浏览器SSL信息](/images/certificate/ssl.png)

###3.数字证书的结构
在国际RFC 2459 标准，X.509数字证书中结构都有详细的描述。描述的方式都是以ASN.1语法为基础。所以，在这之前读者应该提前熟悉了ASN.1语法结构。通常，我们在IE->Internet选项->内容->证书中看到的数字证书都是已经存储到本地计算机上的。
![证书ASN.1结构信息](/images/certificate/x509cert.png)
数字证书整体结构:
<pre class="prettyprint">
Certificate  ::=  SEQUENCE  {
    tbsCertificate       TBSCertificate,
    signatureAlgorithm   AlgorithmIdentifier,
    signatureValue       BIT STRING  }
</pre>
证书的主体信息就是TBSCertificate部分。剩下的两部分是对上面区分的限制，确保在攻击者对证书主体信息进行篡改之后，能够通过后面的两部分迅速的发觉。  
<pre class="prettyprint">
TBSCertificate  ::=  SEQUENCE  {
      version         [0]  EXPLICIT Version DEFAULT v1,
      serialNumber         CertificateSerialNumber,
      signature            AlgorithmIdentifier,
      issuer               Name,
      validity             Validity,
      subject              Name,
      subjectPublicKeyInfo SubjectPublicKeyInfo,
      issuerUniqueID  [1]  IMPLICIT UniqueIdentifier OPTIONAL,
                             -- If present, version shall be v2 or v3
      subjectUniqueID [2]  IMPLICIT UniqueIdentifier OPTIONAL,
                             -- If present, version shall be v2 or v3
      extensions      [3]  EXPLICIT Extensions OPTIONAL
                             -- If present, version shall be v3
}
</pre>
以上就是TBSCertificate以ASN.1语法描述的结构。  
(1) 证书版本号，现在一般使用的都是v3版，在证书中就是2(以0开始计数):  
<pre class="prettyprint">
Version ::= INTEGER { v1(0), v2(1), v3(2) }
</pre>
(2) 证书序列号，每个证书都对应唯一的证书序列号，以整数来计数:  
<pre class="prettyprint">
CertificateSerialNumber  ::=  INTEGER
</pre>
(3) 算法标识符，表明所使用的算法.
<pre class="prettyprint">
AlgorithmIdentifier  ::=  SEQUENCE  {
     algorithm               OBJECT IDENTIFIER,
     parameters              ANY DEFINED BY algorithm OPTIONAL  }
</pre>
(4) 有效期由两个时间点组成，起始时间和终止时间。只有在这两个时间点之间，数字证书才可能有效。  
<pre class="prettyprint">
Validity ::= SEQUENCE {
    notBefore      Time,
    notAfter       Time }
Time ::= CHOICE {
    utcTime        UTCTime,
    generalTime    GeneralizedTime }
</pre>
(5)主体公钥信息，其中可能包括：  
<pre class="prettyprint">
SubjectPublicKeyInfo  ::=  SEQUENCE  {
    algorithm            AlgorithmIdentifier,
    subjectPublicKey     BIT STRING  }
</pre>
(6)证书扩展信息
<pre class="prettyprint">
Extensions  ::=  SEQUENCE SIZE (1..MAX) OF Extension
Extension  ::=  SEQUENCE  {
    extnID      OBJECT IDENTIFIER,
    critical    BOOLEAN DEFAULT FALSE,
    extnValue   OCTET STRING  }
</pre>
证书扩展信息是在V3版本后才加进去的内容。它一般是对证书的用途做进一步的描述或者限制等。下图是某个证书在windows下看到的一些扩展信息项:
![扩展项](/images/certificate/extension.png)

###(4)数字证书生成与解析
a. 数字证书的生成   
数字证书生成所需要的信息一般由PKCS#10中的信息提取出来，主要包括使用者的一些基本信息和公钥。现阶段大多数使用的CA都是基于J2EE架构的。个人试验的话可以尝试搭建EJBCA，但是不能颁发基于SM2的数字证书。如果尝试生成另外算法的数字证书，可以尝试采用Bouncycastle开源库来实现。    
b. 数字证书的解析    
数字证书的解析主要是分为验证数字证书或者提取数字证书中的各项基本信息。若单纯的验证证书的合法性比较简单，不许要每一小项都要精确提取出来，只需要提取其中的主要信息按照算法标识进行验证就可以了。
数字证书的全解析要稍微麻烦一点，不过可以完全借用开源的代码库或者windows中自带的密码库也可以比较轻松的实现。同样，要实现特殊的算法的数字证书需要点额外的处理需要注意，在此不做详述。
