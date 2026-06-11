# Tool Breakdown: Caveman + CLAUDE.md Optimization

These two tools target your two biggest cost levers and cost nothing to run. Install both before touching anything else.

---

## Tool #1: Caveman

**What it does:** Rewrites Claude's own output to be maximally terse — shorter sentences, no filler, no explanatory prose you didn't ask for. Code output untouched. Only narrative responses compress.

**GitHub:** https://github.com/JuliusBrussee/caveman  
**Cost:** Free  
**Install time:** ~2 minutes

### Real Before/After

Measured across two consecutive Claude Code days (same project, same model — Sonnet 4.6):

| Day | Caveman | Output tokens | Session cost |
|-----|---------|--------------|--------------|
| Jun 9 (baseline) | OFF | 52,759 | $4.23 |
| Jun 10 (Caveman active) | ON | 27,794 | $3.96 |

**Output tokens down 47%.** Note: Jun 9 was a heavier session (scaffolding a full project + writing Linear issues), so this isn't a clean A/B. The honest range based on community benchmarks is 40–65% reduction on output prose across typical sessions.

What doesn't change: code blocks, tool call results, file content. Caveman only shrinks the conversational wrapper — the "here's what I'm doing" and "I'll now proceed to" text that pads every response but adds no value.

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

This wires Claude Code hooks, a stats tracker, and a status line badge automatically. No manual config needed.

### Activate

Start any Claude Code session and run:

```
/caveman
```

Or say "caveman mode" in the chat. Active for that session. Hooks keep it persistent across sessions once installed.

### Intensity levels

Three levels — `lite`, `full` (default), `ultra`. Full drops articles and filler. Ultra adds abbreviations and removes conjunctions. Start with full; drop to lite if you find it breaks your explanations.

```
/caveman lite    # tight but readable
/caveman full    # classic caveman (default)
/caveman ultra   # maximum compression
```

### Biggest limitation

Caveman only affects output tokens, which are ~0.67% of total session token volume in a well-optimized setup. If you're already running heavy prompt caching (cache reads >90% of your traffic), Caveman's absolute dollar impact is modest. On a $9/week spend, 47% output reduction saves roughly $1.50–$2.50/week — not transformative on its own, but it stacks with the other tools and compounds over months.

---

## Tool #2: CLAUDE.md Optimization

**What it does:** Shrinks your CLAUDE.md to the minimum that Claude actually needs. Every excess token in CLAUDE.md is loaded into every single message of every session — it's the highest-leverage, zero-dependency change you can make.

**Cost:** Free. No install. One hour of editing.  
**Impact:** Permanent — applies before any tool, every session.

### Real Before/After

Measured on an active project CLAUDE.md (`halle-b-pipeline`):

| Metric | Before | After target |
|--------|--------|-------------|
| Words | 1,136 | ~400 |
| Est. tokens | ~852 | ~300 |
| Reduction | — | ~65% |

At ~107,000 cache-create tokens per week (your baseline), a 65% CLAUDE.md reduction on every message materially cuts cache-create costs across every session, permanently.

### How to audit yours

```bash
# Clone this repo and run:
bash demos/benchmark_claudemd.sh /path/to/your/CLAUDE.md
```

Output shows current word count, estimated token count, and how far over the 300-token target you are.

### What to strip

Most bloated CLAUDE.md files contain three categories of dead weight:

**1. Things Claude already knows from the code**
Remove: file structure descriptions, "we use React" or "this is a Node project" — Claude reads the repo. Keep: constraints that aren't obvious from the code (e.g., "never use `var`", "all dates in UTC").

**2. Process descriptions that should be in issues**
Remove: multi-paragraph explanations of your workflow, team conventions, how PRs work. Keep: one-line rules that apply every session (e.g., "always run tests before committing").

**3. Aspirational rules you don't enforce**
If it's not a rule you'd stop a PR for, it doesn't belong in CLAUDE.md. Every soft preference loaded into context is tokens spent on guidance Claude will occasionally ignore anyway.

### Target format

```markdown
# [Project Name]

## Rules
- [hard constraint — one line]
- [hard constraint — one line]

## Stack
- [key tech only — what matters for how Claude should write code]

## Never
- [explicit prohibitions only]
```

Under 300 tokens. Claude doesn't need more than this to do good work — the codebase tells the rest of the story.

### Demo

```bash
bash demos/benchmark_claudemd.sh ~/your-project/CLAUDE.md
```

Run before and after editing to see your actual reduction.

---

## What These Two Tools Stack To

| Tool | Output token impact | Cache create impact | Est. weekly savings |
|------|--------------------|--------------------|---------------------|
| Caveman | −47% on output | None | ~$1–2/week |
| CLAUDE.md optimization | None on output | −65% on CLAUDE.md portion of cache creates | ~$1–2/week |
| **Combined** | | | **~$2–4/week on a $9 baseline** |

Next section covers context-mode and CBM — the tools that address cache creates from large file reads and command output, which are the remaining cost driver.
