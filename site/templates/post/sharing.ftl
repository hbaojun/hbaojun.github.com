<div class="sharing">
  <#if (site.twitter_tweet_button)!false == true>
  <#assign showTweetButton = true>
  <a href="http://twitter.com/share" class="twitter-share-button" data-url="${ site.url }${ page.url }" data-via="${ site.twitter_user }" data-counturl="${ site.url }${ page.url }" >Tweet</a>
  </#if>
  <#if (site.google_plus_one)!false == true>
  <#assign showGooglePlusOne = true>
  <div class="g-plusone" data-size="${ site.google_plus_one_size }"></div>
  </#if>
  <#if (site.facebook_like)!false == true>
  <#assign showFacebookLike = true>
    <div class="fb-like" data-send="true" data-width="450" data-show-faces="false"></div>
  </#if>
  <#if (site.baidushare)!false == true>
  <#assign baidushare = true>
    <div class="bdsharebuttonbox"><a href="#" class="bds_more" data-cmd="more"></a><a title="分享到QQ空间" href="#" class="bds_qzone" data-cmd="qzone"></a><a title="分享到新浪微博" href="#" class="bds_tsina" data-cmd="tsina"></a><a title="分享到腾讯微博" href="#" class="bds_tqq" data-cmd="tqq"></a><a title="分享到人人网" href="#" class="bds_renren" data-cmd="renren"></a><a title="分享到微信" href="#" class="bds_weixin" data-cmd="weixin"></a></div>
    <script>window._bd_share_config={"common":{"bdSnsKey":{},"bdText":"","bdMini":"2","bdMiniList":false,"bdPic":"","bdStyle":"0","bdSize":"16"},"share":{},"image":{"viewList":["qzone","tsina","tqq","renren","weixin"],"viewText":"分享到：","viewSize":"16"}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];</script>
  </#if>
</div>
