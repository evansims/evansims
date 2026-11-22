---
title: "Authorization Is a Database Problem"
topic: Authorization
updated: 2026-11-21
description: "Permission checks run on every request, which makes authorization a storage workload. A policy layer over someone else's database hits a ceiling."
---

I'm building the database.

Authentication asks its question once, when you sign in. Authorization asks on every API call, every database read, and every step an AI agent takes, often dozens of times inside one request. A question asked that often is a storage workload, and most of the industry still treats it as a policy lookup.

I helped build the last generation. I was a founding engineer on OpenFGA at Auth0 and then Okta, and thousands of developers adopted it. It was a real step forward in how you *model* permissions. It also showed me where the design stops.

OpenFGA, like every system of its kind, is a policy engine. It keeps its data in a general-purpose database such as Postgres or MySQL. Take the simplest question you can ask: can Alice open this document? Alice is on a team, the team can view a folder, and the folder holds the document. That's three hops through a graph, and a general-purpose database treats each hop as its own query, which it parses, plans, and wraps in a transaction designed for a different job. The answer comes back in 5 to 50 milliseconds.

One check at that speed is fine. A single agent action can need thirty, which is 150 milliseconds at best and a second and a half at worst, spent before any real work begins.

So you add a cache, and now there are two copies of the truth.

Revoke an admin's access, then ask whether any replica can still serve the old grant. With a cache sitting between a policy engine and someone else's database, you can't promise it won't. Google's Zanzibar paper called this the new enemy problem. Google solved it with Spanner, a globally distributed database it built itself, with clocks precise enough to order writes across the planet. The open-source descendants of Zanzibar don't have Spanner.

Tenants go the same way. When *isolation* lives in application code, as a tenant ID column plus discipline, one bug in the query layer shows one customer's permissions to another. So does audit. A log kept in a table that an administrator can edit is a claim you can't prove, and regulated customers now ask for proof.

Latency, consistency, isolation, audit. Each ceiling sends a team back to a storage layer it doesn't control.

A library can give you a clean API. A sidecar can give you locality. Neither can give you a storage *guarantee*, because neither owns the storage.

That is the argument for InferaDB. We started from one question: what does a storage engine look like when an access check is the only thing it has to answer? The workload is small key lookups across relationship tuples, read far more often than written, with revocations that have to be visible everywhere at once. Build for that and a check takes microseconds. We measure 2.8 at the 99th percentile. Writes go through consensus, so a lagging replica can't serve a revoked grant. Each tenant's data is encrypted under its own key, so cross-tenant access fails inside the storage engine, where no query bug can reach it.

None of this can be added to a system that hands its storage to something else. It's what we would have built at OpenFGA if we'd been free to design the whole stack.

If you're choosing authorization infrastructure this year, find out who owns the disk before you compare features. The four ceilings are set there.
