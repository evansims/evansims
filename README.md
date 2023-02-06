### Howdy! Evan here. 👋

#### I'm a developer at [Okta](https://okta.com) Customer Identity Cloud (formerly [Auth0](https://auth0.com)) from the Champaign-Urbana, Illinois area. I'm passionate about building great software and helping others do the same.

```php
<?php

class Evan extends Sims implements Human
{
    public const pronouns = [ 'he', 'him' ];

    public function getWorkplace(): Workplace
    {
        return Workplace::🫶(
            company: 'Okta',
            team: 'Customer Identity Cloud (Auth0)',
            position: 'Senior Engineer',
            department: 'Developer Experience (SDKs)',
        );
    }

    /**
     * @return array<string>
     */
    public function getKnowledge(): array
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

⭐ If you find my contributions useful, please consider making a donation to [Out in Tech](https://outintech.com/).

🤝 If you'd like to connect, you can find my social links [on my personal site](https://evansims.com/).
