# Claude Skill Patterns

**7 battle-tested patterns for writing AI skills that work consistently — across Claude, Copilot, Codex, Cursor, Windsurf, and Gemini CLI.**

Built from 75+ tests across real skill implementations. Every pattern here solves a specific failure mode — skills that don't trigger, output that drifts between runs, safety rules that never fire.

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/majidraza1228/Calude-skills.git
cd Calude-skills

# 2. Audit your existing skills
./scripts/audit-skills.sh /path/to/your/skills

# 3. Copy a starter skill
cp dev-pm-skills/code-review/SKILL.md /path/to/your/skills/my-new-skill/SKILL.md

# 4. Export to your tool of choice
./scripts/export-skills.sh all   # or: copilot | codex | cursor | windsurf | gemini
```

## The 7 Patterns

| # | Pattern | Failure It Prevents |
|---|---------|-------------------|
| 1 | [Descriptions ≥ 150 chars](PATTERNS.md#pattern-1-descriptions-under-100-characters-stay-invisible) | Skill never triggers |
| 2 | [Exclusions in description with redirects](PATTERNS.md#pattern-2-exclusions-belong-in-the-description) | Wrong skill loads |
| 3 | [Direct tone in instructions](PATTERNS.md#pattern-3-claude-mirrors-your-instruction-tone) | Vague, hedging output |
| 4 | [Three-column source tables](PATTERNS.md#pattern-4-three-column-tables-beat-check-the-relevant-files) | Missing or wrong data |
| 5 | [Output templates](PATTERNS.md#pattern-5-without-an-output-template-formats-drift) | Format changes every run |
| 6 | [Worked examples over rules](PATTERNS.md#pattern-6-one-example-beats-five-rules) | Inconsistent structure |
| 7 | [Skills under 500 lines](PATTERNS.md#pattern-7-skills-over-500-lines-drop-their-bottom-half) | Bottom-half instructions ignored |

## Included Skills

### Daily Development Workflow

| Skill | What It Does |
|-------|-------------|
| [planning](dev-pm-skills/planning/SKILL.md) | Break features into tasks with done criteria and dependencies |
| [code-explain](dev-pm-skills/code-explain/SKILL.md) | Explain unfamiliar code, algorithms, or regex at the right depth |
| [debugging](dev-pm-skills/debugging/SKILL.md) | 5-step bug triage: reproduce → localize → reduce → fix → guard |
| [refactor](dev-pm-skills/refactor/SKILL.md) | Simplify code without changing behavior (Chesterton's Fence rule) |
| [performance](dev-pm-skills/performance/SKILL.md) | Measure-first optimization: N+1 queries, caching, profiling |

### Code Quality & Review

| Skill | What It Does |
|-------|-------------|
| [code-review](dev-pm-skills/code-review/SKILL.md) | Structured review with severity table (CRITICAL/WARNING/NIT) and verdict |
| [security](dev-pm-skills/security/SKILL.md) | OWASP Top 10 security review — flags critical issues before merge |
| [tdd](dev-pm-skills/tdd/SKILL.md) | Red-green-refactor TDD with test pyramid and worked examples |

### Git & Release

| Skill | What It Does |
|-------|-------------|
| [commit-message](dev-pm-skills/commit-message/SKILL.md) | Conventional commit formatting with worked examples |
| [pr-description](dev-pm-skills/pr-description/SKILL.md) | PR body with what/why, test steps, and reviewer notes |
| [changelog](dev-pm-skills/changelog/SKILL.md) | Keep a Changelog format from commit list or git log |

### Data & APIs

| Skill | What It Does |
|-------|-------------|
| [api-design](dev-pm-skills/api-design/SKILL.md) | Contract-first API design with breaking change assessment |
| [sql](dev-pm-skills/sql/SKILL.md) | Write and optimize SQL queries safely (with guards for DELETE/UPDATE) |
| [database-schema](dev-pm-skills/database-schema/SKILL.md) | Schema design with migration + rollback scripts |

### Agent-Driven Project Management

No PM needed. Developers check into a shared `TEAM.md`. Agents handle the rest.

| Skill | What It Does |
|-------|-------------|
| [daily-checkin](dev-pm-skills/daily-checkin/SKILL.md) | Dev runs this once a day — agent reads git log + sprint board, writes structured entry to `TEAM.md` |
| [team-digest](dev-pm-skills/team-digest/SKILL.md) | Reads `TEAM.md` + `SPRINT.md`, produces team summary, sprint velocity, and blocker table |

**How to set up:**
1. Copy `templates/TEAM.md` and `templates/SPRINT.md` to your project root
2. Fill in `SPRINT.md` with your tasks and owners
3. Each dev runs `/daily-checkin` — takes 30 seconds
4. Run `/team-digest` any time (or schedule it at 9:30am via `/schedule`)

### Developer Workflow (manual tickets + retros)

| Skill | What It Does |
|-------|-------------|
| [sprint-planning](dev-pm-skills/sprint-planning/SKILL.md) | Break a feature or milestone into sprint tasks with sizing, priority, dependencies, and risks |
| [ticket-writer](dev-pm-skills/ticket-writer/SKILL.md) | Turn rough notes into a well-formed Jira/Linear/GitHub Issue with AC, technical notes, and scope |
| [standup-writer](dev-pm-skills/standup-writer/SKILL.md) | Write daily or weekly standup updates from git log, task list, or rough notes |
| [retro](dev-pm-skills/retro/SKILL.md) | Run a sprint retro or incident post-mortem — blameless, action-oriented, with owners and due dates |

### Observability

| Skill | What It Does |
|-------|-------------|
| [logging](dev-pm-skills/logging/SKILL.md) | Structured logging: what to log, what to redact, log levels |
| [doc-generator](dev-pm-skills/doc-generator/SKILL.md) | Generate documentation from code |

### Examples

| Skill | What It Does |
|-------|-------------|
| [fitness-coach](dev-pm-skills/fitness-coach/) | Pattern 7 example: 4 focused sub-skills (exercise, nutrition, recovery, safety) under 200 lines each |

## Installing Skills for Claude Code

Claude Code looks for skills in two places:

| Scope | Path | When to use |
|-------|------|-------------|
| Global (all projects) | `~/.claude/skills/<skill-name>/SKILL.md` | Skills you use everywhere |
| Project-local | `.claude/skills/<skill-name>/SKILL.md` | Skills specific to one repo |

Use the install script to symlink skills from this repo — changes to source propagate automatically:

```bash
# Install all skills globally (available in every Claude Code session)
./scripts/install-skills.sh --global

