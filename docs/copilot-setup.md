# Using These Skills with GitHub Copilot

Copilot doesn't have skill routing — it has no `description:` matching. Skills become **standing instructions** that are always active, or **prompt templates** you paste manually.

---

## Option A: Always-On (Recommended for 1–3 skills)

Add skill content directly to `.github/copilot-instructions.md` in your repo. Copilot reads this file automatically for every session.

**Step 1:** Strip the SKILL.md frontmatter (the `---` block at the top).

**Step 2:** Add to `.github/copilot-instructions.md`:

```markdown
# Code Review Standards
<!-- paste code-review/SKILL.md body here -->

# Commit Message Format
<!-- paste commit-message/SKILL.md body here -->
```

**Limitation:** If you add too many skills, the file grows large and Copilot's attention degrades — same as Pattern 7 in PATTERNS.md. Keep it under 3 skills or ~300 lines.

---

## Option B: Slash Commands (Recommended for many skills)

Store each skill as a separate file and load it manually when needed.

**Step 1:** Create `.github/skills/` in your repo.

**Step 2:** Copy each `SKILL.md` there, stripping the frontmatter:

```
.github/
  skills/
    code-review.md
    commit-message.md
    api-design.md
    security.md
    tdd.md
  copilot-instructions.md   ← global rules only (short)
```

**Step 3:** In Copilot Chat, load a skill by referencing the file:

```
#file:.github/skills/security.md Review this code for vulnerabilities.
```

**Step 4:** Or create a prompt template for each skill in VS Code:

Go to **Settings → Copilot → Custom Instructions** and add per-task instructions.

---

## Format Adaptation

Claude SKILL.md frontmatter is not understood by Copilot. Strip it before use:

**Claude format (remove this block):**
```yaml
---
name: code-review
description: >
  Use this skill when...
---
```

**Copilot format (what remains):**
```markdown
# Code Review Skill

## Safety — Read First
...
```

The rest of the skill (output templates, examples, rules) works as-is.

---

## What You Lose vs Claude Code

| Feature | Claude Code | Copilot |
|---|---|---|
| Auto-routing by description | Yes | No — manual file reference |
| Sub-skill splitting | Yes | No — load whole file |
| `description:` trigger phrases | Yes | Not applicable |
| Output templates | Yes | Yes — paste in context |
| Worked examples | Yes | Yes — paste in context |
