#!/bin/bash
# =============================================================================
# test-consistency.sh — Test a skill for output format consistency
#
# This script helps you manually verify Pattern 5 (format drift).
# It generates test prompts you can run 3x each, then compare outputs.
#
# Usage: ./scripts/test-consistency.sh [path-to-SKILL.md]
# =============================================================================

set -euo pipefail

SKILL_FILE="${1:-}"

if [ -z "$SKILL_FILE" ]; then
    echo "Usage: ./scripts/test-consistency.sh path/to/SKILL.md"
    echo ""
    echo "This script analyzes a skill and generates test prompts."
    echo "Run each prompt 3 times and compare the output structure."
    exit 1
fi

if [ ! -f "$SKILL_FILE" ]; then
    echo "Error: File not found: $SKILL_FILE"
    exit 1
fi

SKILL_NAME=$(sed -n '/^name:/s/^name: *//p' "$SKILL_FILE" | head -1)

echo ""
echo "========================================"
echo "  CONSISTENCY TEST GENERATOR"
echo "  Skill: ${SKILL_NAME:-$(basename "$(dirname "$SKILL_FILE")")}"
echo "  File: $SKILL_FILE"
echo "========================================"

# Check for output template
echo ""
echo "--- Template Check ---"
HAS_TEMPLATE=$(grep -ciE 'template|output format|format every|exact structure' "$SKILL_FILE" || true)

if [ "$HAS_TEMPLATE" -eq 0 ]; then
    echo "⚠️  WARNING: No output template found in this skill."
    echo "   This skill is likely to produce inconsistent formats."
    echo "   → Add an output template (see PATTERNS.md, Pattern 5)"
    echo ""
fi

# Check for examples
HAS_EXAMPLES=$(grep -ciE 'example|INPUT:|OUTPUT:' "$SKILL_FILE" || true)
if [ "$HAS_EXAMPLES" -eq 0 ]; then
    echo "⚠️  WARNING: No worked examples found in this skill."
    echo "   → Add 1-2 input/output examples (see PATTERNS.md, Pattern 6)"
    echo ""
fi

# Generate test instructions
echo ""
echo "--- Test Instructions ---"
echo ""
echo "Run each of the following prompts 3 TIMES in separate sessions."
echo "After each run, save the output to a file."
echo "Then diff the outputs to check if the structure matches."
echo ""
echo "Test 1 — Basic trigger:"
echo "  Prompt: Use the ${SKILL_NAME:-skill} on a simple, typical input."
echo "  Save to: test1_run{1,2,3}.txt"
echo ""
echo "Test 2 — Edge case:"
echo "  Prompt: Use the ${SKILL_NAME:-skill} on a complex or unusual input."
echo "  Save to: test2_run{1,2,3}.txt"
echo ""
echo "Test 3 — Minimal input:"
echo "  Prompt: Use the ${SKILL_NAME:-skill} with the smallest valid input."
echo "  Save to: test3_run{1,2,3}.txt"
echo ""
echo "--- Comparison ---"
echo ""
echo "After running all 9 tests, compare structure (not content):"
echo ""
echo "  # Extract just headers and table structures"
echo "  grep -E '^#+|^\|' test1_run1.txt > test1_structure1.txt"
echo "  grep -E '^#+|^\|' test1_run2.txt > test1_structure2.txt"
echo "  diff test1_structure1.txt test1_structure2.txt"
echo ""
echo "If the diff is empty, the structure is consistent. ✓"
echo "If it differs, you need a stronger output template."
echo ""
