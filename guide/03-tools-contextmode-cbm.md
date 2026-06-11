# Tool Breakdown: context-mode + Codebase Memory MCP

These two tools target cache creates — what gets loaded into context when Claude reads files or processes large outputs. Together they address the second-largest cost driver after output tokens.

---

## Tool #3: context-mode

**What it does:** Intercepts large tool outputs — file reads, search results, build logs — and returns a compressed summary instead of the raw content. Claude still gets the information; your context window doesn't pay for 800 lines of `package-lock.json`.

**GitHub:** https://github.com/sgaabdu4/claude-code-tips  
**Cost:** Free  
**Install time:** ~5 minutes

### Real Before/After (community benchmark)

Measured by sgaabdu4 across 15 controlled Claude Code sessions:

| Scenario | Without context-mode | With context-mode | Reduction |
|----------|---------------------|-------------------|-----------|
| Large file read (500+ lines) | ~8,000 tokens | ~160 tokens | **98%** |
| `npm install` output | ~3,200 tokens | ~200 tokens | **94%** |
| Test suite output (50 tests) | ~5,500 tokens | ~300 tokens | **95%** |

Note: These are tool-output tokens, which feed into cache creates. The 98% figure is real — but only applies when a large output is what would have hit your context. On a session that reads mostly small files or has few bash commands, the impact is smaller.

### Install

```bash
# Clone the tips repo
git clone https://github.com/sgaabdu4/claude-code-tips ~/.claude/tips

# Add to your CLAUDE.md or Claude Code settings:
# Use context-mode for all tool outputs > 200 lines
```

Full config instructions at the repo's README. The key setting is the line threshold — outputs below the threshold pass through unchanged; outputs above get summarized.

### How it works

context-mode hooks into Claude Code's tool execution pipeline. When a bash command or file read returns more than the configured line threshold, context-mode intercepts the output, passes it through a local summarization step, and hands Claude a structured summary instead of the raw text.

Claude gets: "npm install succeeded, 847 packages, 3 peer dependency warnings (listed)."  
Context window gets: ~180 tokens instead of ~3,200.

### Biggest limitation

Summaries can miss edge-case details. If you're debugging a subtle issue buried in line 743 of a log file, you'll want to run without context-mode to see the raw output. Toggle off for debugging sessions; toggle on for building sessions.

```bash
# Disable for current session
context-mode off

# Re-enable
context-mode on
```

---

## Tool #4: Codebase Memory MCP (CBM)

**What it does:** Builds a persistent knowledge graph of your codebase. Instead of re-reading files from disk every session, Claude queries the graph — one graph lookup costs a fraction of a full file read.

**GitHub:** https://github.com/sgaabdu4/claude-code-tips (same repo, different module)  
**Cost:** Free  
**Install time:** ~10 minutes (plus first-run indexing: 5–20 min depending on codebase size)

### Real Before/After (community benchmark)

| Metric | Without CBM | With CBM (warm) | Reduction |
|--------|------------|-----------------|-----------|
| "Where is X defined?" | ~12,000 tokens (reads 8 files) | ~400 tokens (graph query) | **97%** |
| Session 2 cold start tokens | baseline | −60–80% of file-read input | **60–80%** |
| First session (indexing) | baseline | +20% (index cost amortized over future sessions) | — |

The big win is session 2+. First session pays an indexing cost. Every subsequent session reads from the graph — dramatically cheaper.

### Install

```bash
# Add CBM MCP to your Claude Code config:
claude mcp add codebase-memory-mcp

# First session in a new project — build the index:
/cbm:index

# Subsequent sessions — Claude auto-queries instead of reading files
```

### How it works

CBM indexes your codebase into a graph: nodes are files, functions, classes, and symbols; edges are imports, calls, and references. When Claude needs to find where `UserService` is defined, instead of opening files one by one, it queries: "node type=class name=UserService" and gets back the file path + line number in one small response.

For large codebases with many sessions, this is the highest-leverage tool in the stack.

### When it matters most

CBM pays off most on:
- **Multi-session builds** — the index persists across sessions; the cost is paid once
- **Large repos** (500+ files) — more files = more file reads Claude would otherwise do
- **Refactoring sessions** — lots of "where is X used?" queries

For small single-session scripts or notebooks, skip CBM. Indexing cost won't pay back.

### Biggest limitation

CBM index goes stale when code changes significantly. Run `/cbm:reindex` after major refactors. On fast-moving codebases, you'll reindex every few sessions — low cost, but worth knowing.

---

## What All Four Tools Stack To

| Tool | Primary target | Est. reduction on target |
|------|---------------|--------------------------|
| CLAUDE.md optimization | Cache creates (every message) | 65% |
| Caveman | Output tokens | 40–65% |
| context-mode | Cache creates (large outputs) | 94–98% |
| CBM | Cache creates (file reads, session 2+) | 60–97% |

Full stack measured result (community, 15-session average): **85–92% total token reduction** vs. vanilla Claude Code on a typical build session.

Next: the "Stack These Together" setup guide — exact install order and the one config that makes all four play nicely.
