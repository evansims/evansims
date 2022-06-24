### Howdy! Evan here. 👋
#### I'm a developer at [Auth0](https://auth0.com) from the Champaign-Urbana, Illinois area.

```php
<?php

namespace EvanSims;

class About extends Me
{
    public const pronouns = [ 'he', 'him' ];
    
    public function getWorkplace(): array
    {
        return [
            'company'    => 'Auth0',
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
            Ember::class,
            React::class,
            TailwindCss::class,
            Aws::class,
        ];
    }
}
```

⭐ If you find my contributions useful, please consider making a donation to [Out in Tech](https://outintech.com/).

📨 Feel free to reach me on [Twitter](https://twitter.com/evansims) or [LinkedIn](https://linkedin.com/in/evansims).
