---
layout: post
title: PolarSSL之SSL Cache实现
description: 简单介绍PolarSSL中cache的实现
date: '2014-03-19 12:00:00'
categories: ['信息安全']
tags: [TLS, SSL, 信息安全, 网络安全]
---

###SSL Session
在SSL协议中，每次Client向Server发送认证请求，Server端都会产生一个SSL回话session.在这个session中包含这个将回话的主要信息，用来匹配该连接。下面的代码是PolarSSL中定义的ssl会话结构:  
<!--more-->
<pre class="prettyprint">
struct _ssl_session
{
#if defined(POLARSSL_HAVE_TIME)
    time_t start;              // starting time
#endif
    int ciphersuite;            // chosen ciphersuite
    int compression;            // chosen compression
    size_t length;             // session id length
    unsigned char id[32];       // session identifier
    unsigned char master[48];   // the master secret
#if defined(POLARSSL_X509_CRT_PARSE_C)
     x509_crt *peer_cert;        // peer X.509 cert chain 
#endif // POLARSSL_X509_CRT_PARSE_C 
    int verify_result;          //  verification result
#if defined(POLARSSL_SSL_SESSION_TICKETS)
    unsigned char *ticket;        // RFC 5077 session ticket
    size_t ticket_len;          // session ticket length
    uint32_t ticket_lifetime;   // ticket lifetime hint
#endif // POLARSSL_SSL_SESSION_TICKETS
#if defined(POLARSSL_SSL_MAX_FRAGMENT_LENGTH)
    unsigned char mfl_code;     // MaxFragmentLength negotiated by peer
#endif // POLARSSL_SSL_MAX_FRAGMENT_LENGTH
#if defined(POLARSSL_SSL_TRUNCATED_HMAC)
    int trunc_hmac;             // flag for truncated hmac activation
#endif // POLARSSL_SSL_TRUNCATED_HMAC
};
typedef struct _ssl_session ssl_session;
</pre>  
上面代码包含ssl_session结构体中的组成，其中有一些成员是由宏定义控制的，这个需要在config.h文件中通过是否定义该宏来控制这个结构体中是否包含该成员。但是ciphersuite,	compression, id, master这几项是必须包含的。    

###SSL Cache###
每次SSL协议的握手连接都是比较耗费资源的，出于性能的考虑，在Server端利用缓存技术，将曾经的一些SSL连接参数都放到系统SSL缓存中，待客户端在有效期内再次发起SSL连接请求的时候，Server端在缓存中查找曾经的连接参数，并且加以复用，合理省略了SSL协议中的一些步骤.   
下面的代码是每个SSL缓存中每个连接对应的缓存个体:
<pre class="prettyprint">
struct _ssl_cache_entry
{
#if defined(POLARSSL_HAVE_TIME)
    time_t timestamp;           // entry timestamp
#endif
    ssl_session session;        // entry session
#if defined(POLARSSL_X509_CRT_PARSE_C)
    x509_buf peer_cert;         // entry peer_cert
#endif
    ssl_cache_entry *next;      // chain pointer 
};
typedef struct _ssl_cache_entry ssl_cache_entry;
</pre>

下面的代码就是缓存上下文，对应SSL连接中所保留cache中的所有信息:   
<pre class="prettyprint">
struct _ssl_cache_context
{
    ssl_cache_entry *chain;     // start of the chain  
    int timeout;                  // cache entry timeout
    int max_entries;             // maximum entries  
#if defined(POLARSSL_THREADING_C)
    threading_mutex_t mutex;    // mutex, 线程安全            
#endif
};
</pre>  
后面来简单理顺一下其函数的执行逻辑:
在**ssl_cache_init**函数中  
<pre class="prettyprint">
// 初始化定义失效时间
cache->timeout = SSL_CACHE_DEFAULT_TIMEOUT; 
// 缓存中存储的最大规模
cache->max_entries = SSL_CACHE_DEFAULT_MAX_ENTRIES; 
// 选择是否是线程安全
#if defined(POLARSSL_THREADING_C)
    polarssl_mutex_init( &cache->mutex );
#endif
</pre>  
在**ssl_cache_get**函数中:   
<pre class="prettyprint">
// 超过有效期
#if defined(POLARSSL_HAVE_TIME)
    if( cache->timeout != 0 &&
        (int) ( t - entry->timestamp ) > cache->timeout )
        continue;
#endif
// 密码套件及压缩和sessionID的长度都要相符
    if( session->ciphersuite != entry->session.ciphersuite ||
        session->compression != entry->session.compression ||
        session->length != entry->session.length )
        continue;
// sessionID相同
    if( memcmp( session->id, entry->session.id,
        entry->session.length ) != 0 )
        continue;
//  然后从cache中恢复信息
	memcpy( session->master, entry->session.master, 48 ); 
    session->verify_result = entry->session.verify_result; 
//  如果定义了证书解析功能，也需要恢复证书
	x509_crt_init( session->peer_cert );
    if( x509_crt_parse( session->peer_cert, entry->peer_cert.p,
                        entry->peer_cert.len ) != 0 )
</pre>  
在**ssl_cache_set**函数中:  
<pre class="prettyprint">
// 过期的
if( cache->timeout != 0 && (int) ( t - cur->timestamp ) > cache->timeout ) 
// 已经缓存过的
if( memcmp( session->id, cur->session.id, cur->session.length ) == 0 )
// 最旧的
if( oldest == 0 || cur->timestamp < oldest )
{
    oldest = cur->timestamp;
    old = cur;
}
</pre> 
找到这3种的来覆盖当前cache中的缓存。
<pre class="prettyprint">
// 到chain末尾，但是最旧的entry不再最末尾，覆盖它
cur = old;
memset( &cur->session, 0, sizeof(ssl_session) );
// 到chain末尾，其他情况的就覆盖第一个，移动到最后
cur = cache->chain;
cache->chain = cur->next;
memset( cur, 0, sizeof(ssl_cache_entry) );
prv->next = cur;
</pre>























