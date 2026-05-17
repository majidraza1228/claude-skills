#!/bin/bash
# =============================================================================
# audit-skills.sh — Audit Claude skills for common pattern violations
#
# Usage: ./scripts/audit-skills.sh [path-to-skills-directory]
#        Default: ./skills
# =============================================================================

set -euo pipefail

SKILLS_DIR="${1:-./skills}"
ISSUES=0
WARNINGS=0

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "  CLAUDE SKILL AUDIT"
echo "  Directory: $SKILLS_DIR"
echo "  Date: $(date '+%Y-%m-%d %H:%M')"
echo "========================================"

# ---- Pattern 1: Description Length ----
echo ""
echo -e "${CYAN}--- Pattern 1: Description Length (target: 150-300 chars) ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    # Extract description from YAML frontmatter
    desc=$(sed -n '/^---$/,/^---$/p' "$f" | grep -A50 'description:' | tail -n +1 | head -20)
    char_count=$(echo "$desc" | wc -c | tr -d ' ')

    if [ "$char_count" -lt 150 ]; then
        echo -e "  ${RED}✗ SHORT ($char_count chars):${NC} $f"
        ISSUES=$((ISSUES + 1))
    elif [ "$char_count" -gt 500 ]; then
        echo -e "  ${YELLOW}⚠ LONG ($char_count chars):${NC} $f"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "  ${GREEN}✓ OK ($char_count chars):${NC} $f"
    fi
done

# ---- Pattern 2: Exclusions in Body ----
echo ""
echo -e "${CYAN}--- Pattern 2: Exclusions in Body (should be in description) ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    # Check body (after frontmatter) for exclusion language
    body=$(sed '1,/^---$/d; 1,/^---$/d' "$f" 2>/dev/null || cat "$f")

    matches=$(echo "$body" | grep -niE 'do not use (this |for)|don.t use (this |for)|not intended for|should not be used for' || true)

    if [ -n "$matches" ]; then
        echo -e "  ${RED}✗ EXCLUSION IN BODY:${NC} $f"
        echo "$matches" | while read -r line; do
            echo -e "    ${YELLOW}→ $line${NC}"
        done
        ISSUES=$((ISSUES + 1))
    fi
done

# ---- Pattern 2b: Exclusions without redirects ----
echo ""
echo -e "${CYAN}--- Pattern 2b: Exclusions Without Redirects ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    desc=$(sed -n '/^---$/,/^---$/p' "$f")

    # Check if description has "do not" but no "instead" or "use /skills"
    has_exclusion=$(echo "$desc" | grep -iE 'do not|don.t' || true)
    has_redirect=$(echo "$desc" | grep -iE 'instead|use /skills|use /' || true)

    if [ -n "$has_exclusion" ] && [ -z "$has_redirect" ]; then
        echo -e "  ${RED}✗ EXCLUSION WITHOUT REDIRECT:${NC} $f"
        ISSUES=$((ISSUES + 1))
    fi
done

# ---- Pattern 3: Hedge Words ----
echo ""
echo -e "${CYAN}--- Pattern 3: Hedge Words in Instructions ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    body=$(sed '1,/^---$/d; 1,/^---$/d' "$f" 2>/dev/null || cat "$f")

    hedges=$(echo "$body" | grep -niE '\b(maybe|could you|might want|you might|consider|perhaps|if you get a chance|it would be nice)\b' || true)

    if [ -n "$hedges" ]; then
        echo -e "  ${YELLOW}⚠ HEDGE WORDS:${NC} $f"
        echo "$hedges" | head -3 | while read -r line; do
            echo -e "    ${YELLOW}→ $line${NC}"
        done
        WARNINGS=$((WARNINGS + 1))
    fi
done

# ---- Pattern 5: Missing Output Template ----
echo ""
echo -e "${CYAN}--- Pattern 5: Missing Output Template ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    body=$(sed '1,/^---$/d; 1,/^---$/d' "$f" 2>/dev/null || cat "$f")

    has_template=$(echo "$body" | grep -iE 'template|output format|output template|format every|exact structure|format:|## format' || true)

    if [ -z "$has_template" ]; then
        echo -e "  ${RED}✗ NO OUTPUT TEMPLATE:${NC} $f"
        ISSUES=$((ISSUES + 1))
    else
        echo -e "  ${GREEN}✓ Has template:${NC} $f"
    fi
done

# ---- Pattern 6: Missing Examples ----
echo ""
echo -e "${CYAN}--- Pattern 6: Missing Worked Examples ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    body=$(sed '1,/^---$/d; 1,/^---$/d' "$f" 2>/dev/null || cat "$f")

    has_example=$(echo "$body" | grep -iE 'example|worked example|INPUT:|OUTPUT:|BEFORE:|AFTER:' || true)

    if [ -z "$has_example" ]; then
        echo -e "  ${RED}✗ NO EXAMPLES:${NC} $f"
        ISSUES=$((ISSUES + 1))
    else
        echo -e "  ${GREEN}✓ Has examples:${NC} $f"
    fi
done

# ---- Pattern 7: Skill Length ----
echo ""
echo -e "${CYAN}--- Pattern 7: Skill Length (target: under 400 lines) ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    lines=$(wc -l < "$f" | tr -d ' ')

    if [ "$lines" -gt 500 ]; then
        echo -e "  ${RED}✗ TOO LONG ($lines lines):${NC} $f — SPLIT THIS SKILL"
        ISSUES=$((ISSUES + 1))
    elif [ "$lines" -gt 400 ]; then
        echo -e "  ${YELLOW}⚠ GETTING LONG ($lines lines):${NC} $f"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "  ${GREEN}✓ OK ($lines lines):${NC} $f"
    fi
done

# ---- Pattern 7b: Safety Rules Position ----
echo ""
echo -e "${CYAN}--- Pattern 7b: Safety Rules Position (should be in first 50 lines) ---${NC}"

find "$SKILLS_DIR" -name 'SKILL.md' | while read -r f; do
    safety_line=$(grep -niE 'NEVER|ALWAYS|safety|critical|danger|warning.*do not' "$f" | head -1 | cut -d: -f1)

    if [ -n "$safety_line" ] && [ "$safety_line" -gt 50 ]; then
        echo -e "  ${RED}✗ SAFETY RULES TOO LOW (line $safety_line):${NC} $f"
        ISSUES=$((ISSUES + 1))
    elif [ -n "$safety_line" ]; then
        echo -e "  ${GREEN}✓ Safety at line $safety_line:${NC} $f"
    fi
done

# ---- Summary ----
echo ""
echo "========================================"
echo "  SUMMARY"
echo "========================================"
echo -e "  ${RED}Issues (must fix):  $ISSUES${NC}"
echo -e "  ${YELLOW}Warnings (should fix): $WARNINGS${NC}"
echo ""

if [ "$ISSUES" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo -e "  ${GREEN}✓ All skills pass! Nice work.${NC}"
elif [ "$ISSUES" -eq 0 ]; then
    echo -e "  ${GREEN}✓ No critical issues. Clean up warnings when you can.${NC}"
else
    echo -e "  ${RED}✗ Fix the issues above before deploying.${NC}"
fi

echo ""
