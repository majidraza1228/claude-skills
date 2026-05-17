# Using These Skills with OpenAI Codex

Codex treats skills as **playbooks** — structured checklists and procedures it follows during task execution. No auto-routing; you reference skills explicitly in your task description.

---

## Setup

**Step 1:** Create a `.codex/` directory at the root of your repo.

**Step 2:** Create a `playbooks/` folder inside it:

```
.codex/
  instructions.md      ← global behavior + constraints (always loaded)
  playbooks/
    code-review.md
    commit-message.md
    api-design.md
    security.md
    tdd.md
```

**Step 3:** Strip the SKILL.md frontmatter and copy each skill into its playbook file:

```bash
# From your repo root:
for skill_dir in skills/*/; do
  skill_name=$(basename "$skill_dir")
  # Strip frontmatter (lines between --- markers) and copy
  awk '/^---/{n++; if(n==2){found=1; next}} found' "$skill_dir/SKILL.md" \
    > ".codex/playbooks/$skill_name.md"
done
```

---

## How to Invoke a Skill

Reference the playbook in your Codex task description:

```
Task: Review the authentication module for security issues.
Follow the procedure in .codex/playbooks/security.md
```

Or for TDD:
```
Task: Add tests for the UserService.create_user() method.
Follow the procedure in .codex/playbooks/tdd.md
```

---

## Global Instructions (`.codex/instructions.md`)

Put rules that apply to every task here — keep it short:

```markdown
# Repo Instructions

## Always
- Read existing code before writing new code
- Run tests after making changes
- Follow the commit message format in playbooks/commit-message.md

## Never
- Commit secrets or API keys
- Skip tests when adding business logic
- Force-push main
```

---

## Format Adaptation

Same as Copilot — strip the YAML frontmatter, keep the Markdown body.

The `description:` block becomes a comment at the top of the playbook if you want to document when to use it:

```markdown
<!-- Use when: user asks for a security review, OWASP check, or pastes
     code handling user input, auth, or API keys -->

# Security Review Skill
...
```

---

## What You Lose vs Claude Code

| Feature | Claude Code | Codex |
|---|---|---|
| Auto-routing | Yes | No — explicit in task |
| Description matching | Yes | No |
| Sub-skill routing | Yes | Manual reference |
| Output templates | Yes | Yes — works as-is |
| Worked examples | Yes | Yes — works as-is |
