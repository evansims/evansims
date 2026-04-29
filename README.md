### Howdy! Evan here. 👋

Founder at [InferaDB](https://inferadb.com), a fine-grained authorization system inspired by Google Zanzibar and built on the AuthZEN standard. The goal is to make authorization explainable and composable: developers can model relationships, define policies declaratively or as WASM modules, and ship auditable access control across services, APIs, and AI agents.

Previously: Senior Engineer at [Okta](https://okta.com), where I led developer experience, authentication, and authorization initiatives across [Auth0](https://auth0.com) and [OpenFGA](https://openfga.dev). Before that I helped build developer tools and crisis-response systems at [Ushahidi](https://www.ushahidi.com), which is where I learned to take security, privacy, and the people on the other end of the software seriously.

Open source, digital wellbeing, systems built to last. Former game designer; the instinct for building experiences people actually want never quite leaves you.

```rust
const PRONOUNS: &[&str] = &["he", "him"];

trait Maker {
    const LANGUAGES: &'static [&'static str];
    const TOOLING: &'static [&'static str];
    const SPECIALTIES: &'static [&'static str];
    const PHILOSOPHY: &'static str;
}

struct Evan;

impl Maker for Evan {
    const LANGUAGES: &'static [&'static str] = &[
        "rust", "go", "typescript", "python", "php",
        "java", "c#", "ruby", "swift", "c++",
    ];

    const TOOLING: &'static [&'static str] = &[
        "react", "svelte", "next.js", "tailwind",
        "postgresql", "docker", "kubernetes", "terraform", "helm",
        "opentelemetry", "grafana", "prometheus",
        "aws", "gcp", "azure", "cloudflare", "vercel",
    ];

    const SPECIALTIES: &'static [&'static str] = &[
        "identity", "fine-grained-authorization",
        "oauth", "oidc", "saml", "jwt", "pki",
        "distributed-systems", "developer-experience",
        "mcp", "rag",
    ];

    const PHILOSOPHY: &'static str =
        "Make the right path obvious. Build for the people on the other end. Leave it better than you found it.";
}
```

🌐 [evansims.com](https://evansims.com/) · [LinkedIn](https://www.linkedin.com/in/evansims/) · [Bluesky](https://bsky.app/profile/evansims.com) · [X](https://x.com/evansims)
