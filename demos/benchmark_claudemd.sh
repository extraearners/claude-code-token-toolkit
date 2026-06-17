#!/usr/bin/env bash
# Benchmark: CLAUDE.md token cost
# Shows the token weight of your current CLAUDE.md — the zero-tool win
# Usage: bash demos/benchmark_claudemd.sh [path/to/CLAUDE.md]

set -euo pipefail

CLAUDE_MD="${1:-CLAUDE.md}"

if [[ ! -f "$CLAUDE_MD" ]]; then
  echo "Usage: $0 [path/to/CLAUDE.md]"
  echo "Example: $0 ~/myproject/CLAUDE.md"
  exit 1
fi

WORDS=$(wc -w < "$CLAUDE_MD")
CHARS=$(wc -c < "$CLAUDE_MD")
LINES=$(wc -l < "$CLAUDE_MD")
# Rough token estimate: ~0.75 tokens per word for English prose + code
TOKENS_EST=$(echo "scale=0; $WORDS * 75 / 100" | bc)

echo "=== CLAUDE.md Token Audit ==="
echo ""
echo "File:       $CLAUDE_MD"
echo "Lines:      $LINES"
echo "Words:      $WORDS"
echo "Characters: $CHARS"
echo "Est. tokens: ~$TOKENS_EST  (words × 0.75)"
echo ""

# Benchmark target: 300 tokens or less
TARGET=300
if (( TOKENS_EST > TARGET )); then
  EXCESS=$((TOKENS_EST - TARGET))
  echo "Status: OVER TARGET by ~$EXCESS tokens"
  echo "Action: Strip to essential rules only. Goal: <$TARGET tokens."
  echo "        Every excess token is loaded into EVERY Claude Code message."
else
  echo "Status: WITHIN TARGET (<$TARGET tokens). Good."
fi

echo ""
echo "Tip: The guide's Section 1 shows how to strip a 3,847-token CLAUDE.md"
echo "     to 312 tokens with zero quality regression."
