### Howdy! Evan here. 👋

#### I'm a developer at [Okta](https://okta.com) Customer Identity Cloud (formerly [Auth0](https://auth0.com)) from the Champaign-Urbana, Illinois area. I'm passionate about building great software and helping others do the same.

```php
<?php

namespace EvanSims;

class Identity extends Human
{
    public const pronouns = [ 'he', 'him' ];

    public function getWorkplace(): array
    {
        return [
            'company'    => 'Okta',
            'team'       => 'Customer Identity Cloud',
            'position'   => 'Senior Engineer',
            'department' => 'Developer Experience SDKs',
        ];
    }

    public function getKnowledge(): array
    {
        return [
            Php::class,
            Laravel::class,
            Symfony::class,
            WordPress::class,
            Javascript::class,
            Node::class,
            Ember::class,
            React::class,
            TailwindCss::class,
            Aws::class,
        ];
    }
}
```

⭐ If you find my contributions useful, please consider making a donation to [Out in Tech](https://outintech.com/).

🤝 If you'd like to connect, can find my social links [on my personal site](https://evansims.com/).
