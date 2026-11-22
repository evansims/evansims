---
title: "Model the Relationships First"
topic: Authorization
updated: 2026-11-21
description: "A role records what someone can do and never why. That's how permission systems grow into tables nobody can explain, and why modeling comes before any tool."
---

A role says what. It never says why.

You know how it starts. One table, `user_roles`, and a few `if` statements in a controller. Next comes a request for finer control, so a permissions table appears, with a join table to connect it. Teams want their own boundaries, so memberships get a table. A customer asks to share one document, so there's a shares table. Someone needs an exception for a single resource, and now there's an overrides table with a priority column.

Every one of those requests was reasonable. Together they leave you with six tables, authorization logic spread across middleware and services, and a team that can't answer a simple question: who has access to what?

I've helped teams move off exactly this, and the cause is the same each time.

A role records *what* a person can do. It doesn't record *why*. The why is always a relationship: Alice is on the team that owns the folder that holds the document. When the relationship ends, because Alice changes teams or a contract runs out, nothing tells the role. It stays. Give that a few years and you have access nobody granted on purpose and nobody remembers to remove.

The second failure is quieter. When the system can't express something people need to do, they do it anyway. Say a manager has to give a contractor one folder until Friday, and roles are the only tool she has. She hands over an admin role "for now", or shares her own login. Authorization that doesn't model how people really work together gets bypassed, and after that your audit log no longer describes what's happening.

This is also why buying a fine-grained authorization system won't rescue a product on its own. Any such system, mine included, opens with the same request: tell me your objects and how they relate. If the product never decided what a workspace is to a team, or a team to a folder, there is nothing to load. You can't retrofit fine-grained authorization onto a domain that was never modeled.

So model first, before you look at a single tool. A spreadsheet is enough:

- The *nouns*. People, teams, organizations, folders, documents.
- The *verbs*. Owns, is a member of, can read, can edit, manages.
- The inheritance paths. Does membership in a team grant access to what the team owns? Does an organization admin count as a team admin?
- The exceptions. Direct shares, temporary grants, explicit denials.

Most teams come out with three to five nouns and five to fifteen verbs, and with a surprise: the model turns out far smaller than the code built around it. The tangle was in the implementation all along.

Then migrate without a cliff. Write every permission change to both the old system and the new one. Run both on every check, enforce only the old answer, and log each disagreement. Chase the disagreements until the log goes quiet, then switch.

Do the spreadsheet this week, whichever vendor you end up choosing. It's the part of the work that no tool can do for you.
