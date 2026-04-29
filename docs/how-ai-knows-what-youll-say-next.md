---
title: "How AI Knows What You'll Say Next — Evan Sims"
header: "AI Doesn't Know. It Predicts."
byline: true
layout: blog
---

It's all next-token prediction.

When you talk to an AI assistant, the model isn't reasoning. It's guessing the next word, then the next, then the next. The whole impression of intent, of personality, of *understanding*, emerges from a chain of probabilistic choices made over a vast statistical map of human text.

That's the thesis. Now the mechanics.

A large language model is trained to predict the next word in a sequence. Given a partial sentence, it doesn't pick a single follow-up. It assigns probabilities to every word it knows, then samples from that distribution. That sampling step is why the same prompt can produce different outputs across runs. The model itself is deterministic; the randomness sits one layer up.

Training is the part that does the work. The model gets fed a colossal slice of the internet, including books, articles, code, and conversations, and is asked to predict, again and again, what comes next. Each prediction gets compared to the real continuation, and the model adjusts its internal parameters to be slightly less wrong next time. Trillions of examples, billions of parameter tweaks. To put the scale in perspective, GPT-3's training corpus is large enough that a single human reading it without sleeping or stopping would take roughly 2,600 years. Newer models train on substantially more.

Those parameters are the model. You can think of them as a few hundred billion tiny knobs that, taken together, encode a statistical sense of how language tends to continue. Initially the knobs are random and the output is gibberish. After enough training, the same knobs produce coherent prose.

The compute required is the part that's hard to feel. A machine doing a billion math operations per second would still need over a hundred million years to finish training a frontier LLM. The reason this is achievable in months instead is hardware: GPUs perform many of those operations in parallel, and modern data centers stack thousands of GPUs together to do far more than that.

Raw next-word prediction on internet text gives you a model that's fluent but not necessarily helpful. The "helpful" part comes from a second training phase, *reinforcement learning with human feedback*, where humans rate the model's responses and the model adjusts to favor the responses humans prefer. That's how the same underlying machinery becomes a useful assistant rather than a fluent rambler.

The architectural breakthrough is the Transformer, introduced by Google researchers in 2017. Earlier approaches read text one word at a time. Transformers process whole sentences, even paragraphs, in parallel. Each word becomes a vector, a list of numbers that captures its meaning. Then a mechanism called *attention* lets every vector influence every other one, so the meaning of any word gets refined by its context. This is how the model tells a financial bank from a riverbank: same word, different surrounding words, different vector.

The honest answer to "why did the model say that?" is that nobody fully knows. The behavior emerges from billions of parameters tuned by examples, none of which is individually responsible for any specific output. We can describe the architecture and the training. We can't fully read the result. That's a real limit, not a marketing one.

What the model is doing isn't magic. It also isn't trivial. It's pattern matching at a scale that crosses into something useful, and treating it as either thinking or as a parlor trick will lead you astray. The right frame is the one in the title. It doesn't know. It predicts. The rest is engineering, training data, and luck.
