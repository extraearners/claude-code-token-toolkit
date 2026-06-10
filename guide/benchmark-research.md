# Token Optimization Benchmark Research
_PAS-30 deliverable — fill in YOUR numbers before writing the guide_

---

## Step 0: Establish Your Baseline with ccusage

Install first, measure for one week before adding any tools. This is the only way to get honest before/after numbers.

```bash
npm install -g ccusage
ccusage report        # daily/weekly totals
ccusage report --compare  # period-over-period delta (use this after each tool)
```

**Your baseline (from ccusage, weeks 2026-05-01 through 2026-06-08, 4 full weeks):**
- Weekly spend (USD): **$9.24/week avg** (range $6.56–$13.52; spike week was heavy Capafy build)
- Avg weekly output tokens: **~107,368/week** (429,470 total ÷ 4 full weeks)
- Avg weekly cache creates: **~553,640/week** (2,214,560 total ÷ 4 full weeks)
- Avg weekly cache reads: **~15,267,840/week** (already very high — caching is working)
- Raw input: **negligible** (9,957 total over 6 weeks — RTK won't move your needle)

**Token composition insight:** 95.8% of your tokens are cheap cache reads ($0.30/MTok).
Your cost drivers are: (1) output tokens ($15/MTok — Caveman targets this),
(2) cache creates ($3.75/MTok — CLAUDE.md optimization and context-mode target this).
Raw input is near-zero — skip RTK for V1.

---

## Tool Catalog — Claimed vs. Your Measured Reduction

### 1. RTK (Rust Token Killer)
**GitHub:** https://github.com/rtk-ai/rtk  
**What it does:** Intercepts every CLI command and compresses output before it reaches the context window. Filters noise from `npm install`, test runners, compiler output.  
**Claimed reduction:** 60–90% on CLI-heavy sessions  
**Best for:** Sessions with lots of bash commands, test runs, build output

**Install:**
```bash
# Install RTK binary
curl -fsSL https://rtk.sh/install | bash
# Add to CLAUDE.md or settings.json hook
```

| Metric | Before RTK | After RTK | Delta |
|--------|-----------|-----------|-------|
| Input tokens (CLI-heavy session) | | | |
| Session duration at same context | | | |
| ccusage weekly | | | |

**Your verdict:** _______________

---

### 2. Caveman
**GitHub:** https://github.com/juliusbrussee/caveman  
**What it does:** Claude Code skill that rewrites Claude's own output to be maximally terse ("why use many token when few do trick"). Affects prose responses, not code.  
**Claimed reduction:** 50–75% on output prose; real session impact ~4–5% of total tokens (prose is a small % of total)  
**Caveat:** Headline is 75% of output tokens; honest total session reduction is smaller. Still worth it at zero cost.

**Install:**
```bash
# Download skill file
curl -O https://raw.githubusercontent.com/juliusbrussee/caveman/main/caveman.md
# Drop in your Claude Code skills directory
```

| Metric | Before Caveman | After Caveman | Delta |
|--------|---------------|---------------|-------|
| Output tokens / session | | | |
| Total tokens / session | | | |
| Subjective: does it break explanations? | | | |

**Your verdict:** _______________

---

### 3. context-mode
**GitHub:** https://github.com/sgaabdu4/claude-code-tips (part of tips stack)  
**What it does:** Sandboxes large outputs (file reads, search results, build logs) and returns a summary instead of the raw content. Biggest win on sessions that read large files.  
**Claimed reduction:** ~98% on large file/output handling  
**Best for:** Codebases, file-heavy sessions

**Install:**
```bash
# Add context-mode skill to Claude Code
# Config in CLAUDE.md:
# Use context-mode for all file reads > 200 lines
```

| Metric | Before context-mode | After context-mode | Delta |
|--------|--------------------|--------------------|-------|
| Input tokens (file-read session) | | | |
| Largest single tool call output | | | |
| Session length at context limit | | | |

**Your verdict:** _______________

---

### 4. Codebase Memory MCP (CBM)
**GitHub:** https://github.com/sgaabdu4/claude-code-tips  
**What it does:** Replaces repeated file reads with a persistent knowledge graph of your codebase. Claude queries the graph instead of reading files fresh each message.  
**Claimed reduction:** ~99% on code discovery operations  
**Best for:** Large repos, multi-session builds (big win on session 2+)

**Install:**
```bash
# Add CBM MCP to claude_desktop_config.json
# First session: run /cbm:index to build the graph
# Subsequent sessions: Claude auto-queries instead of reading
```

| Metric | Before CBM | After CBM | Delta |
|--------|-----------|-----------|-------|
| Input tokens (codebase session, cold start) | | | |
| Input tokens (same session, 2nd run) | | | |
| File-read tool calls / session | | | |

**Your verdict:** _______________

---

### 5. Headroom (Optional — V2 candidate)
**GitHub:** https://github.com/headroom-ai/headroom  
**What it does:** API proxy between Claude Code and the Anthropic API. Compresses all payloads before they leave your machine.  
**Claimed reduction:** 47–92% API-level  
**Caveat:** Adds a proxy layer; some users report latency. Test carefully.

| Metric | Before Headroom | After Headroom | Delta |
|--------|----------------|----------------|-------|
| Total API tokens billed | | | |
| Session latency (subjective) | | | |

**Your verdict (include in V1 or defer to V2?):** _______________

---

### 6. CLAUDE.md Optimization (Zero-tool win)
**What it does:** Stripping a bloated CLAUDE.md from ~3,847 tokens to a lean ~312-token version cuts 91.9% of your always-loaded context — no tools required.  
**Claimed reduction:** 91.9% of initial context load (varies by your current CLAUDE.md size)  
**Effort:** 1 hour, permanent

**Benchmark:**
```bash
# Count tokens in your current CLAUDE.md:
cat CLAUDE.md | wc -w   # rough proxy (words ≈ 0.75x tokens)
# Or use: claude -p "count tokens in this text: $(cat CLAUDE.md)"
```

| Metric | Before | After |
|--------|--------|-------|
| CLAUDE.md word count | | |
| Estimated token count | | |
| First-message input tokens | | |

**Your verdict:** _______________

---

## Composite Stack Results

After running all 4 core tools together, measure again:

| Metric | Vanilla | Full Stack | Total Reduction |
|--------|---------|------------|-----------------|
| Avg input tokens / session | | | |
| Avg output tokens / session | | | |
| Session length at context limit | | | |
| Weekly spend ($) | | | |

**The number that goes on the cover:** ___% reduction in weekly spend

---

## V1 Core Tools (Final Pick)

After benchmarking, circle the 3–4 that produced the biggest measurable wins in YOUR sessions:

- [ ] RTK
- [ ] Caveman
- [ ] context-mode
- [ ] CBM
- [ ] CLAUDE.md optimization (always include — zero cost)
- [ ] Headroom (defer to V2 if latency is an issue)

**V1 stack:** _______________________________

---

## Source Notes

- RTK: https://github.com/rtk-ai/rtk
- Caveman: https://github.com/juliusbrussee/caveman
- Full stack reference: https://github.com/sgaabdu4/claude-code-tips
- 90% reduction case study: https://medium.com/@abdulgafoorabid/how-i-cut-claude-code-token-usage-by-90-with-4-tools-custom-hooks-and-enforcement-d3f8d2488cd6
- 10-repo roundup: https://medium.com/coding-nexus/10-github-repos-that-cut-claude-code-token-usage-by-60-90-b0105cec4081
