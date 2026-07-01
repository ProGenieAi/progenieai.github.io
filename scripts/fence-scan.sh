#!/usr/bin/env bash
# fence-scan.sh — ProGenie confidential-source leak guard
#
# Scans the working tree (or the files passed as arguments) for forbidden
# terms that would reveal our confidential source reference.
#
# Forbidden patterns (case-insensitive):
#   \bneo\b          — the source name as a whole word (does NOT match: neon, one, gone, etc.)
#   agents&me        — exact product name variant
#   agents and me    — spelled-out variant
#   agentsandme      — slug variant
#   tom even         — author name
#   \bcopy me\b      — the source's product name (whole-word)
#   no human in the loop — full phrase
#   nohuman          — slug variant
#
# Usage:
#   scripts/fence-scan.sh            # scans entire repo
#   scripts/fence-scan.sh file1 ...  # scans specific files
#
# Exit: 0 = clean, 1 = forbidden term found (prints file:line:content)
# ----------------------------------------------------------------------------------

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # no colour

FOUND=0

# Build grep pattern — single regex, alternation, case-insensitive
PATTERN='\bneo\b|agents&me|agents and me|agentsandme|tom even|\bcopy me\b|no human in the loop|nohuman|real.?estate|realtor|agentgenie|founding100|fiverr'

# Files to scan: args if given, else entire repo (tracked + untracked, excluding .git)
if [ "$#" -gt 0 ]; then
  FILES=("$@")
  SCAN_CMD=(grep -rnIi -E "$PATTERN" "${FILES[@]}")
else
  # In CI the whole checkout is the working dir; locally we run from repo root
  SCAN_CMD=(grep -rnIi -E "$PATTERN" \
    --exclude-dir='.git' \
    --exclude='*.sh' \
    .)
  # NOTE: we exclude the scan script itself so its own pattern list never self-triggers
fi

echo "fence-scan: scanning for confidential-source references..."

HITS=$("${SCAN_CMD[@]}" 2>/dev/null || true)

if [ -n "$HITS" ]; then
  echo -e "${RED}FENCE VIOLATION — confidential term detected:${NC}"
  echo "$HITS" | while IFS= read -r line; do
    echo -e "  ${YELLOW}${line}${NC}"
  done
  echo ""
  echo "Remove or rephrase the flagged content before pushing."
  exit 1
else
  echo "fence-scan: clean — no forbidden terms found."
  exit 0
fi
