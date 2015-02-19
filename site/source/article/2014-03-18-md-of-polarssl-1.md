---
layout: post
title: PolarSSL之杂凑算法(一)
description: 学习记录PolarSSL源代码文件
date: 2014-03-16
categories: ['信息安全']
tags: [TLS, SSL, 信息安全, 网络安全, 杂凑函数]
---

在上面的一篇博客中，我简单总结介绍了一下杂凑函数的基本知识。从这一篇博客开始，需要对PolarSSL中哈希函数的实现来概要分析。
首先的问题是在PolarSSL库中实现了多少种杂凑函数？从md.h文件中可以看到如下的代码: 
<!--more-->
<pre class="prettyprint">
typedef enum {
    POLARSSL_MD_NONE=0,
    POLARSSL_MD_MD2,
    POLARSSL_MD_MD4,
    POLARSSL_MD_MD5,
    POLARSSL_MD_SHA1,
    POLARSSL_MD_SHA224,
    POLARSSL_MD_SHA256,
    POLARSSL_MD_SHA384,
    POLARSSL_MD_SHA512,
    POLARSSL_MD_RIPEMD160,
} md_type_t;
</pre>
这是一个枚举类型，其中定义的算法类型为10种(其中一种为空).而对于每一种杂凑算法的实现都是大同小异，下文就以SHA1这个例子来说明。

首先看sha1.h头文件:   
<pre class="prettyprint">
typedef struct
{
    uint32_t total[2];          // number of bytes processed
    uint32_t state[5];          // intermediate digest state
    unsigned char buffer[64];    // data block being processed
    unsigned char ipad[64];      // HMAC: inner padding
    unsigned char opad[64];      // HMAC: outer padding
} sha1_context;
</pre>
对每一个杂凑算法，都定义了一个hash_context的上下文结构体。其中主要包含计算的字符串长度，上下文杂凑函数的处理状态，每次处理字符串的缓存及HMAC所用到的内部填充和外部填充。也有某些杂凑算法的结构体中包含另外一个成员变量，例如在sha512_context中，有is384的整型变量。它的作用就是用来决定这个杂凑算法最终返回的哈希值的长度，sha512算法有可能返回384bit，也有可能返回512bit。

下面继续有关sha1的所有实现的函数:   
<pre class="prettyprint">
// 初始化上下文
void sha1_starts( sha1_context *ctx ); 
// 添加要处理的字符串input, 长度为ilen
void sha1_update( sha1_context *ctx, const unsigned char *input, size_t ilen ); 
// 计算得到最终的哈希值output, 长度为20字节
void sha1_finish( sha1_context *ctx, unsigned char output[20] ); 
// sha1内部处理一个单元的过程
void sha1_process( sha1_context *ctx, const unsigned char data[64] );
</pre>
上述的几个函数主要是对sha1算法细化实现，达到高的复用的目的。下面的2个函数直接调用上面的几个函数，直接对外提供计算摘要值的API，方便调用，屏蔽了算法实现的诸多复杂调用。     
<pre class="prettyprint">
// 调用上面的函数，直接计算input字符串的摘要值
void sha1( const unsigned char *input, size_t ilen, unsigned char output[20] ); 
// 对输入path路径的文件计算摘要值
int sha1_file( const char *path, unsigned char output[20] );
</pre>     
下面的5个函数主要用来计算HMAC.计算HMAC时，不仅需要字符串的输入，而且还需要额外的秘钥。秘钥的长度一般不短于该摘要算法哈希值的长度，在这个例子中即key的长度不短于20个字节。若key的长度大于杂凑函数每次处理的单元，可以先将key计算其哈希值，然后来计算HMAC。具体的标准实现可以参看[RFC2104--HMAC](http://www.cse.ohio-state.edu/cgi-bin/rfc/rfc2104.html)文档.    
<pre class="prettyprint">
// 输入key，初始化HMAC上下文
void sha1_hmac_starts( sha1_context *ctx, const unsigned char *key, size_t keylen ); 
// 输入待计算字符串及长度，更新上下文状态
void sha1_hmac_update( sha1_context *ctx, const unsigned char *input, size_t ilen );
// 从上下文中的信息，最终计算返回HMAC值
void sha1_hmac_finish( sha1_context *ctx, unsigned char output[20] ); 
// 将上下文信息复位
void sha1_hmac_reset( sha1_context *ctx ); 
// 调用上述的几个函数，直接输入key和字符串，直接返回其HMAC值
void sha1_hmac( const unsigned char *key, size_t keylen,
                 const unsigned char *input, size_t ilen, 
                 unsigned char output[20] );
</pre>    
最后有一个函数，是对上述函数的一些测试，保证代码的正确，这个就赘述了。   
<pre class="prettyprint">
int sha1_self_test( int verbose );
</pre>

