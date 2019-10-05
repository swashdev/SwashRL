---
layout: default
---

<time>{{ page.date | date: "%b %-d, %Y" }}</time> | {{page.author | default: Philip Pavlick}}{% if page.meta %} | {{page.meta}}{% endif %}

<hr />

{{ content }}
