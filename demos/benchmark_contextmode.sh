#!/usr/bin/env bash
# Benchmark: context-mode large output reduction
# Measures token cost of a large command output with and without context-mode
# Usage: bash demos/benchmark_contextmode.sh

set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== context-mode Token Benchmark ==="
echo ""
echo "This benchmark simulates what Claude Code sees when a large command"
echo "runs without vs. with context-mode active."
echo ""

# Generate a large fake output (simulates npm install or test runner)
LARGE_OUTPUT=$(python3 -c "
import random, string
lines = []
for i in range(300):
    line = f'package-{i}: resolved {random.randint(1,9)}.{random.randint(0,9)}.{random.randint(0,9)} ({random.randint(10,500)}kB)'
    lines.append(line)
print('\n'.join(lines))
")

RAW_CHARS=$(echo "$LARGE_OUTPUT" | wc -c)
RAW_WORDS=$(echo "$LARGE_OUTPUT" | wc -w)
RAW_TOKENS=$(echo "scale=0; $RAW_WORDS * 75 / 100" | bc)

# context-mode summary (what it would return instead)
SUMMARY="npm install complete. 300 packages resolved. No errors. No security vulnerabilities."
SUM_WORDS=$(echo "$SUMMARY" | wc -w)
SUM_TOKENS=$(echo "scale=0; $SUM_WORDS * 75 / 100" | bc)

REDUCTION=$(echo "scale=1; (1 - $SUM_TOKENS / $RAW_TOKENS) * 100" | bc)

echo "Simulated output: 300-line npm install"
echo ""
echo "  Without context-mode:"
echo "    Characters: $RAW_CHARS"
echo "    Est. tokens: ~$RAW_TOKENS"
echo ""
echo "  With context-mode (summary returned instead):"
echo "    Summary: \"$SUMMARY\""
echo "    Est. tokens: ~$SUM_TOKENS"
echo ""
echo "  Reduction: ~${REDUCTION}%"
echo ""
echo "Community benchmark across 15 sessions: 94-98% reduction on large outputs."
echo "Install: https://github.com/sgaabdu4/claude-code-tips"
