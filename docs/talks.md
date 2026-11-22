---
layout: page
title: Talks
permalink: /talks
intro: "Talks, demos, and community meetings on authorization and developer experience."
---
{%- assign email = site.data.socials | where: "site", "Email" | first -%}
<section class="sec">
<ul class="talks" role="list">
{%- for talk in site.data.talks %}
<li>
<a href="https://www.youtube.com/watch?v={{ talk.id }}">
<span class="t">{{ talk.title | escape }}</span>
{%- if talk.what %}
<span class="d">{{ talk.what | escape | smartify }}</span>
{%- endif %}
<span class="m">{{ talk.host | escape }} · {{ talk.when | escape }} · {{ talk.minutes }} min · YouTube <span aria-hidden="true">↗</span></span>
</a>
</li>
{%- endfor %}
</ul>
<p class="invite">Want me at your event or on your podcast? <a href="{{ email.link }}?subject=Speaking">Email me about speaking <span aria-hidden="true">→</span></a></p>
</section>
