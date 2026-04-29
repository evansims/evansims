### Howdy! Evan here. 👋

Co-founder and CTO at [InferaDB](https://inferadb.com), the authorization database: Zanzibar-inspired, AuthZEN-compliant, and purpose-built for fine-grained access control at scale. The goal is to make authorization explainable and composable. Developers can model relationships, define policies declaratively or as WASM modules, and ship auditable access control across services, APIs, and AI agents.

Previously: a founding engineer on the OpenFGA team at [Okta](https://okta.com), where we shipped one of the first Google Zanzibar-inspired ReBAC solutions to market: [OpenFGA](https://openfga.dev) and the [Auth0](https://auth0.com) FGA SaaS built on it. OpenFGA is now a CNCF incubating project used by Grafana Labs, Docker, and Canonical. Before that, an early engineer on Auth0's developer experience team, shipping 45+ open source libraries used by enterprise customers. Earlier still, I helped build crisis-response tools at [Ushahidi](https://www.ushahidi.com), with deployments at the United Nations and during the Fukushima disaster response. That work taught me to take security, privacy, and the people on the other end of the software seriously.

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
