<#include "/_page.ftl"><@pageLayout><p>This is a sample page.</p>
<p>The <code>front-matter</code> of this page is:</p>
<pre>layout: page
title: Sample Page
comments: true
date: 2013-06-23 11:20
sidebar: false
xyz: "This is a custom text."
</pre><p>Variable output:</p>
<pre>${'$'}{site.url} = ${site.url}
${'$'}{page.layout} = ${page.layout}
${'$'}{page.title} = ${page.title}
${'$'}{page.comments} = ${page.comments?string}
${'$'}{page.date} = ${page.date?datetime}
${'$'}{page.sidebar} = ${page.sidebar?string}
${'$'}{page.xyz} = ${page.xyz}
</pre><p>A java code block here:</p>
<pre class='brush:java'>import org.opoo.press.Plugin;
import org.opoo.press.Site;

public class MyPlugin implements Plugin{
    //Construct MyPlugin
    public void initialize(Site site){
        //
    }
}
</pre></@pageLayout>