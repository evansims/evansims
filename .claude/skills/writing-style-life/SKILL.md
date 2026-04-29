---
name: writing-style-life
description: Use when drafting or editing personal essays on life, philosophy, productivity, mindfulness, habits, health, or general craft. Apply when the user asks to write or revise a non-technical blog post (life lessons, productivity advice, reflective pieces, philosophical observations), when auditing such a post against a style rubric, or when modifying any non-engineering markdown file in docs/. Trigger explicitly when the user references "life style", "life voice", "life essay", "personal essay", or asks to lint a non-technical post.
---

# Writing Style Prompt — Life & Philosophy Voice

A reusable instruction set for drafting or editing personal essays on life, philosophy, productivity, and craft. Built for posts that take a familiar idea and re-illuminate it through story, analogy, or example, in a voice that's warm, plain-spoken, and quietly confident.

**When NOT to use this:** This isn't tuned for technical engineering essays (use `writing-style-technical` for those), marketing copy, academic prose, tutorials, or reference documentation. The voice here is reflective and accessible — it assumes the reader is a thoughtful person, not a fellow practitioner.

---

## Role

You are drafting (or editing) a personal essay for a blog. The voice is that of someone who has thought about the subject before, isn't in a hurry, and trusts the reader to follow without being talked down to. Plain English. Warm but not folksy. Confident but not didactic. Authority earned by specificity — by the well-chosen example, the unexpected detail, the small truth most writing skips past — not by tone or credentialing.

You are not writing as a guru, a coach, or a teacher. You are writing as a peer, addressing a reader who could be a friend, a colleague, or a stranger who chose to read this.

**You are writing as yourself, not as a borrowed persona.** Imitate the *form* — sentence rhythm, structural moves, rhetorical posture. Do not invent biographical anecdotes ("When I was a kid…", "My grandmother used to say…", "I'll never forget the day…") to fit the template. Personal stories belong only when they're true and yours. Otherwise, replace the anecdote slot with a quote, a historical example, or a thought experiment.

---

## The core move, in one paragraph

Take a familiar idea — something the reader half-knows or feels but hasn't quite named — and re-illuminate it. Use a story, a quote, an example, or an angle that makes the idea concrete enough to act on. State the simple, often counterintuitive heart of it in plain language. Add the texture that makes it stick: the right detail, the specific number, the well-chosen quote. Land the close on a line the reader could repeat to a friend.

The goal isn't to be original. Most worthwhile essays in this register are rediscovery, not discovery. The goal is to make the reader nod, slow down, and remember.

---

## Structural template

Use this scaffold by default. Three mode variants are described below for posts that don't fit it.

```
TITLE  — Short and specific. Often utility-promising ("The Practice That
         Outlasts Motivation"), contrarian ("The Ones You Don't Say"),
         or a question ("What Are You Actually Choosing?"). Sometimes a
         quiet declarative ("On Patience"). Avoid thinkpiece colons,
         "How to" framings unless genuinely how-to, and clickbait
         numbers that don't reflect the post's structure.

TAGLINE — One short line under the title. Optional; include in roughly
          half of posts. Forms that work:
            • Compressed metaphor ("Like most habits, you only notice it
              after it's already a habit.")
            • Sharp claim ("Subtraction is the only kind of addition
              that lasts.")
            • A line lifted from late in the post itself.

OPENER — Pick one of three patterns:
           1. STORY: a short, concrete anecdote (historical,
              personal-if-true, or quoted) that sets up the question.
              Two to four short paragraphs. Vivid detail. No throat-
              clearing.
           2. CLAIM: open with the thesis directly. ("The first move in
              doing more is doing less of what doesn't matter.")
           3. INHERITED FRAME: open by quoting or summarizing another
              writer's piece, then turning. ("Last week, [author]
              published [piece] arguing [X]. They're partly right.")
         The first sentence has to pull the reader past the second
         sentence. No "Imagine you…" openers unless the imagining does
         real explanatory work.

THESIS  — Often a short paragraph (1–2 sentences) stating the simple
          claim the post defends. Sometimes italicized; sometimes set
          off with parallel structure. This is what the reader will
          carry if they remember nothing else.

BODY    — 3–7 paragraphs developing the thesis through:
            • An illustrating story or example.
            • A counterexample or limit case.
            • A quote from a named authority, used as a hinge, not
              decoration.
            • Direct address to the reader's likely objection.
          Mix paragraph lengths. Use 2–4 italicized terms across the
          post for conceptual hinges or earned emphasis. Place at least
          one short paragraph between longer ones, used as a turn or
          a punch.

SECTION HEADS — Inline italic or H3, used when the post has 3+ distinct
                moves. Length-aware:
                  Under 600 words: rarely.
                  600–1,500 words: 0–4 heads, only when each marks a
                                    genuine shift.
                  Over 1,500 words: 3–5 heads as scaffolding.
                Heads should be short and noun-shaped ("The Real Cost",
                "What Changed"), not interrogative or full sentences.

CLOSE   — 1–3 paragraphs. Land the thesis in a form the reader can
          carry. Three forms work:
            (a) A short imperative ("Stop trying to win this argument.")
            (b) A parallel-structure closing line ("A decision is one
                moment. A commitment is every moment after.")
            (c) An aphoristic compression of the argument
                ("Quiet is what makes everything else audible.")
          Never close on a question. Never close on hollow uplift
          ("In the end, what really matters is choosing love.").
```

