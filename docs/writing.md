---
layout: page
title: Writing
permalink: /writing
description: "Essays by Evan Sims on engineering, developer experience, and life."
intro: "What I've learned building authorization systems, SDKs, and developer tools. Shorter essays on work and life follow."
---
{% for group in site.data.topics -%}
{%- assign essays = site.essays | where: "section", group[0] -%}
<section class="sec">
<div class="sec-h">
<h2>{{ group[1].title | escape }}</h2>
<span>{{ essays.size }} essays</span>
</div>
{% include essay-list.html essays=essays %}
</section>
{% if group[0] == "engineering" -%}
<section class="sec">
<div class="sec-h">
<h2>On the InferaDB blog</h2>
<span>{{ site.data.inferadb_articles.size }} articles</span>
</div>
<ol class="toc" role="list">
    {%- for article in site.data.inferadb_articles %}
    <li>
        <a href="{{ article.url }}">
            <span class="t">{{ article.title | replace: "<", "&lt;" | smartify }}</span>
            <span class="m">{{ article.date | date: "%B %Y" }} · inferadb.com <span aria-hidden="true">↗</span></span>
        </a>
    </li>
    {%- endfor %}
</ol>
</section>
{% endif -%}
{% endfor %}
