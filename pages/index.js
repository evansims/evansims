import Image from "next/image";

import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";
import { tomorrow } from "react-syntax-highlighter/dist/cjs/styles/prism";

export default function Home() {
  const humor = `<?php

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
  }`;

  return (
    <div>
      <main class="max-w-7xl mx-auto sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8 lg:flex">
          <div class="hidden w-full max-w-xs text-center lg:block">
            <Image
              class="rounded-full"
              src="/evan-sims-smol.png"
              width="125"
              height="125"
            />
          </div>
          <div class="max-w-xl">
            <h2 class="text-white text-xl">Howdy, Evan here. 👋</h2>
            <p>
              I'm a Full-Stack Developer near Lexington, Kentucky. I'm a Senior
              Engineer on the Developer Experience SDKs team at{" "}
              <a href="https://auth0.com" target="_blank" class="underline">
                Auth0
              </a>{" "}
              and Cofounder at{" "}
              <a href="https://droveio.com" target="_blank" class="underline">
                Droveio
              </a>
              .
            </p>

            <div class="w-full mt-8">
              <div class="pt-4 text-gray-100 text-sm font-mono bg-gray-800 rounded-lg overflow-hidden">
                <div class="top mb-2 flex px-5">
                  <div class="h-3 w-3 bg-red-500 rounded-full"></div>
                  <div class="ml-2 h-3 w-3 bg-yellow-500 rounded-full"></div>
                  <div class="ml-2 h-3 w-3 bg-green-500 rounded-full"></div>
                </div>
                <div class="mt-4 -mb-2">
                  <SyntaxHighlighter
                    language="php"
                    style={tomorrow}
                    wrapLines={true}
                    showLineNumbers={true}
                  >
                    {humor}
                  </SyntaxHighlighter>
                </div>
              </div>
            </div>

            <p class="mt-8">
              <a href="https://github.com/evansims">
                <span class="text-white">github</span> @evansims
              </a>
              <br />
              <a href="https://twitter.com/evansims">
                <span class="text-white">twitter</span> @evansims
              </a>
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
