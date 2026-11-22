---
title: "The Interface Is the Speed Limit"
topic: Systems
updated: 2026-11-20
---

More hardware won't save you.

The real power isn't under the hood. It's in the design, in the thinking, in the interface, the boundary where systems exchange information through the function signatures their implementations expose. As engineers, we tend to think of performance as a coding problem: profile, vectorize, branch-predict, hand-roll the hot loop. These techniques pale next to the power of systems thinking. Sometimes the entire performance budget has been spent before the first instruction runs.

To make this concrete, take one of the world's most valuable workloads: OLTP. Online transaction processing, the workload that powers banking, brokerage, instant payments, ticketing, ride-sharing. Read-light, write-heavy. Routine operations at extraordinary volume. Forty years ago, Jim Gray defined a transaction as a debit-credit: move value from one row to another, record the history. Simple. Powerful. The essence of moving anything in the real world.

Gray also did something subtle that the industry mostly missed. His benchmark included contention: a hot account every transaction had to touch. He understood that real-world OLTP isn't an embarrassingly parallel problem. The Pareto principle applies. 80% of transactions go through 20% of rows. UPI, India's instant payment system, sends 85% of its volume through two payment apps. Black Friday is contention. Oasis tickets are contention. So is every system you'd actually want to scale.

This is the part that breaks the standard SQL interface.

Picture a Postgres database. A client begins a transaction across the network. It reads two account rows. It does some logic in the application. Then it writes the updated rows and commits. Two round trips. Each round trip is one millisecond.

The problem isn't the SQL. It's that the transaction holds row locks across the entire round trip, including the time the database spends *waiting on the application*. If your network is one millisecond, those rows are locked for at least one millisecond. If your network is ten milliseconds, ten.

Amdahl's Law says the serial fraction of a workload caps its speedup, no matter how much hardware you add. Here the serial fraction is the contended portion, and each serial section lasts as long as a lock is held. Plug in 10% contention and a one-millisecond round trip, and the theoretical ceiling is 10,000 transactions per second, even if your database is infinitely fast. At 50% contention, 2,000 TPS. At Pareto-style 90% contention, 1,111 TPS. Push the round trip to ten milliseconds and divide everything by ten.

These are theoretical limits, assuming infinite hardware and zero database overhead. They're set by the *interface*. Locks held across the network. Period.

You can verify this empirically. Postgres on a single machine tops out around 12,000 TPS at zero contention. Drop in 10% contention and a 10ms client and it collapses, exactly as Amdahl predicts.

The instinct at this point is to throw money at the problem.

*The million-dollar McLaren*

A modern Postgres-compatible cloud cluster, 16 machines, $84,000 per month, advertises "unlimited, infinite scale." It runs the same workload through the same interface: same SQL, same locks across the network, just sharded across more nodes.

At zero contention: 7,500 TPS. Under two-thirds of what single-machine Postgres delivers, despite 16× the hardware. At 10% contention: 574 TPS. Cut the cluster down to a single machine of the same family and throughput goes up by 10% while costing 8× less.

The cluster runs at 12% CPU under load. The hardware is idle. This isn't a parallelism problem. It isn't a Postgres-specific problem. It's the interface holding locks across the network, internally between shards as well as externally to clients. The shape of the curve matches Amdahl's law because it *is* Amdahl's law. No amount of money buys throughput when the speed limit is set by a constant: the speed of light through fiber.

The usual responses at this point are unfortunately popular. Some shift the burden to the application: "scalable apps must avoid contention." But contention is the workload. Telling a payment app not to contend is telling it not to be a payment app. Others trade ACID for speed, weakening isolation. But OLTP that doesn't count correctly under contention isn't OLTP. The shortcuts buy you less than they cost.

*Fix the interface*

There's a third option, which is to ask what the interface should look like if you stopped pretending OLTP is general-purpose SQL.

Strip the debit-credit down to its essential information: who paid whom, how much, of what, when, why. Two cache lines. 128 bytes. Pack as many of them as you have at hand, up to 8,000, into a single one-megabyte query. Send it. Have the database process the whole batch without holding any row locks across the network. Acknowledge with a reply. One round trip, end-to-end.

How is this safe? The trick is that the batch *becomes* the unit of coordination. A single writer processes the batch deterministically, in order, in memory. Each transaction in the batch sees the result of the previous one. The whole batch commits atomically or not at all. Replication happens via consensus across multiple machines, which preserves durability without requiring locks across the network mid-transaction. Serializability is by construction: there's exactly one order in which the database executes transactions, and every replica sees the same order.

The trade is real but lopsided. An individual transaction now waits longer than it would in the old model. Long enough for the batch to be assembled, processed, and replicated. For workloads that care about per-transaction latency above all else (interactive UI, low-volume admin operations), this is the wrong design. For workloads that care about aggregate throughput at high contention (payments, ticketing, settlement, instant transfers), the per-transaction wait is microseconds, and the throughput multiple is in the thousands. The math favors the new design any time the workload's actual job is to process volume under contention.

The same logic holds for transactions more complex than debit-credit. Any transaction that can be expressed as a deterministic state transition over the database's internal state can be batched and executed without per-row locks. The constraint is that the transaction logic has to live in the database, not the application. That's the price. In return, you get throughput that doesn't depend on the speed of light.

The math now changes. Two milliseconds for two round trips, amortized over 8,000 transactions, becomes microseconds per transfer. Even compared to an infinitely-fast SQL database, this gives a 1,000× speedup. Not because the implementation is faster, but because the interface stopped requiring the database to wait for the speed of light between every row read and every row write.

This is the principle [InferaDB](https://inferadb.com) is built on, applied to authorization. The workload is different, mostly reads at very high volume, but the ceiling is the same one. A permission check answered by a policy layer on top of a general-purpose database pays a network round trip for every lookup, and one request can need dozens of them. Prior work in financial OLTP makes the case empirically. TigerBeetle, a database purpose-built for debit-credit transactions, has measured 400,000 transactions per second at 10% contention with full replication and consensus across four machines. At 50% contention, that's 2,400× faster than an $84,000-per-month Postgres-compatible cluster running the same workload. At 90% contention, in Pareto and Black Friday and UPI territory, the gap widens further.

Less hardware. Same physics. A different interface.

This is bigger than Postgres or any specific database. It's bigger than SQL. SQL is just a query language; even a better SQL spec wouldn't change anything if the interface still asked the database to wait on the application across the network. Any general-purpose database that holds locks across the wire hits the same ceiling, set by the same law.

Specialization changes the math. OLTP isn't general-purpose processing and it isn't analytics. The data plane that processes Black Friday isn't the same as the control plane that signs up users. Putting the rare, low-volume tables in a general-purpose database and the high-volume contended ones in a purpose-built OLTP system gives you the right tool for each.

The deeper lesson is for every system you build, not just databases. The first place to look for performance isn't the inner loop. It's the boundary. The interface. The shape of the conversation between components. By the time you're profiling vectorized code paths, you've already accepted whatever ceiling the interface set.

Hardware won't save you. Neither will optimization. The right move is to ask whether the *boundary* is the bottleneck. Most of the time, it is.
