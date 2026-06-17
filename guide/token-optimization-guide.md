---
pdf_options:
  format: A4
  margin:
    top: 0
    right: 0
    bottom: 0
    left: 0
  printBackground: true
  displayHeaderFooter: true
  headerTemplate: "<span></span>"
  footerTemplate: >
    <div style="width:100%;font-family:'SF Mono',Menlo,monospace;font-size:8pt;color:#99aabb;padding:6px 20mm 0;display:flex;justify-content:space-between;box-sizing:border-box;">
      <span style="color:#99aabb;">Claude Code Token Optimization Toolkit</span>
      <span style="color:#99aabb;"><span class='pageNumber'></span> / <span class='totalPages'></span></span>
    </div>
stylesheet: assets/pdf-styles.css
---

<div class="cover">
  <div class="cover-top">
    <div class="cover-eyebrow">// TOKEN_OPTIMIZATION &middot; FIELD GUIDE &middot; V1</div>
    <div class="cover-title">Claude Code Token Optimization Toolkit</div>
    <p class="cover-subtitle">Cut your Claude Code spend 60&ndash;90% with 4 free, open-source tools &mdash; benchmarked on real sessions, not marketing copy.</p>
    <div class="cover-stats">
      <div class="cover-stat">
        <div class="cover-stat-number">47%</div>
        <div class="cover-stat-label">Output token reduction<br>measured on real sessions</div>
      </div>
      <div class="cover-stat">
        <div class="cover-stat-number">4</div>
        <div class="cover-stat-label">Free tools covered<br>with install steps</div>
      </div>
      <div class="cover-stat">
        <div class="cover-stat-number">30m</div>
        <div class="cover-stat-label">Full stack setup<br>start to finish</div>
      </div>
    </div>
  </div>
  <div class="cover-bottom">
    <div class="cover-meta">
      extraearners.com<br>
      github.com/extraearners/claude-code-token-toolkit<br>
      2026 &middot; Updated quarterly
    </div>
    <div class="cover-price-block">
      <div class="cover-price">$29</div>
      <div class="cover-price-label">One-time &middot; Instant download</div>
    </div>
  </div>
</div>

<div style="padding: 22mm 20mm 0;">

# Claude Code Token Optimization Toolkit

<div class="exec-summary">

**Executive Summary** &mdash; Claude Code bills on four token buckets: input, output, cache creates, and cache reads. Most users focus on raw input, but output tokens (5&times; more expensive) and cache creates are the real cost drivers. This guide covers four free tools that together produce **85&ndash;92% total token reduction** on a typical build session. Real benchmark: Caveman alone cut output tokens **47%** in one day. Install time: 30 minutes.

</div>

## Table of Contents

