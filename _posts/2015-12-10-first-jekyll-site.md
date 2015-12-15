---
layout:     post
title:      "First Jekyll site"
date:       2015-12-10 18:00:00 +0100
date_mod:   2015-12-15 15:08:00 +0100
categories: [jekyll,web,site]
---
**Jekyll is the best tool for creating static sites that I've found so far**. It took me **just few minutes(or seconds) to get site up and running**. Well, I don't count time spent making this post, customizing styles and layout. However, this post isn't going to be long. It will just point to Jekyll's highlights which are currently the most valuable to me.


## Pros of Jekyll

### Markdown support
It gives you the ability to create posts ang pages using Markdown(not only) and YAML, which lets you create clean posts easily:

{% highlight text %}
---
layout:     post
title:      "Post title"
date:       <creation timestamp>
categories: jekyll markdown
---
Introduction text...

## Some header
Lorem impsum...

### Sub-header
Lorem impsum...

...
{% endhighlight %}


### Simplicity
Jekyll is extremely simple. Such simple, that there is almost nothing to talk about. **You just have to try it to really see how simple Jekyll is!**

Site creation process is simple:

 - download Jekyll
 - run one command to initialize site
 - put it on GitHub Pages, or generate static files with one command

Site update process is simple too:

 - add/modify posts/pages you want
 - push it to GitHub, or regenerate static files with one command

You have available a web-server which automatically regenerates a site when something changes. And much more, configuration, customizations,...


### Free Hosting

#### Hosting with GitHub Pages
The great benefit of Jekyll is, that it is supported by GitHub Pages. This gives you ability to run jekyll site for free together with GIT-repository, that makes Jekyll very suitable for programmers.

If you own the domain, then you are able to use GitHub Pages with custom domain.

#### Static resource generation
Jekyll generates static pages which can be then hosted without PHP, Java, or any else preprocessor or application on server except web-server (Apache, Nginx,... ). There are plenty web-hostings which allows you to host static sites for free. So, you can still use it for free, even when GitHub Pages becomes a paid service in future.
