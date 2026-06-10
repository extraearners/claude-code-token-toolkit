# Demos

One runnable script per tool. Each prints before/after token counts.

| Script | Tool | What It Measures |
|--------|------|-----------------|
| `benchmark_rtk.sh` | RTK | CLI output size before/after RTK filtering |
| `benchmark_caveman.sh` | Caveman | Claude output token count with/without skill |
| `benchmark_contextmode.sh` | context-mode | File-read token cost before/after sandboxing |
| `benchmark_cbm.sh` | CBM | File-read count cold vs. warm knowledge graph |
| `benchmark_claudemd.sh` | CLAUDE.md | Token count of your current CLAUDE.md |

**Run any script:** `bash demos/<script>.sh`

Scripts are written in Bash. Requirements: `claude` CLI, `ccusage` installed.
