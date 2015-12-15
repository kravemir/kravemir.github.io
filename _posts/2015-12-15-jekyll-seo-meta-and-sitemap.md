---
layout:     post
title:      "Jekyll SEO: BlogPosting and Sitemap"
date:       2015-12-15 16:40:00 +0100
categories: [jekyll,seo]
---
Probably everyone would like to see their own pages appear in Google search. Me too. So, the SEO is the main focus when developing the site. In this post I'm showing you a way to extend properties of Blog Post, and a way to generate sitemap using plain Jekyll.

## BlogPosting
The [schema.org/BlogPosting](http://schema.org/BlogPosting) is a schema definition designed for blog posts and is recognized by google search engine.

I've added information about modification date of post:
{% highlight html %}{% raw %}
<p>
  <time datetime="{{ page.date | date_to_xmlschema }}" itemprop="datePublished">{{ page.date | date: "%b %-d, %Y" }}</time> 
  {% if page.date_mod %}
    (modified <time datetime="{{ page.date_mod | date_to_xmlschema }}" itemprop="dateModified">{{ page.date_mod | date: "%b %-d, %Y" }}</time>)
  {% else %}
    <meta itemprop="dateModified" content="{{ page.date | date_to_xmlschema}}" />
  {% endif %}
  • <span itemprop="author" itemscope itemtype="http://schema.org/Person"><span itemprop="name">{{ site.author_name }}</span></span>
</p>
{% endraw %}{% endhighlight %}

And I have also added keywords property based on post categories:
{% highlight html %}{% raw %}
<p class="post-categories">
  <meta itemprop="keywords" content="{{ page.categories | join: ', '}}" />
  Categories:
  {% comment %} TODO: category pages {% endcomment %}
  {% for category in page.categories %}
  {{category}}{% unless forloop.last %}, {% endunless %}
  {% endfor %}
</p>
{% endraw %}{% endhighlight %}
I haven't implemented index pages for categories yet. So, for now listed categories are just plain text. The plain text is optional, you can use just `<meta />` element.

You can use [Structured Data Testing Tool](https://developers.google.com/structured-data/testing-tool/) to test your implementation of item properties. 

## SiteMap
[SiteMap](http://www.sitemaps.org/protocol.html) helps web-crawlers at indexing of your site. However, this site is hosted on GitHub Pages, which doesn't support custom Jekyll plugins(which could do that for us). That means, we've got to use plain Jekyll to generate sitemap.

The `sitemap.xml` can be created as following:
{% highlight html %}{% raw %}
---
layout: null
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" >

  {% for post in site.posts %}
  <url>
    <loc>{{ site.url }}{{ post.url }}</loc>
    {% if post.date_mod == null %}
    <lastmod>{{ post.date | date_to_xmlschema }}</lastmod>
    {% else %}
    <lastmod>{{ post.date_mod | date_to_xmlschema }}</lastmod>
    {% endif %}
    <changefreq>weekly</changefreq>
    <priority>0.6</priority>
  </url>
  {% endfor %}

  {% for page in site.pages %}
  {% if page.sitemap != null and page.sitemap != empty %}
  <url>
    <loc>{{ site.url }}{{ page.url }}</loc>
    <lastmod>{{ page.sitemap.lastmod | date_to_xmlschema }}</lastmod>
    <changefreq>{{ page.sitemap.changefreq }}</changefreq>
    <priority>{{ page.sitemap.priority }}</priority>
  </url>
  {% endif %}
  {% endfor %}
</urlset>
{% endraw %}{% endhighlight %}

This sitemap is populated with information about posts, where it uses `date_mod` property of the post to fill lastmod element. And, it is also populated with list pages having configured `sitemap` property in front matter. The front matter of a page may look like this:

{% highlight yaml %}
---
layout: page
title: "A page"

sitemap:
  lastmod:      2015-12-15 00:00:00 +0000
  changefreq:   'monthly'
  priority:     0.7
---
{% endhighlight %}
