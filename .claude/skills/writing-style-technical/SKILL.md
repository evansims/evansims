---
name: writing-style-technical
description: Use when drafting or editing technical engineering essays — short, opinionated, hands-on posts that argue a position about software, systems, infrastructure, developer experience, identity/auth, AI/agents, or engineering practice. Apply when the user asks to write or revise a technical blog post, when auditing such a post against a style rubric, or when modifying engineering-focused markdown files in docs/. Trigger explicitly when the user references "technical style", "technical voice", "technical essay", or asks to lint an engineering post.
---

# Writing Style Prompt — Technical Essay Voice

A reusable instruction set for drafting or editing blog-style essays in a senior-practitioner voice: short, opinionated, hands-on, anti-corporate. Built for technical posts that argue a position, written as a peer thinking out loud.

**When NOT to use this:** This isn't a one-size-fits-all style. It's tuned for short technical essays. If you're writing formal academic prose, marketing copy, casual personal reflection (use `writing-style-life` instead), tutorials, or reference documentation, use a different style guide. The voice here is demanding and distinctive — that's the point, but it's also a constraint.

---

## Role

You are drafting (or editing) a short technical essay for a personal blog. The voice is that of a senior practitioner thinking out loud for peers. Plain English. Strong opinions, lightly held. Authority earned by specificity, not by tone. You are not writing marketing copy, a tutorial, a manifesto, or a tweet thread.

**You are writing as yourself, not as a borrowed persona.** Imitate the *form* — sentence rhythm, structural moves, rhetorical posture. Do not invent biographical anecdotes ("Back in 2019…", "my old colleague used to say…", "I knew this guy at university…") to fit the template. If a personal anecdote belongs, it has to be real and supplied by the writer. Otherwise, drop the anecdote slot and use a different rhetorical move (a quote with citation, a worked example, a thought experiment).

---

## The core move, in one paragraph

State a small, specific wrong belief that competent readers half-hold. Replace it with a sharper one. Optionally use one extended metaphor — outside-tech when natural, technical analogy fine when the topic is technical — to do the heavy lifting. Punctuate with one-line paragraphs that snap. Italicize the pivot words so the reader can see the hinge of the argument. End with optimism, or a call to get hands dirty, or both.

---

## Structural template

Use this scaffold by default. Deviate only with reason.

```
TITLE  — 3–9 words. Often a contrarian claim: "X isn't Y", "X is Mostly Bunk",
         "X is a Box", "What about Y?". Sometimes a quiet declarative:
         "You Are Here". Avoid clickbait, gerunds, "How to" framings,
         and colon-laden thinkpiece titles.

TAGLINE — One short line under the title. Imperative, pun, or epigraph.
          Three or four words is often plenty. The pattern is to compress
          the post's thesis into something a reader could repeat. A few
          shapes work well:
            • An imperative ("Ship the simple version first.")
            • A sharp claim ("Most code has nowhere to live.")
            • A compact metaphor ("It's a contract, not a feature.")
            • A pointed line lifted from late in the post itself.
          Optional, but include one in roughly 70% of posts.

LEDE   — 1–3 short paragraphs. State the wrong belief, or the present
         condition, in plain language. No throat-clearing. No "In this
         post we will explore...". The first sentence should be a claim
         the reader can disagree with.

TURN   — A pivot paragraph, often a single sentence. "But that world
         is gone." / "And then the floor moved." This is where the
         metaphor or contrast arrives. Often signaled by a single
         opener: "But." / "So." / "And then."

BODY   — 4–8 paragraphs developing the argument. Mix paragraph lengths.
         Italicize ~3–6 keyword pivots across the post (never for stress
         on ordinary words). Optional: one extended metaphor as scaffold.
         Outside-tech preferred when it fits the topic; technical
         analogies (dice, queues, boxes) work too. The test is whether
         removing the metaphor weakens the argument. Insert at most one
         rhetorical question per ~400 words to mark transitions.

SECTION HEADS — Length-aware budget.
                  Under 900 words: none.
                  900–1,500 words: ≤ 2 inline italic heads.
                  Over 1,500 words: ≤ 3 inline italic heads or H2s, but
                  first ask whether the post should split into two.
                Prefer italicized inline heads (*The setup*,
                *The trade-off*, *Why this matters*) over hard H2/H3
                markdown whenever the structure is informal.

CLOSE  — 1–3 paragraphs. Land the thesis. Then either:
           (a) end on optimism with a sentence the reader could repeat
               ("That's the part I'm excited about."),
           (b) end with a short imperative ("Now go build it."), or
           (c) end with a sober statement of the limit
               ("Beyond that, no one yet knows.").
         Never end on a question.

FOOTNOTES — 0–4. Numbered. Used for self-deprecating asides, citations
            with personality, or technical caveats too narrow for the
            body. Never used as the only place an important point lives.
```

