---
title: An Agent Needs Its Own Identity
topic: Authorization
updated: 2026-11-21
description: "An agent that borrows your login can't be told apart from you, so give it its own identity, scoped to the task and recorded in the audit log."
---

Then scope it.

I've spent most of my career on how one party safely acts on behalf of another. AI agents are the newest party, and most of them still act by borrowing a person's login.

That's the first thing to fix. An agent signed in as you can't be told apart from you, by the service or by its audit log. When something goes wrong three weeks later, the record says you did it.

"Agent identity" gets thrown around like one thing. It's three, and people keep conflating them.

*Authentication* is who the agent is, and whether it carries its own credential or borrows yours. *Authorization* is what it's allowed to do, and whether that's scoped to a task. *Attribution* is who an action traces back to when you read the log.

Almost everyone is focused on the first one, giving agents a login. The failures that will hurt you live in the other two. An agent with a perfect identity and your unrestricted access is still a breach waiting to happen.

The question has changed shape, too. The old question was whether Alice can access this resource. The new one is whether this agent, acting for Alice, on this task, can call this tool. That's a chain of relationships, and a role attached to Alice's account can't express it.

A bearer token shows why the scope matters. It works like a hotel keycard. Whoever holds it gets into the room, and the lock doesn't check whose hand it's in. Give an agent a long-lived token with your full access and you've handed over your keycard for the whole building.

So give the agent its own identity, with access you can scope to one task, revoke in a second, and replay afterward. Put the enforcement somewhere the agent can't reach, because a guardrail the agent can edit is one it can remove.

This is the problem I work on at InferaDB. Take one request. Alice asks a research agent to summarize her team's Q3 strategy, and the agent decides to run a vector search and read a document. Each step becomes a check that names both parties. The subject is the agent, acting on behalf of Alice, asking to read that one document through that one tool. The agent gets through only if Alice could have read the document herself. If someone removed her access five seconds ago, the agent is denied on the next check, with no token refresh to wait for.

Every answer lands in an audit log that records the whole chain, from Alice to the agent to the tool to the document. Three weeks later the record says the agent read it, on Alice's behalf, and shows which relationship allowed it.

One agent action can mean thirty or more of these checks, which is why each one has to take microseconds.

Scope and attribution are the hard part. Start there.
