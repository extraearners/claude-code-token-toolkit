# Stack These Together: Full Setup in 30 Minutes

Install in this exact order. Each tool is independent but the order matters for measurement — you want baseline data before adding anything.

---

## Step 1: Measure baseline (~5 min)

Install ccusage first. Run for at least one normal session before touching anything else.

```bash
npm install -g ccusage
ccusage report          # see your current weekly spend + token breakdown
```

Note your weekly output tokens and cost. This is your "before" number. Everything else measures against it.

---

## Step 2: Strip your CLAUDE.md (~20 min, one-time)

No install. Just edit.

```bash
# Audit first — see how bad it is
bash demos/benchmark_claudemd.sh /path/to/your/CLAUDE.md
```

Target: under 300 tokens (~400 words). Strip everything that falls into these three categories:

1. **Things Claude reads from the code** — file structure, framework choices, obvious conventions
2. **Process docs** — workflow descriptions, PR procedures, team norms
3. **Soft preferences** — anything you wouldn't block a merge over

Keep: hard constraints, explicit prohibitions, one-line rules that apply every session.

Run the audit script again after editing to confirm you hit the target.

**Why do this first:** CLAUDE.md tokens load on every single message. A 65% reduction here is permanent and compounds across every tool that follows.

---

## Step 3: Install Caveman (~2 min)

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

Activate at the start of each Claude Code session:

```
/caveman
```

Or say "caveman mode". The hooks auto-persist it across sessions once installed.

Run `ccusage report --compare` after one day to see your output token delta.

---

## Step 4: Install context-mode (~5 min)

```bash
git clone https://github.com/sgaabdu4/claude-code-tips ~/.claude/tips
```

Follow the README to set your line threshold (recommended: 200 lines). Any tool output above that threshold gets summarized before hitting context.

Test it: run a command that produces long output (`cat a-large-file.txt`) and watch the token count in ccusage. It should drop significantly vs. the same command without context-mode.

---

## Step 5: Install CBM (~10 min)

```bash
claude mcp add codebase-memory-mcp
```

First session in each project:

```
/cbm:index
```

This builds the knowledge graph. Takes 5–20 minutes depending on repo size. Pay the cost once; every session after reads from the graph.

After indexing, Claude will automatically query the graph instead of reading files. You'll see the `file read` tool calls drop significantly in your session logs.

---

## Verify the Stack

After running all four tools for one full week:

```bash
ccusage report --compare
```

Compare to your baseline from Step 1. You should see:

- **Output tokens**: −40–65% (Caveman)
- **Cache creates**: −50–80% (CLAUDE.md + context-mode + CBM combined)
- **Total cost**: −40–70% depending on your session mix

---

## The Cumulative Number

Based on community benchmarks across 15 controlled sessions using the full four-tool stack:

> **85–92% total token reduction** vs. vanilla Claude Code on a typical build session.

Your number will vary based on session type. Heavy-file sessions see bigger gains from context-mode and CBM. Output-heavy sessions see bigger gains from Caveman. CLAUDE.md optimization is always the highest ROI per minute spent.

---

## Quick Reference: What Each Tool Targets

| Tool | Install | What It Shrinks | When It Matters |
|------|---------|-----------------|-----------------|
| CLAUDE.md optimization | Manual edit | Cache creates (every message) | Always |
| Caveman | 2 min script | Output tokens | Every session |
| context-mode | 5 min clone | Cache creates (large outputs) | File/command-heavy sessions |
| CBM | 10 min + index | Cache creates (file reads) | Multi-session builds, large repos |

---

## Troubleshooting

**Caveman not activating:** Run `/caveman` explicitly in session. Check hooks installed in `~/.claude/hooks/`.

**context-mode summarizing things it shouldn't:** Lower the line threshold or toggle off for debugging: `context-mode off`.

**CBM index stale after refactor:** Run `/cbm:reindex`. Takes same time as initial index.

**ccusage showing no improvement:** Check one tool at a time. Run `ccusage report --compare` after each addition. One tool may not be wired correctly.
