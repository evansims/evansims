---
title: Writing — Evan Sims
layout: default
---

<article>
    <header>
        <h1>Writing</h1>
        <p class="subtitle">By <a href="/">Evan Sims</a></p>
    </header>

    <p>Here's some of my recent writing:</p>
    
    <nav>
        <ul>
            {% for item in site.data.writing %}
                <li><a href="{{ item.link }}">{{ item.name }}</a></li>
            {% endfor %}
        </ul>
    </nav>
</article>