Target length: **400–1,800 words**, with the sweet spot at 600–1,200. Aphoristic short posts can land at 200–400. Longer reflective essays can run to 2,500. The length should match the substance: a single observation belongs in 300 words; a developed argument with examples and counterexamples wants 1,000–1,500.

---

## Mode variants

Three sub-modes show up frequently. Each shifts the default structure.

**Aphoristic short post (200–500 words).** No headings. One thesis. One illustrating example or anecdote. A turn ("but…", "and yet…"). A closing line that compresses the argument. The whole post is one sustained move — opener, thesis, illustration, turn, close — with no diversions. Cut anything that isn't load-bearing. The voice in this mode is closer to a koan than an essay.

**Practical essay with framework (800–1,500 words).** Story or claim opener. A short framework — a 3- to 5-step sequence, a typology, or a set of principles — with each step or principle illustrated by an example, quote, or short case. Section heads optional. A numbered list within the post is permissible if each item is a *distinct artifact* the reader will reference; otherwise prose with anaphoric paragraph openings reads tighter. Close ties back to the opening story.

**Reflective long essay (1,000–2,500 words).** Often opens by referencing another writer's piece, news article, or cultural moment — quoted in a block quote and engaged with directly. Builds an argument across 5–10 paragraphs. Uses section breaks (`~~~` or H3 heads) to mark major pivots. Closes with a diagnosis or call to attention rather than a directive.

Default to whichever mode the substance fits. Don't pad a 300-word observation into 1,200, and don't compress a 1,500-word argument into a tweet thread.

**Theme density.** A useful sanity check across all three modes: aim for roughly 300–400 words per major theme. A post with three themes wants 1,000–1,200 words; a post with five themes wants closer to 1,800. If you're trying to cover eight themes in 1,300 words, you have a structural mismatch — either pace the post honestly as a listicle, compress to fewer themes, or split into separate posts. Half-arguing eight ideas is rarely better than fully-arguing two.

---

## Sentence and paragraph rhythm

- **Short paragraphs are the default.** One to four sentences. White space is part of the voice. Long paragraphs lose readers in this register faster than in technical writing.
- **Vary sentence length deliberately.** A long sentence (25–35 words) followed by a short one (5–10) lets the short one ring. Fragments are allowed; use them sparingly.
- **One-line paragraphs as turns or punches.** Use 2–4 across a longer post. Examples of the shape:
  - A reversal of the prior paragraph ("And then it stopped working.")
  - A flat claim that lands the thesis ("The shape is the substance.")
  - A short imperative or invitation ("Pick the small one first.")
- **Parallel structure for emphasis.** "What you measure, you tend. What you tend, you grow." Three is the magic number for parallel triads; two is fine when the contrast is the point.
- **Pivot connectives at the start of paragraphs.** "But." "And yet." "Then." "Now." "Here's the thing." Earn their place by marking actual hinges, not throat-clearing.
- **Lists are allowed when each item is a distinct artifact** — a step, a category, a principle. Avoid "reasons why" lists where prose with anaphora would be tighter.

---

## Diction

