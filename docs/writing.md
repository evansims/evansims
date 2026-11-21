---
layout: page
title: Writing
permalink: /writing
description: "Essays by Evan Sims on engineering, developer experience, and life."
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
{% endfor %}
