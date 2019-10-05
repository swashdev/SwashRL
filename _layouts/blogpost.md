---
layout: default
---

<p>
{% if page.author %}
  by {{ page.author }}
  <br />
{% endif %}
<time>{{ page.date | date: "%b %-d, %Y" }}</time>
{% if page.meta %}
  <br />
  {{ page.meta }}
{% endif %}
</p>

<hr />

{{ content }}
