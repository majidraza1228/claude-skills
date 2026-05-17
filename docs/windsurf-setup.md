# Using These Skills with Windsurf

Windsurf reads rules from `.windsurfrules` (global) and `.windsurf/rules/` (per-directory). Skills become **rules** that Cascade (Windsurf's agent) follows.

---

## Setup

**Option A: Single rules file (simple)**

Create `.windsurfrules` at the repo root and paste skill content directly:

```markdown
# Code Review Standards
(paste code-review/SKILL.md body)

# Commit Message Format
(paste commit-message/SKILL.md body)
```

**Limitation:** Same as Copilot — keep under 3 skills / ~300 lines or attention degrades.

---

**Option B: Per-directory rules (recommended)**

Windsurf also reads `.windsurfrules` files placed in subdirectories — they apply when Cascade is working in that folder.

```
your-repo/
  .windsurfrules              ← global: commit messages, coding standards
  src/
    .windsurfrules            ← code review + security rules (apply when in src/)
  tests/
    .windsurfrules            ← TDD rules (apply when in tests/)
```

This keeps each file short and focused.

---

## How to Invoke a Skill

Windsurf applies rules automatically based on the active directory. You can also prompt Cascade directly:

```
Follow the security review procedure and check this file for vulnerabilities.
```

```
Use TDD to add tests for this service. Write failing tests first.
```

Since there's no `@mention` routing, be explicit in your prompt about which procedure to follow.

---

## Format Adaptation

Strip the SKILL.md frontmatter — Windsurf rules are plain Markdown:

**Remove:**
```yaml
---
name: security
description: >
  Use this skill when...
---
```

**Keep everything after the second `---`** — the safety section, output template, examples, and rules all work as-is.

**Recommended: add a trigger comment at the top** so you remember when to use it:

```markdown
<!-- Apply when: security review, OWASP check, user input handling -->

# Security Review Skill
...
```

---

## Global vs Local Rules

| File location | When it applies |
|---|---|
| `/.windsurfrules` | Every session in this repo |
| `/src/.windsurfrules` | When Cascade works in `src/` |
| `/tests/.windsurfrules` | When Cascade works in `tests/` |

---

## What You Lose vs Claude Code

| Feature | Claude Code | Windsurf |
|---|---|---|
| Auto-routing by description | Yes | No — directory-based or manual |
| Trigger phrase matching | Yes | No |
| Sub-skill routing | Yes | Per-directory rules |
| Output templates | Yes | Yes — works as-is |
| Worked examples | Yes | Yes — works as-is |
