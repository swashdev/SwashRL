---
layout: default
title: SwashRL Devblog
permalink: /blog/
---

{% for post in site.posts %}
  <hr />
  <time>{{ post.date | date: "%b %-d, %Y" }}</time>
  <h2><a href="{{ post.url | prepend: site.baseurl }}">{% if post.title %}{{ post.title }}{% else %}Post for <time>{{ post.date | date: "%Y-%M-%d"}}</time>{% endif %}</a></h2>
  {% if post.description %}
    <p>
      <small>{{ post.description }}</small>
    </p>
  {% endif %}
{% endfor %}
