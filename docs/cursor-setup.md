# Using These Skills with Cursor

Cursor reads rules from `.cursor/rules/`. Each `.mdc` file in that directory becomes an always-on rule or a manually triggered rule depending on how you configure it.

---

## Setup

**Step 1:** Create `.cursor/rules/` in your repo root.

**Step 2:** Copy each skill as a `.mdc` file (Cursor's rule format):

```
.cursor/
  rules/
    code-review.mdc
    commit-message.mdc
    api-design.mdc
    security.mdc
    tdd.mdc
```

**Step 3:** Each `.mdc` file needs a small header that tells Cursor when to apply it:

```
---
description: Use when reviewing code, checking for bugs, or doing a code quality check
globs:
alwaysApply: false
---

# Code Review Skill

## Safety — Read First
...
(rest of SKILL.md body)
```

- `alwaysApply: true` → rule is always active (use for short global rules only)
- `alwaysApply: false` → rule activates when you reference it with `@code-review`

---

## How to Invoke a Skill

In Cursor Chat, reference the rule file:

```
@code-review Review this authentication module.
```

```
@security Is this input handling safe?
```

```
@tdd Write tests for the payment processor using TDD.
```

---

## Recommended Structure

Keep `alwaysApply: true` only for global constraints (short, < 50 lines). Use `alwaysApply: false` for all skill files so they don't bloat every request:

```
.cursor/rules/
  _global.mdc          ← alwaysApply: true  (coding standards, commit rules)
  code-review.mdc      ← alwaysApply: false
  commit-message.mdc   ← alwaysApply: false
  api-design.mdc       ← alwaysApply: false
  security.mdc         ← alwaysApply: false
  tdd.mdc              ← alwaysApply: false
```

---

## Format Adaptation

Replace the SKILL.md YAML frontmatter with Cursor's `.mdc` frontmatter:

**Before (SKILL.md):**
```yaml
---
name: security
description: >
  Use this skill when the user asks for a security review...
---
```

**After (.mdc):**
```yaml
---
description: Use when reviewing code for security issues, OWASP checks, or handling user input
globs:
alwaysApply: false
---
```

The `description` field in `.mdc` is what Cursor uses for `@mention` matching — keep it short and specific.

---

## What You Lose vs Claude Code

| Feature | Claude Code | Cursor |
|---|---|---|
| Auto-routing from natural language | Yes | Partial — `@mention` triggers |
| Trigger phrase matching | Yes | Description-based, less precise |
| Sub-skill routing | Yes | Separate `.mdc` files |
| Output templates | Yes | Yes — works as-is |
| Worked examples | Yes | Yes — works as-is |
