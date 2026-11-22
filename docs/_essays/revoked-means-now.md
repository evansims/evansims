---
title: "Revoked Means Now"
topic: Authorization
updated: 2026-11-21
description: "An eventually consistent permission system has a window where revoked access still works. That window is a security hole, and closing it costs milliseconds."
---

Eventually is too late.

Alice removes Bob from a document at 10:00:00. One second later Bob asks for it, and his request lands on a replica that hasn't heard the news. The replica says yes. Nothing malfunctioned. The system is *eventually* consistent, and for one second two of its machines disagreed about what Bob may see.

In most software that kind of lateness is harmless. A post shows up a few seconds after it was written, and nobody is hurt. Authorization differs in one specific way: the late answer is the wrong answer, and it can't be taken back. The replicas will agree again soon enough. Bob has still read the document.

Google's Zanzibar paper has a name for the sharpest version of this, the *new enemy problem*. Alice removes Bob, then adds something sensitive to the document, precisely because Bob is gone. A stale replica now shows Bob the new material. She made an enemy and then wrote down a secret, and the system got the order backwards.

Think about when a revocation happens. Someone was let go this morning. A contractor's engagement ended. An account looks compromised and you're cutting it off. In each case the person losing access is the one most likely to be using it right now, and the minutes after the change are the ones that count.

The usual architecture makes this worse without anyone deciding to. Replicas lag by a little. Then a cache goes in front of them to make checks fast, with a time-to-live of a few minutes. That setting reads like a performance detail. It is also a statement that every revocation in your product takes up to that many minutes to mean anything.

So I treat consistency in authorization as a *security property*, and most systems tune it like a performance one.

Closing the window has a price, and it's smaller than people expect. At InferaDB every write goes through consensus. A change is acknowledged only after a majority of nodes have stored it, and any node serving reads at or after that revision will show it. That costs 3 to 4 milliseconds on a typical write and 10 to 15 at the 99th percentile. Reads outnumber writes by orders of magnitude, so the cost lands on the rare operation and protects the common one.

The other half is a token. Every write returns a revision, and a read that carries it is guaranteed to see at least that state. Google called theirs zookies. With a token, staleness becomes something you choose per request: the strictest read when a change must be visible immediately, a looser one for a batch job that can tolerate it. What you no longer get is staleness you didn't ask for.

Ask your own system one question: after I revoke access, *when* is it gone everywhere? If the answer contains the word "eventually", there is a number behind it. Find that number before someone else does.
