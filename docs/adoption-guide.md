# Adoption Guide

Two paths. Pick yours.

- **[I want to use the playbook](#using-the-playbook)** — install skills and start triggering them
- **[I want to improve or build skills](#improving-or-building-skills)** — audit and fix existing SKILL.md files

---

## Using the Playbook

### Day 1 — Install and trigger your first skill

```bash
git clone https://github.com/majidraza1228/claude-skills.git
cd claude-skills
./scripts/install-skills.sh --global
```

Open Claude Code in any project and type:

```
review my code
```

That's it. The `code-review` skill fires and returns a structured review with a severity table. You didn't configure anything — the skill loaded because the description matched your phrase.

**Try 3 more to see the range:**

```
write a commit message          → formats your commit conventionally
plan this feature: user login   → breaks it into a task list with sizing
write a ticket for this bug     → produces a Jira-ready issue
```

### Day 2 — Pick your 5 daily skills

Don't install everything. Pick the 5 that match your daily pain:

**If you're a developer:**
`code-review`, `debugging`, `commit-message`, `tdd`, `planning`

**If you're a PM:**
`ticket-writer`, `sprint-planning`, `standup-writer`, `retro`, `team-digest`

**If you work across both:**
`code-review`, `ticket-writer`, `planning`, `commit-message`, `debugging`

Browse the full list at the [Skills Browser](https://majidraza1228.github.io/claude-skills/skills.html).

### Day 3 — Set up your tool if not using Claude Code

See the guide for your tool:

| Tool | Guide |
|---|---|
| VS Code + Copilot | [vscode-setup.md](vscode-setup.md) |
| Cursor | [cursor-setup.md](cursor-setup.md) |
| OpenAI Codex | [codex-setup.md](codex-setup.md) |
| Windsurf | [windsurf-setup.md](windsurf-setup.md) |
| Gemini CLI | [gemini-cli-setup.md](gemini-cli-setup.md) |

### Week 1 — Integrate into your real workflow

Skills pay off when they replace a habit, not when they're a separate step. Replace these:

| Old habit | Skill that replaces it |
|---|---|
| Writing a commit message from scratch | `commit-message` — type "write a commit message" |
| Opening a Jira template and filling it in | `ticket-writer` — describe the bug, get the ticket |
| Running a retro manually | `retro` — paste sprint notes, get the full format |
| Reviewing code without a checklist | `code-review` — type "review my code" |
| Planning a feature in your head | `planning` — describe the feature, get the task list |

---

## Improving or Building Skills

This section is for contributors who want to audit, fix, or create SKILL.md files.

### Before you start

Run the audit script to get a baseline:

```bash
./scripts/audit-skills.sh /path/to/your/skills
```

This reports:
- Descriptions that are too short (Pattern 1)
- Exclusions in the wrong place (Pattern 2)
- Missing output templates (Pattern 5)
- Skills that are too long (Pattern 7)

---

### Phase 1 — Audit (Day 1)

- [ ] Run `./scripts/audit-skills.sh` against your skills directory
- [ ] Save the output to `docs/audit-baseline.txt`
- [ ] Categorize findings: critical (safety rules buried), high (wrong skill triggers), medium (format drift), low (style)

**Time:** 1–2 hours

---

### Phase 2 — Descriptions and exclusions (Day 2–3)

**Descriptions (Pattern 1)**
- [ ] Expand every description under 150 characters to 150–300 characters
- [ ] Include 3–5 trigger phrases users actually say
- [ ] Include file types, languages, or domains covered

**Exclusions (Pattern 2)**
- [ ] Move every "do not use for X" from the skill body into the description
- [ ] Add "use /skills/X instead" redirect for each exclusion

**Tone (Pattern 3)**
- [ ] Replace hedge words (maybe, could, might, consider) with imperatives (Flag, List, Output, Return)

**Time:** 2–4 hours

---

### Phase 3 — Templates and examples (Day 4–5)

**Output templates (Pattern 5)**
- [ ] Define the exact output structure for each skill
- [ ] Use `{placeholder}` syntax for variable fields
- [ ] Place the template in the first 200 lines

**Worked examples (Pattern 6)**
- [ ] Write 1–2 input/output examples per skill
- [ ] Place examples before the rules, not after

**Source tables (Pattern 4)**
- [ ] Replace vague "check relevant files" with Source / Path / What to Extract tables

**Time:** 3–5 hours

---

### Phase 4 — Split and restructure (Day 6–7)

**Split long skills (Pattern 7)**
- [ ] List skills over 400 lines: `find skills/ -name 'SKILL.md' | xargs wc -l | sort -rn`
- [ ] Split into focused sub-skills, each under 300 lines
- [ ] Move safety-critical rules to lines 1–50

**Time:** 3–5 hours

---

### Phase 5 — Validate (Day 8+)

- [ ] For each skill: run the same prompt 3 times — output structure should be identical
- [ ] For each skill: write 3 prompts that should trigger it and 2 that shouldn't
- [ ] Add `./scripts/lint-skill.sh` to CI

Use the [checklist](checklist.md) for a per-skill audit template.

**Time:** 4–8 hours initially, then 30 min/month ongoing

---

### Effort summary

| Phase | Patterns | Effort | Impact |
|-------|----------|--------|--------|
| Audit | All | 1–2h | Baseline |
| Descriptions | 1, 2, 3 | 2–4h | High — fixes routing |
| Templates | 4, 5, 6 | 3–5h | High — fixes consistency |
| Restructure | 7 | 3–5h | Critical — fixes safety |
| Validate | All | 4–8h | Proves it works |