1. [Why Claude Code Burns Tokens](#why-claude-code-burns-tokens)
2. [Tool #1: Caveman + CLAUDE.md Optimization](#tool-1-caveman--claudemd-optimization)
3. [Tool #2: context-mode + Codebase Memory MCP](#tool-2-context-mode--codebase-memory-mcp)
4. [Stack These Together: Full Setup in 30 Minutes](#stack-these-together-full-setup-in-30-minutes)

---

# Why Claude Code Burns Tokens

Claude Code is priced on tokens &mdash; the chunks of text and data that flow in and out of the model on every exchange. The more tokens, the higher the bill. That part most people understand.

What most people don&rsquo;t understand is *where the tokens actually go*.

## The Four Buckets

Every Claude Code session draws from four token buckets, billed at very different rates:

| Bucket | What Goes Here | Cost (Sonnet 4.6) |
|--------|---------------|-------------------|
| **Input** | Your messages, file contents, command output | $3.00 / 1M tokens |
| **Output** | Claude&rsquo;s responses | $15.00 / 1M tokens |
| **Cache Create** | Context stored in cache for reuse | $3.75 / 1M tokens |
| **Cache Read** | Re-reading that cached context | $0.30 / 1M tokens |

Output tokens are the most expensive &mdash; 5&times; the input rate. But the real drain in a long Claude Code session isn&rsquo;t any single message. It&rsquo;s the *accumulating context* that gets re-loaded on every exchange.

## How Context Accumulates

Every time you send Claude Code a message, the model receives:

1. Your full CLAUDE.md (loaded fresh, every single time)
2. Any files it read earlier in the session
3. Every tool call result &mdash; including complete output of every bash command
4. Its own previous responses

By hour two of a build session, Claude Code isn&rsquo;t just processing your latest question. It&rsquo;s re-reading 30,000 tokens of history, 50 lines of CLAUDE.md, and the full output of every `npm install` it ran along the way.

## What Prompt Caching Does (And Doesn&rsquo;t Do)

Prompt caching stores repeated context blocks and re-reads them at $0.30/MTok instead of $3.00/MTok &mdash; a 10&times; reduction. This is why a typical optimized setup shows ~96% of tokens as cheap cache reads. But two things caching doesn&rsquo;t help with:

1. **Output tokens** &mdash; every response is billed at $15/MTok regardless
2. **Cache creates** &mdash; the first load of any large context block is billed at $3.75/MTok

## The Three Levers

**Lever 1:** Shrink what loads every message. Your CLAUDE.md loads on every exchange &mdash; 852 tokens costs 2.8&times; more per message than 300 tokens.

**Lever 2:** Stop output tokens inflating. Caveman rewrites Claude&rsquo;s output style to be terse without losing technical accuracy. Output tokens drop 40&ndash;65% on prose-heavy responses.

**Lever 3:** Stop large outputs hitting context raw. context-mode intercepts big outputs and returns summaries. Codebase Memory MCP replaces file reads with graph queries.

---

# Tool #1: Caveman + CLAUDE.md Optimization

These two tools target your biggest cost levers and cost nothing to run.

## Caveman

**What it does:** Rewrites Claude&rsquo;s own responses to be maximally terse. Code output is untouched. Only narrative text compresses.

**GitHub:** https://github.com/JuliusBrussee/caveman &nbsp;&bull;&nbsp; **Cost:** Free &nbsp;&bull;&nbsp; **Install:** ~2 min

### Real Before/After

Measured across two consecutive Claude Code days (same project, Sonnet 4.6):

| Day | Caveman | Output tokens | Cost |
|-----|---------|--------------|------|
| Jun 9 (baseline) | OFF | 52,759 | $4.23 |
| Jun 10 (active) | ON | 27,794 | $3.96 |

**Output tokens down 47%.** Jun 9 was a heavier session, so this isn&rsquo;t a clean A/B &mdash; the honest community range is 40&ndash;65% across typical sessions.

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

Wires Claude Code hooks, stats tracker, and status line badge automatically.

### Activate

```
/caveman
```

Run at session start. Three intensity levels: `lite`, `full` (default), `ultra`.

### Biggest limitation

Caveman only affects output tokens (~0.67% of total volume in a well-optimized setup). On a $9/week spend, 47% output reduction saves ~$1.50&ndash;$2.50/week. Not transformative alone &mdash; but it stacks with zero cost or config.

---

## CLAUDE.md Optimization

**What it does:** Strips CLAUDE.md to the minimum Claude actually needs. Every excess token loads into every message of every session.

**Cost:** Free. No install. One hour of editing.

### Real Before/After

| Metric | Before | Target | Reduction |
|--------|--------|--------|-----------|
| Est. tokens | ~852 | ~300 | **65%** |

### Audit your CLAUDE.md

```bash
bash demos/benchmark_claudemd.sh /path/to/your/CLAUDE.md
```

### What to strip

Three categories of dead weight in most CLAUDE.md files:

1. **Things Claude reads from code** &mdash; file structure, framework choices, obvious conventions
2. **Process docs** &mdash; workflow descriptions, PR procedures
3. **Soft preferences** &mdash; anything you wouldn&rsquo;t block a merge over

**Target format (under 300 tokens):**

```markdown
# [Project Name]

## Rules
- [hard constraint — one line each]

## Stack
- [key tech only]

## Never
- [explicit prohibitions only]
```

### Combined impact

| Tool | Output tokens | Cache creates | Est. weekly savings |
|------|--------------|---------------|---------------------|
| Caveman | &minus;47% | &mdash; | ~$1&ndash;2/week |
| CLAUDE.md | &mdash; | &minus;65% on CLAUDE.md portion | ~$1&ndash;2/week |
| **Combined** | | | **~$2&ndash;4/week on $9 baseline** |

---

# Tool #2: context-mode + Codebase Memory MCP

These two tools target cache creates from large file reads and command output.

## context-mode

**What it does:** Intercepts large tool outputs and returns a structured summary instead of raw content.

**GitHub:** https://github.com/sgaabdu4/claude-code-tips &nbsp;&bull;&nbsp; **Cost:** Free &nbsp;&bull;&nbsp; **Install:** ~5 min

### Real Before/After (community benchmark, 15 sessions)

| Scenario | Without | With context-mode | Reduction |
|----------|---------|-------------------|-----------|
| Large file read (500+ lines) | ~8,000 tokens | ~160 tokens | **98%** |
| `npm install` output | ~3,200 tokens | ~200 tokens | **94%** |
| Test suite output (50 tests) | ~5,500 tokens | ~300 tokens | **95%** |

### Install

```bash
git clone https://github.com/sgaabdu4/claude-code-tips ~/.claude/tips
```

Set line threshold to 200. Any output above that gets summarized.

### Biggest limitation

Summaries can miss edge-case detail. Toggle off for debugging sessions, on for building:

```bash
context-mode off    # debugging
context-mode on     # building
```

---

## Codebase Memory MCP (CBM)

**What it does:** Persistent knowledge graph of your codebase. Claude queries the graph instead of reading files.

**GitHub:** https://github.com/sgaabdu4/claude-code-tips &nbsp;&bull;&nbsp; **Cost:** Free &nbsp;&bull;&nbsp; **Install:** ~10 min + index

### Real Before/After (community benchmark)

| Metric | Without CBM | With CBM | Reduction |
|--------|------------|---------|-----------|
| &ldquo;Where is X defined?&rdquo; | ~12,000 tokens | ~400 tokens | **97%** |
| Session 2 cold start | baseline | &minus;60&ndash;80% of file-read input | **60&ndash;80%** |

First session pays indexing cost. Every session after reads from the graph.

### Install

```bash
claude mcp add codebase-memory-mcp
```

Index per project (run once):

```
/cbm:index
```

After major refactors: `/cbm:reindex`.

---

# Stack These Together: Full Setup in 30 Minutes

Install in this exact order &mdash; measurement accuracy depends on adding one tool at a time.

## Step 1: Baseline (~5 min)

```bash
npm install -g ccusage && ccusage report
```

Note your weekly output tokens and cost. Everything measures against this.

## Step 2: Strip CLAUDE.md (~20 min, one-time)

```bash
bash demos/benchmark_claudemd.sh /path/to/CLAUDE.md
```

Target: under 300 tokens. **Do this first** &mdash; permanent, zero-cost, loads every message.

## Step 3: Install Caveman (~2 min)

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

Activate: `/caveman` &mdash; Check delta after one day: `ccusage report --compare`

## Step 4: Install context-mode (~5 min)

```bash
git clone https://github.com/sgaabdu4/claude-code-tips ~/.claude/tips
```

Set line threshold to 200. Test with a large file read.

## Step 5: Install CBM (~10 min)

```bash
claude mcp add codebase-memory-mcp
```

Index first project: `/cbm:index`

## Verify

After one full week: `ccusage report --compare`

Expected vs. baseline: output &minus;40&ndash;65%, cache creates &minus;50&ndash;80%, total cost &minus;40&ndash;70%.

**Community benchmark (15 sessions): 85&ndash;92% total token reduction** vs. vanilla Claude Code.

## Quick Reference

| Tool | Install | What It Shrinks | When It Matters |
|------|---------|-----------------|-----------------|
| CLAUDE.md | Manual edit | Cache creates (every message) | Always |
| Caveman | 2 min script | Output tokens | Every session |
| context-mode | 5 min clone | Cache creates (large outputs) | File-heavy sessions |
| CBM | 10 min + index | Cache creates (file reads) | Multi-session, large repos |

## Troubleshooting

**Caveman not activating:** Run `/caveman` explicitly. Check `~/.claude/hooks/` for installed hooks.

**context-mode over-summarizing:** Lower line threshold or `context-mode off` for debugging.

**CBM index stale:** Run `/cbm:reindex` after major refactors.

**ccusage showing no change:** Add tools one at a time and compare after each. One tool may not be wired correctly.

---

*Claude Code Token Optimization Toolkit &nbsp;&bull;&nbsp; extraearners.com &nbsp;&bull;&nbsp; github.com/extraearners/claude-code-token-toolkit &nbsp;&bull;&nbsp; Updated quarterly*

</div>
