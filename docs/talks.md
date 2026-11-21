---
layout: page
title: Talks
permalink: /talks
intro: "Talks, demos, and community meetings on authorization and developer experience."
---
<section class="sec">
<ul class="talks" role="list">
{%- for talk in site.data.talks %}
<li>
<a href="https://www.youtube.com/watch?v={{ talk.id }}">
<span class="t">{{ talk.title | escape }}</span>
<span class="m">{{ talk.host | escape }} · Watch on YouTube <span aria-hidden="true">↗</span></span>
</a>
</li>
{%- endfor %}
</ul>
</section>
