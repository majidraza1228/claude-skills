#!/bin/bash
# =============================================================================
# lint-skill.sh — CI-friendly skill linter (exits non-zero on failure)
#
# Usage: ./scripts/lint-skill.sh path/to/SKILL.md
#        ./scripts/lint-skill.sh path/to/skills/   (lint all skills in directory)
#
# Exit codes:
#   0 — All checks pass
#   1 — One or more checks failed
# =============================================================================

set -euo pipefail

TARGET="${1:-}"
ERRORS=0

if [ -z "$TARGET" ]; then
    echo "Usage: ./scripts/lint-skill.sh path/to/SKILL.md"
    echo "       ./scripts/lint-skill.sh path/to/skills/   (lint all)"
    exit 1
fi

lint_skill() {
    local f="$1"
    local skill_errors=0
    local name
    name=$(basename "$(dirname "$f")")

    echo "Linting: $f"

    # 1. Has YAML frontmatter
    if ! head -1 "$f" | grep -q '^---$'; then
        echo "  FAIL: Missing YAML frontmatter"
        skill_errors=$((skill_errors + 1))
    fi

    # 2. Description length
    local desc_len
    desc_len=$(sed -n '/^---$/,/^---$/p' "$f" | grep -A50 'description:' | wc -c | tr -d ' ')
    if [ "$desc_len" -lt 150 ]; then
        echo "  FAIL: Description too short ($desc_len chars, need ≥150)"
        skill_errors=$((skill_errors + 1))
    fi

    # 3. No exclusions in body without being in description
    local body
    body=$(sed '1,/^---$/d; 1,/^---$/d' "$f" 2>/dev/null || cat "$f")
    local body_exclusions
    body_exclusions=$(echo "$body" | grep -ciE 'do not use (this |for)|don.t use (this |for)' || true)
    if [ "$body_exclusions" -gt 0 ]; then
        echo "  FAIL: Found $body_exclusions exclusion(s) in body — move to description"
        skill_errors=$((skill_errors + 1))
    fi

    # 4. Has output template
    local has_template
    has_template=$(echo "$body" | grep -ciE 'template|output format|format every|exact structure|format:' || true)
    if [ "$has_template" -eq 0 ]; then
        echo "  WARN: No output template found"
    fi

    # 5. Has examples
    local has_example
    has_example=$(echo "$body" | grep -ciE 'example|INPUT:|OUTPUT:' || true)
    if [ "$has_example" -eq 0 ]; then
        echo "  WARN: No worked examples found"
    fi

    # 6. Line count
    local lines
    lines=$(wc -l < "$f" | tr -d ' ')
    if [ "$lines" -gt 500 ]; then
        echo "  FAIL: Too long ($lines lines, max 500) — split this skill"
        skill_errors=$((skill_errors + 1))
    fi

    # 7. Safety rules position
    local safety_line
    safety_line=$(grep -nE 'NEVER|ALWAYS' "$f" | head -1 | cut -d: -f1)
    if [ -n "$safety_line" ] && [ "$safety_line" -gt 50 ]; then
        echo "  WARN: Safety rules start at line $safety_line (recommend <50)"
    fi

    if [ "$skill_errors" -eq 0 ]; then
        echo "  ✓ PASS"
    else
        echo "  ✗ $skill_errors error(s)"
    fi

    ERRORS=$((ERRORS + skill_errors))
}

# Handle single file or directory
if [ -f "$TARGET" ]; then
    lint_skill "$TARGET"
elif [ -d "$TARGET" ]; then
    while IFS= read -r f; do
        lint_skill "$f"
        echo ""
    done < <(find "$TARGET" -name 'SKILL.md' -type f | sort)
else
    echo "Error: $TARGET is not a file or directory"
    exit 1
fi

echo "========================"
if [ "$ERRORS" -eq 0 ]; then
    echo "All checks passed ✓"
    exit 0
else
    echo "$ERRORS error(s) found ✗"
    exit 1
fi
