### Howdy <a href="https://www.evansims.com/"><img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="25px"></a>
I'm Evan, a full-stack developer currently living near Lexington, Kentucky.

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
            Javascript::class,
            Laravel::class,
            Ember::class,
            ReactNative::class,
            TailwindCss::class,
            Aws::class,
        ];
    }
}
```

📮 Feel free to reach me [on Twitter @evansims](https://twitter.com/evansims)