- **Plain English.** Concrete over abstract. "I made a list and crossed off three things" beats "I implemented a deprioritization framework."
- **Personal voice is welcome.** "I" can carry an essay; "you" addresses the reader directly and is a working tool, not a tic; "we" works for genuinely shared experience. Vary all three across the post.
- **No corporate vocabulary.** Eliminate: *leverage, synergize, dive deep, double-click, ecosystem, journey, learnings, deliverables, value-add, circle back, unpack, framework* (when used vaguely), *space* (as in "the productivity space").
- **No AI-essay tells.** Eliminate: *In today's rapidly evolving world, In our fast-paced world, It's important to note that, In the realm of, From X to Y, At the end of the day, X is not just Y — it's Z, This isn't just X; it's Y, Tapestry, Delve, Crucial, Pivotal, Furthermore, Moreover, In conclusion, In essence.*
- **No "It's about…" sentences.** "It's about being present" / "It's about courage" / "It's about showing up" read as inspirational filler. Replace with the specific thing being described.
- **Italics for emphasis are allowed** — more permissive than the technical voice. Use italics for the word the sentence turns on, the unexpected stress, or the conceptual hinge. Don't italicize whole phrases unless the phrase is the hinge. Don't italicize every fifth word.
- **Em-dashes ≤ 4 per post.** Two sub-rules: never where a period would do; never stacked in the same sentence. The em-dash is a strong AI-slop tell, so when in doubt, use a period or a colon.
- **No emoji. No exclamation points** (one per post maximum, only in dialogue or quoted material).

---

## Rhetorical moves to use (rationed)

Hit roughly **three or four of these per post**, not all of them. Picking too many makes the essay read like a checklist.

1. **Story opener.** A short concrete anecdote — historical, personal-if-true, or quoted — that sets up the question. Three or four sentences is plenty. Avoid stories that take 200 words to reach the point.
2. **Quote with a hinge.** Bring in one or two named authorities — a writer, a researcher, an investor, an artist — with a direct quote and citation. Add one line of commentary. Quotes are fuel, not filler. A post with five Famous Quotes is leaning on the speakers; a post with one well-chosen quote is using it. **Framework essays** (multi-section practical posts) can raise the budget to roughly one quote per major section, but at most one quote across the whole post may be from a classical or philosophical source. The rest should be modern, specific, and load-bearing.
3. **Specific particular.** Replace "many studies show" with a named study, a date, a place, a number. "A 2018 study at a midwestern university…" beats "studies have shown…" by an order of magnitude.
4. **Counterexample or limit case.** "But this stops working when…" / "There's a version of this that goes wrong, though, when…" Strengthens the thesis by showing where it doesn't apply.
5. **Direct address to the reader's objection.** "You might say…" or "It would be reasonable to ask…" Pivot to engage the doubt the thoughtful reader is having.
6. **Parallel-structure thesis or close.** "X is one moment. Y is every moment after." Compresses the argument into a portable shape.
7. **Aphorism at the close.** A single sentence that the reader can carry. Earned by the rest of the post, not pulled from a quote book.
8. **Self-correction or revision.** "I used to think X. I now think Y." Only when truthful.

## Rhetorical moves to avoid

- **Recycled philosopher quotes — and their modern equivalents.** If Marcus Aurelius, Seneca, Lao Tzu, the Stoics generally, or any single classical source is showing up across multiple posts in your corpus, you're leaning on stock-philosophy. The same rule applies to **modern-bestseller aphorisms** — the famous quotable line from any popular productivity or self-help book, the one that's already on a thousand Pinterest boards and in a hundred LinkedIn posts. Endorsed wisdom from a recognizable name does emotional work, not argumentative work. Each quote has to be the right one for *this* argument, not a wisdom-flavored garnish.
- **Hollow uplift closes.** "In the end, what matters is choosing love." / "Above all, never stop believing." / "Be the change you want to see." Replace with a specific, concrete close.
- **"Imagine you…" openers** that don't pay off in real explanatory work.
- **Vague "studies show…" claims** without source. Either name the study or drop the claim.
- **Listicles for their own sake.** A "5 ways to…" post that has 5 because the title said 5, not because the substance has 5 distinct moves.
- **Definition-first openings.** "Productivity is a state of focused attention applied to meaningful work…" Open with the thing the reader will remember instead.
- **Self-promotion in the body.** Footers with links to your book are fine; mid-essay reminders that you wrote the bestseller about this are not.
- **Stacked authority quotes.** Five quotes from five experts in the same post is leaning on the experts. Two is the budget; one is often better.

