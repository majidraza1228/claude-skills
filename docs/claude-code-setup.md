# Using This Playbook with Claude Code

Claude Code is the primary tool this playbook was built for. Skills work out of the box with zero format changes — SKILL.md is native.

---

## How Claude Code loads skills

Claude Code looks for skills in two locations:

| Scope | Path | When to use |
|-------|------|-------------|
| Global (all projects) | `~/.claude/skills/<skill-name>/SKILL.md` | Skills you use on every project |
| Project-local | `.claude/skills/<skill-name>/SKILL.md` | Skills specific to one repo |

Project-local skills take precedence over global ones when names collide.

---

## Install with the script (recommended)

The install script symlinks skills from this repo so any changes to source propagate automatically.

```bash
# Install all 24 skills globally
./scripts/install-skills.sh --global

# Install all skills for the current project only
./scripts/install-skills.sh --project

# Install specific skills globally
./scripts/install-skills.sh --global code-review security debugging

# Check what's installed vs. available
./scripts/install-skills.sh --status
```

---

## Install manually

```bash
# Global install — one skill
mkdir -p ~/.claude/skills/code-review
cp dev-pm-skills/code-review/SKILL.md ~/.claude/skills/code-review/SKILL.md

# Project-local install — one skill
mkdir -p .claude/skills/code-review
cp dev-pm-skills/code-review/SKILL.md .claude/skills/code-review/SKILL.md
```

---

## How to invoke a skill

Skills trigger from natural language — you don't need a slash command:

```
Review this PR for bugs and security issues.
```
```
Run a code review on the auth module.
```
```
/code-review  ← explicit slash command also works
```

The `description:` field in each SKILL.md tells Claude Code which phrases map to which skill. That's why Pattern 1 (descriptions ≥ 150 chars) matters — short descriptions mean the skill never triggers.

---

## The full skill list

| Skill | Invoke with |
|-------|-------------|
| `code-review` | "review my code", "check for bugs", `/code-review` |
| `debugging` | "help me debug", "why is this failing", `/debugging` |
| `security` | "security review", "check for vulnerabilities", `/security` |
| `tdd` | "write tests first", "TDD this", `/tdd` |
| `refactor` | "clean up this code", "refactor", `/refactor` |
| `performance` | "optimise this", "it's slow", `/performance` |
| `planning` | "break this into tasks", "plan this feature", `/planning` |
| `code-explain` | "explain this code", "what does this do", `/code-explain` |
| `api-design` | "design this API", "review the contract", `/api-design` |
| `sql` | "write this query", "optimise the SQL", `/sql` |
| `database-schema` | "design the schema", "create migration", `/database-schema` |
| `commit-message` | "write a commit message", `/commit-message` |
| `pr-description` | "write the PR description", `/pr-description` |
| `changelog` | "generate changelog", `/changelog` |
| `logging` | "add structured logging", `/logging` |
| `doc-generator` | "generate docs for this", `/doc-generator` |
| `sprint-planning` | "plan the sprint", "break into tasks", `/sprint-planning` |
| `ticket-writer` | "write a ticket", "create a Jira issue", `/ticket-writer` |
| `standup-writer` | "write my standup", "daily update", `/standup-writer` |
| `retro` | "run a retro", "post-mortem", `/retro` |
| `daily-checkin` | "check in", "submit my standup", `/daily-checkin` |
| `team-digest` | "team summary", "sprint status", `/team-digest` |

---

## No format changes needed

SKILL.md works natively in Claude Code. Keep the full YAML frontmatter — Claude Code reads it to route skills correctly:

```yaml
---
name: code-review
description: >
  Use this skill when reviewing pull requests, checking code quality,
  or looking for bugs. Triggers on 'review my PR', 'check for bugs'...
version: "1.0"
updated: "2026-05-30"
---
```

---

## Agent PM setup (daily-checkin + team-digest)

The agent PM system requires two template files at your project root:

```bash
# Copy templates to your project
cp templates/TEAM.md ./TEAM.md
cp templates/SPRINT.md ./SPRINT.md

# Install the two agent PM skills
./scripts/install-skills.sh --project daily-checkin team-digest
```

Fill in `SPRINT.md` with your tasks and owners. Then each dev runs:

```
/daily-checkin
```

And the morning digest runs as:

```
/team-digest
```

Or schedule it: `/schedule "run /team-digest at 9:30am every weekday"`
