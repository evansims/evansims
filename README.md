### Howdy! Evan here. 👋

**I'm an SDKs Senior Engineer at [Okta](https://okta.com) Customer Identity Cloud (formerly [Auth0](https://auth0.com)) from the Urbana-Champaign, Illinois area.** I'm in charge of our PHP, Laravel, Symfony and WordPress SDKs, but contribute heavily across all our other language and framework offerings, as well. I'm just really passionate about building great software and helping others do the same.

Previously, I was a Senior Engineer on the immensely consequential open source [Ushahidi](https://ushahidi.com) platform, a popular tool for (among many other uses) crowdsourcing data in emergencies, protecting civil liberties, defending democratic voting processes, and empowering citizen journalism. I'm still incredibly proud of the work done there, and that it continues to live on and provide human-centered tools that help people solve tough, real world situations. My work at Ushahidi is what really solidified the importance of security engineering in my mind; that the protection of personal data you're entrusted with is an incredible responsibility that can truly mean the difference between life and death for people in some dangerous situations. These learnings are what have driven my career toward the security and privacy space ever since, and what I continue to make an absolute priority in all my work.

In what now feels like a previous life, I was a Technical Video Game Designer, and worked on a number of commercial titles for Nintendo, Xbox and PlayStation. I still adore building video games, but now I just dabble in it as a hobbyist. Games are fascinating artistic collaborations of brilliantly creative minds and ingenius engineering, but the industry is cut-throat, and unkind to the people who pour their hearts and souls into their craft. It was too painful to see colleagues I respect and care about underpaid, overworked, and considered all too easily disposable. Everyone deserves to be able to feel respected and valued by their employers, but the game industry still has a long way to go in that regard.

```php
<?php

class Evan extends Sims implements Human
{
    public const PRONOUNS = [ 'he', 'him' ];

    public function workplace(): Workplace
    {
        return Workplace::🫶(
            company: 'Okta',
            team: 'Customer Identity Cloud (Auth0)',
            position: 'Senior Engineer',
            department: 'Developer Experience (SDKs)',
        );
    }

    /**
     * @return string[]
     */
    public function knowledge(): array
    {
        return [
            'php', 'laravel', 'symfony', 'slim', 'wordpress', 'pest', 'phpunit',
            'javascript', 'node', 'nextjs', 'react', 'ember', 'vue', 'svelte',
            'github actions', 'circleci', 'webpack', 'grunt', 'gulp', 'babel',
            'npm', 'packagist', 'rubygems', 'pypi', 'sonatype', 'maven',
            'css', 'tailwind', 'sass', 'styled-components', 'shadow-dom',
            'vercel', 'aws', 'digitalocean'
        ];
    }
}
```

<details>
    <summary>...</summary>
    <br />
    
```php
<?php

class Workplace {
    public function __construct(
        public string $company,
        public string $team,
        public string $position,
        public string $department
    ) {}
    
    public static function 🫶 (... $args) {
        return new static($args);
    }
}
```

</details>

🏳️‍🌈 If you find my contributions useful, please consider making a donation to [Out in Tech](https://outintech.com/).

🤝 If you'd like to connect, you can find my socials [on my site](https://evansims.com/).
