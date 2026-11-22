---
title: "The Ways Back In"
topic: Identity
updated: 2026-11-21
description: "Sign-in keeps getting stronger while account recovery stays weak. An identity system is only as strong as its easiest way back in."
---

The login was never the weakest link.

This year a wave of PlayStation accounts was taken over, and the victims had done everything right. Strong, unique passwords. Two-factor authentication. In at least one case, a passkey. They lost their accounts anyway.

Nobody broke the login. The reports point at account *recovery*: someone contacted support, said they'd lost access, and got the email changed and two-factor switched off with little more than a username and an old purchase number. No device, no biometric, and no cryptography were involved.

Three years earlier the same door opened at MGM Resorts. Attackers found an employee on LinkedIn, phoned the IT help desk as that person, and asked for help signing in. The call reportedly took about ten minutes, and they came away with administrator access.

I see this pattern constantly. We put enormous care into the front door and almost none into the recovery flow, the support script, and the delegation features sitting next to it. An attacker doesn't pick the lock. They ask who else can be let in, and what weak fact proves it's you.

Passkeys make the gap easier to see. I think the backlash against them is aimed at the wrong thing. The cryptography is the part that works: there's no shared secret to phish out of you and nothing to paste into a lookalike site. What frustrates people is what happens when they lose the phone the key lives on. The honest answer is usually a shrug, or a fallback to the same text message and email reset the passkey was meant to replace. The strong front door hands its spare key to the weak back door.

So an account is exactly as strong as its *easiest* way back in. If recovery is a text message, your passkey is protected by a text message. If it's a support call, it's protected by how busy the agent is that afternoon.

If you own an identity system, here is where I'd start. List every way back in: the reset email, the text message, the backup codes, the support script, the admin override, the family or team feature that lets one account act for another. Give each one the threat model you gave the login. Ask what an attacker would need to know, and whether a stranger could find it out. Make the risky paths slow and *loud*, with a waiting period and a notice to every address and device already on the account. And make sure nobody in support can remove a second factor alone, on the strength of a story.

Recovery is one of the unglamorous design questions we keep postponing. It's where the next round of effort should go.