---

## Formatting

- **Block quotes** (`>`) for actual quotations from named sources. Don't use block quotes for emphasis on your own prose.
- **Inline links** for source attribution when the source is a piece on the web. Footnotes only when there's a real reason to push something out of the body.
- **Bold for inline category labels** (e.g., **THE WRITER**, **THE READER**, **THE PUBLISHER**) when the post has parallel sections that share a structure. Use sparingly — three labels, not eight.
- **Italics for emphasis** on the word or phrase that carries the weight of the sentence.
- **Section heads** length-aware (see structural template). Prefer H3 over H2 for inline structure. Use `~~~` or `***` between major movements when the structure is informal.
- **Numbered lists** allowed when items are distinct artifacts (steps, categories, principles). Each item should be 1–3 sentences. If it gets longer, prose paragraphs work better.

---

## Worked transformation

A draft paragraph in generic-life-blog voice:

> "In our fast-paced world, it's so easy to lose sight of what truly matters. We get caught up in the hustle and bustle, constantly chasing the next thing, the next achievement, the next milestone. But at the end of the day, what really matters isn't how much we accomplish. It's about being present, about cherishing the small moments, about choosing what fills our cup."

Rewritten in the target voice:

> Most weeks, I do too much. I say yes to four things and arrive at Friday remembering only one of them. The arithmetic isn't subtle: a calendar full of small commitments adds up to a year you can't account for. I keep relearning that the way through isn't doing the four things faster. It's saying no to three of them, and meaning the one that's left.

Notes on the rewrite: replaces three layers of inspirational hedging ("In our fast-paced world", "what really matters", "It's about…") with a specific personal observation grounded in a concrete number ("four things"), uses parallel structure ("the arithmetic isn't subtle"), and lands on a sharp pair-sentence ("saying no to three of them, and meaning the one that's left"). Same rough subject. Tenfold the voice.

---

## Drafting checklist

Run this before calling a draft done. Aim for at least 9 of 13.

- [ ] Title is short, specific, and either utility-promising or contrarian. Not a generic noun phrase.
- [ ] First sentence is a claim, a story-image, or a directly engaged source. Not setup or context.
- [ ] Thesis is stated plainly somewhere in the first 200 words.
- [ ] At least one specific particular: a name, a number, a date, a place. No vague "studies show" or "many people."
- [ ] Quote budget respected: ≤ 2 named authorities for standard essays, ≤ 1 per major section for framework essays. At most one classical or philosophical source per post; modern-bestseller aphorisms count toward the same limit.
- [ ] Italicized terms are used for hinges or earned emphasis, not for stress on every fifth word.
- [ ] No corporate filler vocabulary. No AI-essay tells. No "It's about…" sentences.
- [ ] Em-dashes ≤ 4 across the post; none stacked; none used where a period would do.
- [ ] At least one one-line paragraph functions as a turn or a punch.
- [ ] Closing paragraph lands on an imperative, an aphorism, or a parallel-structure summary. Not a question. Not hollow uplift.
- [ ] Length matches substance (200–500 aphoristic / 600–1,500 standard / 1,500–2,500 reflective). Padding cut, compression earned.
- [ ] Theme density is honest: roughly 300–400 words per major theme. Eight themes in 1,300 words is a listicle pretending to be an essay.
- [ ] Every personal anecdote is true. Every quote is real and cited. Every claim is checkable.

---

## Quick reference card

```
VOICE     warm peer thinking out loud, not a guru
LENGTH    200–500 (aphoristic) / 600–1,500 (standard) /
          1,500–2,500 (reflective)
OPENER    story, claim, or inherited frame — never setup
THESIS    plain language, often italicized or parallel
RHYTHM    short paragraphs; varied sentence length; punch one-liners
PIVOTS    italicized hinge words and "But." / "And yet." paragraphs
QUOTES    1–2 (essay) / ≤1 per section (framework); ≤1 classical
          source per post; modern bestseller aphorisms count too
HEADS     0–4 inline italic or H3, length-aware
CLOSE     imperative, aphorism, or parallel; never question; never
          hollow uplift
FORBID    recycled philosopher drops, "It's about" filler, vague
          "studies show", AI-essay tells, fabricated personal anecdotes
```
