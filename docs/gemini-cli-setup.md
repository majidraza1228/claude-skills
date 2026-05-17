# Using These Skills with Gemini CLI

Gemini CLI has native skill support via `gemini skills install` and reads global context from `GEMINI.md`. Skills map directly — the format is the closest to Claude's SKILL.md of any tool here.

---

## Option A: Native Skill Install (Recommended)

Gemini CLI can install skills directly from a local directory:

```bash
# Install all skills from this repo
gemini skills install ./skills/

# Or install a single skill
gemini skills install ./skills/code-review/
```

After install, skills auto-discover based on the `description:` frontmatter — similar to Claude Code.

**Invoke with:**
```
/code-review Review this authentication module.
/security Check this input handler for vulnerabilities.
/tdd Write tests for UserService.create_user() using TDD.
```

---

## Option B: GEMINI.md (Always-On Context)

Add skill content to `GEMINI.md` at your repo root for rules that should always be active:

```markdown
# GEMINI.md

## Commit Message Format
(paste commit-message/SKILL.md body — short skills only)

## Coding Standards
- Always write tests before implementation
- Never commit hardcoded secrets
```

Keep `GEMINI.md` under 200 lines — it loads into every session.

---

## Format Compatibility

Gemini CLI reads the same YAML frontmatter as Claude. **No format changes needed** for `name` and `description`:

```yaml
---
name: security
description: >
  Use this skill when the user asks for a security review...
---
```

This works as-is. Gemini uses `description:` for skill discovery, same as Claude.

---

## Project Structure After Install

```
your-repo/
  GEMINI.md                   ← global always-on context (short)
  .gemini/
    skills/                   ← installed skills (auto-managed)
      code-review/
        SKILL.md
      security/
        SKILL.md
      tdd/
        SKILL.md
```

---

## Syncing Updates

When you update a skill in this repo, reinstall to pick up changes:

```bash
gemini skills install ./skills/ --force
```

---

## What You Lose vs Claude Code

| Feature | Claude Code | Gemini CLI |
|---|---|---|
| Auto-routing | Yes | Yes (native skill install) |
| `description:` matching | Yes | Yes — same format |
| Sub-skill routing | Yes | Yes — separate SKILL.md files |
| Output templates | Yes | Yes — works as-is |
| Worked examples | Yes | Yes — works as-is |

Gemini CLI is the closest to Claude Code in terms of skill support — the main difference is the underlying model, not the skill format.
