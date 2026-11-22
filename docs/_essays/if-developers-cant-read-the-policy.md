---
title: "If Developers Can't Read the Policy, It's Wrong"
topic: Authorization
updated: 2026-11-21
description: "Authorization fails as a developer experience problem first. A permission model nobody can read can't be reviewed, tested, or trusted."
---

Read it out loud.

The permission bug you ship is rarely a clever attack. It's a rule nobody could see.

In most products the rules have no single home. One lives in an `if` inside a controller. Another is a `WHERE` clause. A third is a middleware check, and a fourth is a role name in a config file. Try answering one question from that: can a contractor export billing data? You'll read five files and still not be sure, and neither will the person reviewing your change.

I built SDKs at Auth0 for more than three years, and one rule from that work applies here: the happy path has to be the obvious path. Developers do what the tool makes easy. Authorization as most teams build it makes the wrong thing easy, which is one more `if`, wherever you happen to be standing.

So here is the test I'd apply to any permission system. Read the policy out loud to someone in security or compliance. If you can't, because the policy is spread through the codebase, it is already wrong, whatever it currently allows.

A policy you can *read* looks like this:

```
type document {
  relation parent: team
  relation owner: user
  relation editor: user
  relation can_edit = owner | editor | admin from parent
}
```

Out loud: a document can be edited by its owner, by its editors, or by an admin of the team it belongs to. Someone who has never seen the codebase can tell you whether that's the rule the company wants.

Readable is where the rest starts. A change to that file is a diff, so it goes through *review* like any other change. A machine can check it before it ships and catch a misspelled relation, a deny rule that makes a permission unreachable, or an action nobody wrote a rule for. Those surface at deploy time, when the cost is a failed build. The alternative is finding them at 2am, when the cost is a customer.

The system can also *explain* itself. "Access denied" with nothing after it tells a developer nothing. They need to know which relationship was missing, the same way a good library says what went wrong and hints at the fix. When a denial arrives with its reason, a permissions bug takes minutes to find.

That's why InferaDB's policy language has only a handful of keywords, and why one rule is fixed: an explicit deny always wins. Nobody has to reason about ordering. A small language with strong opinions is easier to read than a flexible one, and reading is what the whole design is for.

The best authorization is the kind users never think about. It gets that way when developers can read it.

Pick the most dangerous permission in your product and try to read its rule out loud. If you can't find the rule, you've found the bug.
