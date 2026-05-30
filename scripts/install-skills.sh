#!/bin/bash
# =============================================================================
# install-skills.sh — Install Claude skills via symlinks
#
# Usage:
#   ./scripts/install-skills.sh [--global] [--project] [skill-name ...]
#   ./scripts/install-skills.sh --global           # install all skills globally
#   ./scripts/install-skills.sh --project          # install all into .claude/skills/
#   ./scripts/install-skills.sh --global code-review debugging  # specific skills
#   ./scripts/install-skills.sh --status           # show install status
# =============================================================================

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")/../dev-pm-skills" && pwd)"
GLOBAL_DIR="$HOME/.claude/skills"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)/.claude/skills"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    echo "Usage: $0 [--global|--project|--status] [skill-name ...]"
    echo ""
    echo "  --global          Install to ~/.claude/skills/ (all projects)"
    echo "  --project         Install to .claude/skills/ (this project only)"
    echo "  --status          Show what's installed vs available"
    echo "  [skill-name ...]  Optional: install specific skills only"
    exit 1
}

show_status() {
    echo ""
    echo "========================================"
    echo "  SKILL INSTALL STATUS"
    echo "========================================"

    echo ""
    echo -e "${CYAN}Available skills (dev-pm-skills/):${NC}"
    for dir in "$SKILLS_DIR"/*/; do
        name=$(basename "$dir")
        global_link="$GLOBAL_DIR/$name"
        project_link="$PROJECT_DIR/$name"

        global_status="${RED}not installed${NC}"
        project_status="${RED}not installed${NC}"

        if [ -L "$global_link" ]; then
            global_status="${GREEN}global symlink${NC}"
        elif [ -d "$global_link" ]; then
            global_status="${YELLOW}global copy (not symlink)${NC}"
        fi

        if [ -L "$project_link" ]; then
            project_status="${GREEN}project symlink${NC}"
        elif [ -d "$project_link" ]; then
            project_status="${YELLOW}project copy (not symlink)${NC}"
        fi

        echo -e "  $name"
        echo -e "    global:  $global_status"
        echo -e "    project: $project_status"
    done
    echo ""
}

install_skill() {
    local skill_name="$1"
    local target_dir="$2"
    local scope="$3"

    local src="$SKILLS_DIR/$skill_name"
    local dst="$target_dir/$skill_name"

    if [ ! -d "$src" ]; then
        echo -e "  ${RED}✗ Not found:${NC} $skill_name (no directory in dev-pm-skills/)"
        return 1
    fi

    mkdir -p "$target_dir"

    if [ -L "$dst" ]; then
        echo -e "  ${YELLOW}↻ Updating symlink:${NC} $skill_name → $scope"
        rm "$dst"
    elif [ -d "$dst" ]; then
        echo -e "  ${YELLOW}⚠ Real directory exists:${NC} $dst — skipping (remove manually to replace with symlink)"
        return 0
    fi

    ln -s "$src" "$dst"
    echo -e "  ${GREEN}✓ Linked:${NC} $skill_name → $dst"
}

# Parse args
if [ $# -eq 0 ]; then
    usage
fi

MODE=""
SKILL_FILTER=()

for arg in "$@"; do
    case "$arg" in
        --global)   MODE="global" ;;
        --project)  MODE="project" ;;
        --status)   show_status; exit 0 ;;
        --*)        echo "Unknown flag: $arg"; usage ;;
        *)          SKILL_FILTER+=("$arg") ;;
    esac
done

if [ -z "$MODE" ]; then
    echo -e "${RED}Error: specify --global or --project${NC}"
    usage
fi

TARGET_DIR="$GLOBAL_DIR"
SCOPE="~/.claude/skills/"
[ "$MODE" = "project" ] && TARGET_DIR="$PROJECT_DIR" && SCOPE=".claude/skills/"

echo ""
echo "========================================"
echo "  INSTALLING SKILLS → $SCOPE"
echo "========================================"
echo ""

if [ ${#SKILL_FILTER[@]} -eq 0 ]; then
    for dir in "$SKILLS_DIR"/*/; do
        skill=$(basename "$dir")
        install_skill "$skill" "$TARGET_DIR" "$SCOPE"
    done
else
    for skill in "${SKILL_FILTER[@]}"; do
        install_skill "$skill" "$TARGET_DIR" "$SCOPE"
    done
fi

echo ""
echo "Done. Run './scripts/install-skills.sh --status' to verify."
echo ""