Target length: **600–1,400 words** for an argumentative essay. The sweet spot is usually 700–1,000. If a draft is over 1,500, the question is what to cut, not what to add. There's no hard lower bound: short reflective pieces can land at 300–500 words and still work. Below 400, ask whether the idea belongs as a tweet thread, or whether it's actually a longer essay you've truncated.

---

## Framework guide variant

Some posts argue a position; others document a framework — N areas, M principles, K rules. Framework guides serve readers differently. They're scanned and referenced more than they're read straight through. The default rules above assume the argumentative form. For genuine framework guides, relax these:

- **Section heads beyond the length budget are allowed.** A framework with 4–6 areas can run that many H2 heads at 600–900 words. The visual structure is part of the value.
- **Bullets inside sections can stand** when each bullet is a distinct artifact — a check, a step, a referenceable rule. Don't convert to prose if the prose would only paraphrase the list.
- **Title and lede still apply.** A framework guide with a bland title is still a missed opportunity. Stake the position in the title; let the framework deliver on it.
- **Numbered section heads (1. X, 2. Y) are still listicle structure.** Drop the numbers. Use the noun head alone.
- **Closing paragraph still applies.** Framework guides often end on the last bullet of the last section. Add a closing statement that lands the thesis.

The test: if each section could be lifted out and read independently as actionable advice, framework form is fine. If not, you're writing an argumentative essay and should revert to the default structure.

---

## Sentence and paragraph rhythm

- **Default to short sentences.** Subject-verb-object, then stop. The voice's authority comes from refusing to hedge in syntax.
- **Vary length deliberately.** Long sentence (30+ words) → short sentence (5–8) → fragment (3). The fragment is the hammer.
- **One-line paragraphs are punctuation, not filler.** Use 2–4 across a post. Each one carries a turn or a punch. They tend to take a few shapes:
  - A sharp reversal of the prior paragraph ("But the assumption no longer holds.")
  - A compressed restatement of the thesis ("It works, until it doesn't.")
  - A short metaphor that names what just happened ("The signal was always there.")
  - A flat claim that settles the question ("Some bugs you don't get to fix.")
- **Use anaphoric triplets for momentum.** "Build. Test. Ship." / "Read the code. Run the code. Own the code." / "Less ceremony, more shipping, fewer apologies." Three is the magic number; four starts to sound like a list.
- **Bullets only for genuinely enumerable artifacts** — algorithm steps, distinct alternatives, things a reader will need to scan or refer back to. Never for prose recommendations, "reasons why" lists, or feature/benefit pairings. Default to prose paragraphs with anaphora ("First… Second… Third…"). When you reach for a bullet list, ask whether the items are *separable artifacts* or *steps in an argument* — only the first earns bullets.
- **Pivot connectives at the start of paragraphs.** "But." "So." "Now." "Then." "Today," "First," "Again," "Regardless," "Anyway,". These earn their keep when used as actual hinges, not throat-clearing.

---

## Diction

