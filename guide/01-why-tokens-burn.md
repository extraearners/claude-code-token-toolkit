# Why Claude Code Burns Tokens (And Why Your Bill Looks Like That)

Claude Code is priced on tokens — the chunks of text and data that flow in and out of the model on every exchange. The more tokens, the higher the bill. That part most people understand.

What most people don't understand is *where the tokens actually go*.

## The Four Buckets

Every Claude Code session draws from four token buckets, billed at very different rates:

| Bucket | What Goes Here | Cost (Sonnet 4.6) |
|--------|---------------|-------------------|
| **Input** | Your messages, file contents, command output | $3.00 / 1M tokens |
| **Output** | Claude's responses | $15.00 / 1M tokens |
| **Cache Create** | Context stored in Anthropic's cache for reuse | $3.75 / 1M tokens |
| **Cache Read** | Re-reading that cached context | $0.30 / 1M tokens |

Output tokens are the most expensive by far — 5× the input rate. But the real drain in a long Claude Code session isn't any single message. It's the *accumulating context* that gets re-loaded on every exchange.

## How Context Accumulates

Every time you send Claude Code a message, the model receives:

1. Your full CLAUDE.md (loaded fresh, every single time)
2. Any files it read earlier in the session
3. Every tool call it made — including the complete output of every bash command
4. Its own previous responses

By hour two of a build session, Claude Code isn't just processing your latest question. It's re-reading the last 30,000 tokens of conversation history, 50 lines of CLAUDE.md, and the full output of every `npm install` and test run it ran along the way.

This is why sessions that feel productive get expensive fast. It's not one big cost event — it's death by accumulation.

## What Prompt Caching Does (And Doesn't Do)

Anthropic's prompt caching is Claude Code's built-in cost control. When the same context block appears repeatedly, it gets stored and re-read at $0.30/MTok instead of $3.00/MTok — a 10× cost reduction on repeated input.

This is why a typical optimized Claude Code usage pattern shows ~96% of tokens as cache reads. The caching is working. But two things it doesn't help with:

1. **Output tokens** — every response Claude generates is billed at $15/MTok regardless. If Claude explains what it's doing in 300 words, that's about 225 output tokens, billed at over $0.003 per response. Multiply by 100 exchanges in a session and it adds up.

2. **Cache creates** — the first time a large block of context is loaded, it gets cached at $3.75/MTok. Your CLAUDE.md, every file Claude reads for the first time, every long command output — those are all cache creates. They're cheaper than raw input on repeat, but expensive on first load.

## The Three Levers

Once you see the four buckets, the optimization strategy becomes obvious:

**Lever 1: Shrink what gets loaded every message.**
Your CLAUDE.md is re-loaded on every single exchange. A 852-token CLAUDE.md costs 2.8× more per message than a 300-token one — before you've written a single line of code. Stripping it down is the highest-ROI, zero-tool change you can make.

**Lever 2: Stop output tokens from inflating.**
Claude Code defaults to being thorough: explaining reasoning, summarizing what it did, restating the question. Most of that prose is invisible overhead — you read the code, not the explanation. The Caveman skill rewrites Claude's output style to be maximally terse without losing technical accuracy. Output tokens drop 50–75% on prose-heavy responses.

**Lever 3: Stop large outputs from hitting the context window raw.**
When Claude reads a 500-line file or runs a noisy build command, the full output lands in context — even the parts that are irrelevant. Tools like context-mode intercept large outputs and return summaries, and Codebase Memory MCP replaces repeated file reads with a knowledge graph query. Instead of re-reading a 2,000-token file, Claude queries a graph node.

## What This Guide Covers

The next four sections cover the tools that target each lever, in the order you should install them:

1. **CLAUDE.md Optimization** — the zero-tool win (Lever 1)
2. **Caveman** — terse output, fewer output tokens (Lever 2)
3. **context-mode** — sandbox large outputs (Lever 3)
4. **Codebase Memory MCP** — replace file reads with graph queries (Lever 3)

Each section includes real before/after token counts from actual Claude Code sessions, the exact install steps, and a runnable demo script you can use to reproduce the benchmark.

By the end, you'll have a stack that produces 60–90% less token consumption on a typical build session — not a marketing estimate, but a number you can verify yourself with ccusage.