# Install all skills for the current project only
./scripts/install-skills.sh --project

# Install specific skills globally
./scripts/install-skills.sh --global code-review debugging

# Check what's installed vs. available
./scripts/install-skills.sh --status
```

Invoke skills by name in any Claude Code session: `"run a code review"` or `/code-review`.

## Multi-Tool Support

Skills are plain Markdown — the same SKILL.md works across all tools. Run the export script to generate tool-specific formats:

```bash
./scripts/export-skills.sh all
```

| Tool | Exported to | How to invoke | Setup guide |
|------|-------------|---------------|-------------|
| Claude Code | `~/.claude/skills/` or `.claude/skills/` | Natural language or `/skill-name` | See above |
| Gemini CLI | `.gemini/skills/` | `/skill-name` | [gemini-cli-setup.md](docs/gemini-cli-setup.md) |
| Cursor | `.cursor/rules/*.mdc` | `@skill-name` in chat | [cursor-setup.md](docs/cursor-setup.md) |
| GitHub Copilot | `.github/skills/` | `#file:.github/skills/name.md` | [copilot-setup.md](docs/copilot-setup.md) |
| OpenAI Codex | `.codex/playbooks/` | Reference in task description | [codex-setup.md](docs/codex-setup.md) |
| Windsurf | `.windsurf/rules/` | Prompt Cascade to follow procedure | [windsurf-setup.md](docs/windsurf-setup.md) |

## Repo Structure

```
Calude-skills/
├── README.md
├── PATTERNS.md                      ← Deep dive on all 7 patterns
├── docs/
│   ├── adoption-guide.md            ← Step-by-step adoption plan
│   ├── checklist.md                 ← One-page audit checklist
│   ├── when-to-use-skills.md        ← Skill vs agent decision framework
│   ├── agentic-patterns.md          ← 7 agentic workflow patterns
│   ├── copilot-setup.md
│   ├── codex-setup.md
│   ├── cursor-setup.md
│   ├── windsurf-setup.md
│   └── gemini-cli-setup.md
├── dev-pm-skills/                   ← Developer & PM skills (edit these)
│   ├── code-review/SKILL.md
│   ├── commit-message/SKILL.md
│   ├── doc-generator/SKILL.md
│   ├── api-design/SKILL.md
│   ├── security/SKILL.md
│   ├── tdd/SKILL.md
│   └── daily-checkin/               ← Agent PM skills
├── scripts/
│   ├── export-skills.sh             ← Export to any tool format
│   ├── audit-skills.sh              ← Audit skills for pattern violations
│   ├── lint-skill.sh                ← CI-friendly linter
│   └── test-consistency.sh          ← Run same prompt 3x, check drift
├── .github/skills/                  ← Auto-generated: Copilot format
├── .codex/playbooks/                ← Auto-generated: Codex format
├── .cursor/rules/                   ← Auto-generated: Cursor format
├── .windsurf/rules/                 ← Auto-generated: Windsurf format
└── .gemini/skills/                  ← Auto-generated: Gemini CLI format
```

## Adoption Path

See [docs/adoption-guide.md](docs/adoption-guide.md) for the full plan. The short version:

**Day 1:** Run `./scripts/audit-skills.sh` on your repo. Read the report.
**Day 2–3:** Fix descriptions and exclusions (Patterns 1–2).
**Day 4–5:** Add templates and examples (Patterns 5–6).
**Day 6–7:** Split long skills, reorder critical rules (Patterns 4, 7).
**Day 8+:** Validate with `./scripts/test-consistency.sh`.

## Contributing

1. Fork the repo
2. Add or improve a skill in `dev-pm-skills/`
3. Run `./scripts/export-skills.sh all` to regenerate tool exports
4. Submit a PR — the CI linter will check your skill automatically

## License

MIT
