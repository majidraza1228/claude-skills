#!/bin/bash
# export-skills.sh
# Converts SKILL.md files to the format required by each tool.
#
# Usage:
#   ./scripts/export-skills.sh copilot   → outputs to .github/skills/
#   ./scripts/export-skills.sh codex     → outputs to .codex/playbooks/
#   ./scripts/export-skills.sh cursor    → outputs to .cursor/rules/
#   ./scripts/export-skills.sh windsurf  → outputs to .windsurf/rules/
#   ./scripts/export-skills.sh gemini    → outputs to .gemini/skills/ (copy only)
#   ./scripts/export-skills.sh all       → runs all of the above

SKILLS_DIR="$(cd "$(dirname "$0")/.." && pwd)/dev-pm-skills"
TARGET="$1"

# Strip YAML frontmatter (content between first and second --- markers)
strip_frontmatter() {
  awk 'BEGIN{n=0} /^---/{n++; if(n==2){found=1; next}} found' "$1"
}

# Extract description from frontmatter (handles multi-line block scalar: description: >)
get_description() {
  awk '
    /^---/{ n++; if(n==2) exit }
    /^description:/{
      if($0 ~ /description: *>/) { in_desc=1; next }
      sub(/^description: */, ""); printf "%s", $0; exit
    }
    in_desc && /^  /{ sub(/^  /, ""); printf "%s ", $0; next }
    in_desc && !/^  /{ exit }
  ' "$1" | sed 's/ $//'
}

export_copilot() {
  echo "==> Exporting for GitHub Copilot → .github/skills/"
  mkdir -p .github/skills
  for skill_dir in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill_dir")
    src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue
    strip_frontmatter "$src" > ".github/skills/$name.md"
    echo "    wrote .github/skills/$name.md"
  done
  echo ""
  echo "Usage in Copilot Chat:"
  echo "  #file:.github/skills/security.md Review this code for vulnerabilities."
}

export_codex() {
  echo "==> Exporting for OpenAI Codex → .codex/playbooks/"
  mkdir -p .codex/playbooks
  for skill_dir in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill_dir")
    src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue
    desc=$(get_description "$src")
    {
      echo "<!-- Use when: $desc -->"
      echo ""
      strip_frontmatter "$src"
    } > ".codex/playbooks/$name.md"
    echo "    wrote .codex/playbooks/$name.md"
  done
  echo ""
  echo "Usage in Codex task:"
  echo "  Follow the procedure in .codex/playbooks/security.md"
}

export_cursor() {
  echo "==> Exporting for Cursor → .cursor/rules/"
  mkdir -p .cursor/rules
  for skill_dir in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill_dir")
    src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue
    desc=$(get_description "$src")
    # Use first 120 chars of description for Cursor's description field
    short_desc=$(echo "$desc" | cut -c1-120)
    {
      echo "---"
      echo "description: $short_desc"
      echo "globs:"
      echo "alwaysApply: false"
      echo "---"
      echo ""
      strip_frontmatter "$src"
    } > ".cursor/rules/$name.mdc"
    echo "    wrote .cursor/rules/$name.mdc"
  done
  echo ""
  echo "Usage in Cursor Chat:"
  echo "  @security Check this code for vulnerabilities."
}

export_windsurf() {
  echo "==> Exporting for Windsurf → .windsurf/rules/"
  mkdir -p .windsurf/rules
  for skill_dir in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill_dir")
    src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue
    desc=$(get_description "$src")
    {
      echo "<!-- Apply when: $desc -->"
      echo ""
      strip_frontmatter "$src"
    } > ".windsurf/rules/$name.md"
    echo "    wrote .windsurf/rules/$name.md"
  done
  echo ""
  echo "Load a rule in Windsurf by prompting Cascade:"
  echo "  Follow the security review procedure and check this file."
}

export_gemini() {
  echo "==> Exporting for Gemini CLI → .gemini/skills/"
  mkdir -p .gemini/skills
  for skill_dir in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill_dir")
    src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue
    mkdir -p ".gemini/skills/$name"
    cp "$src" ".gemini/skills/$name/SKILL.md"
    echo "    wrote .gemini/skills/$name/SKILL.md"
  done
  echo ""
  echo "Then run: gemini skills install .gemini/skills/"
  echo "Invoke with: /security Check this code."
}

case "$TARGET" in
  copilot)  export_copilot ;;
  codex)    export_codex ;;
  cursor)   export_cursor ;;
  windsurf) export_windsurf ;;
  gemini)   export_gemini ;;
  all)
    export_copilot; echo ""
    export_codex; echo ""
    export_cursor; echo ""
    export_windsurf; echo ""
    export_gemini
    ;;
  *)
    echo "Usage: $0 {copilot|codex|cursor|windsurf|gemini|all}"
    echo ""
    echo "Exports SKILL.md files to the format required by each AI coding tool."
    echo "Run from your repo root."
    exit 1
    ;;
esac

echo ""
echo "Done. See docs/<tool>-setup.md for usage instructions."
