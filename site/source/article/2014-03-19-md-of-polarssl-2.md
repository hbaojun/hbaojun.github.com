---
layout: post
title: PolarSSL之杂凑算法(二)
description: 学习记录PolarSSL源代码文件
date: '2014-03-16 12:00:00'
categories: ['信息安全']
tags: [TLS, SSL, 信息安全, 网络安全, 杂凑函数]
---

在这篇博客中主要来解读在SSL协议中对摘要函数的选择。首先在md.h文件中看到如下的代码:
<!--more-->
<pre class="prettyprint">
typedef struct {
    md_type_t type;
    const char * name;
    int size;
    void (*starts_func)( void *ctx );
    void (*update_func)( void *ctx, const unsigned char *input, size_t ilen );
    void (*finish_func)( void *ctx, unsigned char *output );
    void (*digest_func)( const unsigned char *input, size_t ilen, unsigned char *output );
    int (*file_func)( const char *path, unsigned char *output );
    void (*hmac_starts_func)( void *ctx, const unsigned char *key, size_t keylen );
    void (*hmac_update_func)( void *ctx, const unsigned char *input, size_t ilen );
    void (*hmac_finish_func)( void *ctx, unsigned char *output);
    void (*hmac_reset_func)( void *ctx );
    void (*hmac_func)( const unsigned char *key, size_t keylen, 
					    const unsigned char *input, size_t ilen,
                        unsigned char *output );
    void * (*ctx_alloc_func)( void );
    void (*ctx_free_func)( void *ctx );
    void (*process_func)( void *ctx, const unsigned char *input );
} md_info_t;
</pre>   
这个结构体非常重要，它基本上包含了每种摘要算法所包含的信息及可以调用的函数，这个地方的函数用函数指针来调用。在后续的代码结构中，对每一种摘要算法都要定义这种类型的结构体，下文将要涉及。
接下来是一般的摘要算法上下文消息结构体:   
<pre class="prettyprint">
typedef struct {
    const md_info_t *md_info;
    void *md_ctx;
} md_context_t;
</pre>
下面的函数是根据一些参数来确定md_info_t及一些相关的函数。这些函数实现比较简单，所实现的功能也比较单一。   
<pre class="prettyprint">
// 返回所支持的摘要算法列表
const int *md_list( void );  
// 根据摘要算法的名字来确定md_info_t  
const md_info_t *md_info_from_string( const char *md_name ); 
// 由枚举中的类型来确定md_info_t
const md_info_t *md_info_from_type( md_type_t md_type ); 
// 用md_info_t结构来初始化md_context_t
int md_init_ctx( md_context_t *ctx, const md_info_t *md_info ); 
int md_free_ctx( md_context_t *ctx );
</pre>   

下面的3个函数是由static、inline来限制的。由static的用法知道，这3个函数只在文件里有效，inline为内联函数，在调用次数比较频繁的时候，提高程序运行效率。   
<pre class="prettyprint">
// 返回该摘要算法的哈希值长度(字节长度)
static inline unsigned char md_get_size( const md_info_t *md_info ) 
// 返回该摘要算法的类型，为枚举类型
static inline md_type_t md_get_type( const md_info_t *md_info )  
// 获取该摘要算法的名称
static inline const char *md_get_name( const md_info_t *md_info )
</pre>

下面的函数主要是实现利用md_context_t结构体中函数指针来调用该摘要算法对应的计算函数来完成相应的功能。
<pre class="prettyprint">
int md_starts( md_context_t *ctx ); 
int md_update( md_context_t *ctx, const unsigned char *input, size_t ilen ); 
int md_finish( md_context_t *ctx, unsigned char *output ); 
int md( const md_info_t *md_info, const unsigned char *input,
		size_t ilen,			  unsigned char *output ); 
int md_file( const md_info_t *md_info, const char *path, unsigned char *output );
</pre>  
同上，下面定义的一些函数主要用来完成该摘要算法对应的HMAC计算函数，分别与每种摘要算法所实现的HMAC计算函数想对应。我们在md_context_t结构体中使用函数指针来调用。实现细节可以参看md.c文件.  
<pre class="prettyprint">
int md_hmac_starts( md_context_t *ctx, const unsigned char *key, size_t keylen ); 
int md_hmac_update( md_context_t *ctx, const unsigned char *input, size_t ilen ); 
int md_hmac_finish( md_context_t *ctx, unsigned char *output); 
int md_hmac_reset( md_context_t *ctx ); 
int md_hmac( const md_info_t *md_info, const unsigned char *key,
		     size_t keylen,            const unsigned char *input, 
			 size_t ilen,              unsigned char *output );
</pre>     
要彻底弄清楚是怎么动态决定调用某摘要算法的函数时，需要再往下看。下面文件的代码是从md_wrap.c文件中复制出来的.   
<pre class="prettyprint">
static void md5_starts_wrap( void *ctx )
{
    md5_starts( (md5_context *) ctx ); 
}  
static void md5_update_wrap( void *ctx, const unsigned char *input, size_t ilen )
{
    md5_update( (md5_context *) ctx, input, ilen );
}
////////////      部分代码省略   ////////////
static void md5_hmac_update_wrap( void *ctx, const unsigned char *input, size_t ilen )
{
    md5_hmac_update( (md5_context *) ctx, input, ilen );
}
static void md5_hmac_reset_wrap( void *ctx )
{
    md5_hmac_reset( (md5_context *) ctx );
}
static void * md5_ctx_alloc( void )
{
    return polarssl_malloc( sizeof( md5_context ) );
}
static void md5_process_wrap( void *ctx, const unsigned char *data )
{
    md5_process( (md5_context *) ctx, data );
}
</pre>   
上面代码中所实现的函数都是静态的，而且对每一种摘要算法，都将这些代码再类似的实现了一次，代码都是大同小异。然后定义了如下的一个结构体实例:   
<pre class="prettyprint">
const md_info_t md5_info = {
    POLARSSL_MD_MD5,
    "MD5",
    16,
    md5_starts_wrap,
    md5_update_wrap,
    md5_finish_wrap,
    md5,
    md5_file_wrap,
    md5_hmac_starts_wrap,
    md5_hmac_update_wrap,
    md5_hmac_finish_wrap,
    md5_hmac_reset_wrap,
    md5_hmac,
    md5_ctx_alloc,
    md5_ctx_free,
    md5_process_wrap,
};
</pre>   
很简单，如果传入的结构体指针变量指向了md5_info，通过函数指针就可以调用md5的计算函数来完成md5值的计算过程。
针对其他每一种摘要函数，都按照上面描述的那样都实现一遍。这个很简单，不再赘述。同理我们要在这个库文件中添加其他摘要算法时，比如增加能够支持SM3算法的SSL协议，同样按照上面的代码设计规则很简单就实现。至于在其他地方的应用，还需要做一些其他的修改，后面会涉及到.