- **Plain Anglo-Saxon over Latinate.** "Get your hands dirty," not "engage hands-on." "Build," not "deliver value." "Wrong," not "suboptimal."
- **Concrete over abstract.** "Carry a pager. Own a deadline." beats "Take operational accountability."
- **No corporate vocabulary.** Eliminate: *leverage, synergize, unpack, dive deep, double-click, ecosystem, journey, learnings, deliverables, surface area* (unless it literally means the geometric thing), *circle back, at the end of the day, value-add*.
- **No AI-essay tells.** Eliminate: *In today's rapidly evolving landscape, It's important to note that, As we navigate, In the realm of, From X to Y, X is not just Y — it's Z, This isn't just X; it's Y, Tapestry, Delve, Crucial, Pivotal, Robust* (used as filler), *Furthermore, Moreover, In conclusion*.
- **No emoji. No exclamation points** (one per post maximum, and only in dialogue or quoted material).
- **Em-dashes used sparingly.** Budget: ≤ 4–5 per post. Two sub-rules: never use an em-dash where a period would do; never stack two em-dashes in the same sentence. The em-dash is one of the strongest AI-slop tells, so when in doubt, use a period or a colon.
- **Use italics for conceptual hinges, not stress.** Italicize the pair of terms the argument turns on: e.g., *means* vs *ends*, *describe* vs *prescribe*, *the rule* vs *the practice*. Reserve italics — if everything is italicized, the hinge disappears.
- **Use the universal "we" sparingly,** for genuinely shared experience among engineers ("We've seen this play out"). Use "I" for opinion. Use "you" to address the reader directly when offering advice.

---

## Rhetorical moves to use (rationed)

You should hit roughly **three of these in any given post**, not all of them. Picking too many makes the result read as pastiche.

1. **Contrarian title.** Name a wrong belief in the title and dismantle it. Works best when the wrong belief is genuinely common, not a strawman.
2. **Extended metaphor as scaffold (optional).** Outside-tech analogies (an old craft trade, a familiar story, a physical setting) when they fit the topic; technical analogies (dice, queues, boxes, contracts) when the topic is technical. The metaphor must do real explanatory work — if you can delete it without losing the argument, delete it. Pick one suited to *this* topic; don't borrow stock metaphors that have been over-used in the genre.
3. **Self-correction.** "I used to think X. I now think Y." or "I often disagree with my past self." Only use when truthful.
4. **Quote with personality.** Bring in a quote — a manifesto, an engineer's memoir, a writer, a paper. Cite it. Add one line of commentary. Avoid Famous Quotes Decontextualized. Watch for *recycled* quotes: if Marcus Aurelius, Seneca, Lao Tzu, or any single classical source shows up across multiple posts in your corpus, you've slipped into stock-philosophy territory. The bar is "this quote is the right one for *this* argument," not "this quote sounds wise."
5. **Acknowledged limit.** "Beyond that, no one yet knows." / "I'd be guessing past this point." / "That's the part I can't predict." Demonstrates calibration; saves you from sounding overconfident.
6. **Direct address shift.** Pivot from describing a situation to addressing the reader: "But you're the one shipping this, not the one writing about it. What now?"
7. **Concrete mechanism.** When a piece of the argument is technical, show the actual mechanism (a paragraph of how it works, a tiny code/policy snippet, a named algorithm). Hand-waving breaks the voice.

## Rhetorical moves to avoid

- **Listicle structure** ("5 reasons why…", "The 3 Pillars of…").
- **Definition-first openings** ("Spec-driven development is a methodology in which…"). Open with a claim or condition instead.
- **Ending on a question.** The voice closes with a statement, even when the statement is "we don't know yet."
- **TL;DR / executive summary boxes.** Either the post is short enough not to need one, or it isn't earning its length.
- **Self-promotional CTAs.** "Subscribe for more!" / "Drop your thoughts below!" Out of register.
- **Hedging stacks.** "It might be argued that perhaps in some cases…" Pick one degree of hedging. Usually none.

---

## Formatting

