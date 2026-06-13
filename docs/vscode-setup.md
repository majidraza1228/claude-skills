# Using This Playbook with VS Code

VS Code supports skills through three AI extensions: **GitHub Copilot**, **Cline**, and **Continue**. Each loads skills differently. Pick the one that matches your extension.

---

## Option A — GitHub Copilot (built-in to VS Code)

Copilot reads a single instructions file automatically. For larger skill sets, load skills on demand with `#file:` references in chat.

### Always-on (1–3 skills, ≤ 300 lines total)

Create `.github/copilot-instructions.md` in your repo root and paste skill bodies there (strip the YAML frontmatter):

```markdown
# Code Review Standards
[paste body of dev-pm-skills/code-review/SKILL.md here]

# Commit Message Format
[paste body of dev-pm-skills/commit-message/SKILL.md here]
```

Copilot loads this file on every request. Keep it short — past ~300 lines attention degrades (Pattern 7).

### On-demand (recommended for all 25 skills)

Export the skills to `.github/skills/`:

```bash
./scripts/export-skills.sh copilot
```

This strips frontmatter and writes each skill to `.github/skills/<name>.md`.

Then load a skill in Copilot Chat when you need it:

```
#file:.github/skills/code-review.md Review this authentication module.
```
```
#file:.github/skills/security.md Is this input handling safe?
```
```
#file:.github/skills/tdd.md Write tests for UserService first, then implement.
```

### Workspace instructions (VS Code settings)

For skills that should apply to all Copilot requests in a workspace:

1. Open **Settings** → search "Copilot Instructions"
2. Add skill content under **Copilot › Chat: Copilot Instructions**

---

## Option B — Cline

Cline reads rules from a `.clinerules` file at your project root.

### Setup

```bash
# Export skills to Cline format
./scripts/export-skills.sh cline   # if supported, else manual:

# Manual: create .clinerules with the skills you want always active
cat dev-pm-skills/code-review/SKILL.md | tail -n +6 >> .clinerules
```

Or add skills inline in Cline's **Custom Instructions** field in the extension settings (gear icon → Custom Instructions).

### On-demand

Paste a skill directly into the Cline chat input before your task:

```
[paste SKILL.md body]

---
Task: Review the payment module for security issues.
```

### MCP integration

Cline supports MCP servers. If you run a local MCP that serves skills, Cline can load them automatically — see [MCP docs](https://docs.anthropic.com/en/docs/agents-and-tools/mcp).

---

## Option C — Continue

Continue reads rules from `.continuerules` at your project root, or from the `system` field in `~/.continue/config.json`.

### Project-level rules

```bash
# Create .continuerules in your repo root
cat dev-pm-skills/security/SKILL.md | tail -n +6 > .continuerules
```

### Global config

Edit `~/.continue/config.json`:

```json
{
  "models": [...],
  "systemMessage": "[paste skill body here]"
}
```

### On-demand in chat

Type `/edit` or `/chat` and paste the skill body before your request. Continue also supports custom slash commands — add them in `~/.continue/config.json` under `"slashCommands"`.

---

## What each extension supports

| Feature | Copilot | Cline | Continue |
|---------|---------|-------|----------|
| Auto skill routing | No | No | No |
| Always-on instructions | `.github/copilot-instructions.md` | `.clinerules` | `.continuerules` |
| On-demand loading | `#file:` reference | Paste in chat | Paste in chat |
| Output templates | ✓ works as-is | ✓ works as-is | ✓ works as-is |
| Worked examples | ✓ works as-is | ✓ works as-is | ✓ works as-is |
| Agent PM skills | Manual | Manual | Manual |

VS Code extensions don't have Claude Code's description-based auto-routing. The skill content (output templates, safety rules, worked examples) works perfectly — you just load the skill manually instead of relying on trigger phrases.

---

## Quick comparison vs Claude Code

| | Claude Code | VS Code (any extension) |
|---|---|---|
| Skill format | SKILL.md native | Strip frontmatter |
| Routing | Automatic from natural language | Manual `#file:` or paste |
| Install script | `./scripts/install-skills.sh` | `./scripts/export-skills.sh copilot` |
| Agent PM (`/daily-checkin`) | Full support | Not supported |
| All 25 skills | Full support | Content works, routing manual |