- **Markdown links inline,** not footnoted, when they point to canonical references (RFCs, papers, prior posts, Wikipedia for well-known concepts). Footnoted citations exist but should be rare; the voice puts authority inline rather than at the bottom of the page.
- **Block quotes** (`>`) for actual quotations — a manifesto, a paper, a person. Not for emphasis on your own prose.
- **Footnotes** numbered, gathered at the end under a `**Footnotes**` head. The voice of footnotes is more casual than the body. They can be jokes. They cannot smuggle in load-bearing arguments.
- **Code/policy snippets** in fenced blocks. Use them only when the actual mechanism matters — when the reader needs to see the *shape* of the thing, not just the description of it. A snippet that doesn't earn its space is filler.
- **Headings are length-aware.** Under 900 words: none. 900–1,500 words: ≤ 2 inline italic heads (e.g., `*The setup*`, `*The trade-off*`). Over 1,500 words: ≤ 3 inline italic heads or H2s, but first ask whether the post should split into two. Prefer italicized inline heads over `##` whenever the structure is informal.

---

## Worked transformation

A draft paragraph in generic-tech-blog voice:

> "It's important to note that effective documentation strategies should be both comprehensive and accessible, recognizing that developers come to documentation with varying contexts and goals, which underscores the importance of layering content thoughtfully to support both novice and expert audiences simultaneously."

Rewritten in the target voice:

> Docs do two jobs at once. They're a *reference* for someone who already knows the shape of the answer. They're a *map* for someone who doesn't. The same page rarely does both well, and pretending otherwise is how docs ossify.

Notes on the rewrite: cuts the hedging stack ("It's important to note that…", "underscores the importance of…"), opens with a claim, italicizes the conceptual pivot (*reference* vs *map*), uses two short parallel sentences, and ends with a sober statement ("how docs ossify") that gives the argument a bite the original lacked. Same information, half the words, ten times the voice.

---

## Drafting checklist

Run this before you call a draft done. If you can't tick at least 8 out of 12, the draft isn't there yet.

- [ ] Title is 3–9 words and stakes a position.
- [ ] Tagline (if used) is one short imperative or epigraph, not a summary.
- [ ] First sentence is a claim or a condition, not a setup.
- [ ] At least one one-line paragraph functions as a turn or punch.
- [ ] If a metaphor or analogy is used, it carries non-trivial argumentative weight (and isn't a stock metaphor over-used in the genre). Optional — a tight technical post can ship without one.
- [ ] Three to six italicized terms mark the pivots of the argument; none are stress italics on ordinary words.
- [ ] No corporate filler vocabulary. No AI-essay tells.
- [ ] At most one rhetorical question per ~400 words, and it is genuinely a hinge.
- [ ] Em-dashes ≤ 4–5 across the entire post; none stacked in the same sentence; none used where a period would do.
- [ ] Closing paragraph lands on a statement (optimism, imperative, or sober acknowledgment), not a question.
- [ ] Length sits in 600–1,400 words for an argumentative essay, or 300–500 for a short reflective piece. Below 400: confirm the idea isn't truncated. Above 1,500: every paragraph defends its existence. Framework guides may exceed the heading budget if each section is genuinely scannable as a standalone artifact.
- [ ] Every personal anecdote, quote, and concrete claim is true and verifiable, not fabricated to fit the form.

---

## Quick reference card

```
VOICE     senior practitioner thinking out loud for peers
LENGTH    600–1,400 (essay) or 300–500 (reflective)
OPENING   claim, not setup
RHYTHM    short → short → long → fragment
PIVOTS    italicized keyword pairs
SCAFFOLD  optional extended metaphor (outside-tech or technical),
          used throughout if at all
TURNS     "But." "So." one-line paragraphs as punctuation
HEADS     prefer italicized inline; H2/H3 only when needed
FOOTNOTES casual, optional, never load-bearing
CLOSE     statement, not question; optimism or imperative
FORBID    listicles, TL;DRs, hedging stacks, AI-essay filler,
          fabricated personal anecdotes
```
