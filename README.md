# AI-Powered Developer & PM Playbook

**11 battle-tested patterns for writing AI skills and building AI features that work consistently — across Claude, Copilot, Codex, Cursor, Windsurf, and Gemini CLI.**

Built from 75+ tests across real skill implementations. Every pattern here solves a specific failure mode — skills that don't trigger, output that drifts between runs, safety rules that never fire, and AI features that ship without success criteria or cost controls.

## Getting Started

**Pick who you are → follow the guide → up and running in 5 minutes.**

| I am a... | Start here |
|---|---|
| **Developer** writing code daily | [Developer guide →](docs/getting-started.md#developer) |
| **Project Manager** running sprints | [PM guide →](docs/getting-started.md#project-manager) |
| **User** just wanting to use the skills | [User guide →](docs/getting-started.md#user) |

**Then pick your tool:**

| Tool | Setup guide |
|---|---|
| Claude Code | [claude-code-setup.md](docs/claude-code-setup.md) |
| VS Code + Copilot | [vscode-setup.md](docs/vscode-setup.md) |
| Cursor | [cursor-setup.md](docs/cursor-setup.md) |
| OpenAI Codex | [codex-setup.md](docs/codex-setup.md) |
| Windsurf | [windsurf-setup.md](docs/windsurf-setup.md) |
| Gemini CLI | [gemini-cli-setup.md](docs/gemini-cli-setup.md) |

```bash
# Clone the repo
git clone https://github.com/majidraza1228/claude-skills.git
cd claude-skills

# Install for Claude Code (most features)
./scripts/install-skills.sh --global

# Or export for any other tool
./scripts/export-skills.sh cursor     # Cursor
./scripts/export-skills.sh copilot   # VS Code + Copilot
./scripts/export-skills.sh codex     # OpenAI Codex
./scripts/export-skills.sh windsurf  # Windsurf
./scripts/export-skills.sh gemini    # Gemini CLI
```

## The 11 Patterns

### Skill Design (for anyone writing SKILL.md files)

| # | Pattern | Failure It Prevents |
|---|---------|-------------------|
| 1 | [Descriptions ≥ 150 chars](PATTERNS.md#pattern-1-descriptions-under-100-characters-stay-invisible) | Skill never triggers |
| 2 | [Exclusions in description with redirects](PATTERNS.md#pattern-2-exclusions-belong-in-the-description) | Wrong skill loads |
| 3 | [Direct tone in instructions](PATTERNS.md#pattern-3-claude-mirrors-your-instruction-tone) | Vague, hedging output |
| 4 | [Three-column source tables](PATTERNS.md#pattern-4-three-column-tables-beat-check-the-relevant-files) | Missing or wrong data |
| 5 | [Output templates](PATTERNS.md#pattern-5-without-an-output-template-formats-drift) | Format changes every run |
| 6 | [Worked examples over rules](PATTERNS.md#pattern-6-one-example-beats-five-rules) | Inconsistent structure |
| 7 | [Skills under 500 lines](PATTERNS.md#pattern-7-skills-over-500-lines-drop-their-bottom-half) | Bottom-half instructions ignored |

### Building with AI (for developers and PMs)

| # | Pattern | Failure It Prevents |
|---|---------|-------------------|
| 8 | [Parse structure, not text](PATTERNS.md#pattern-8-parse-structure-not-text) | Regex on AI output breaks silently |
| 9 | [Eval before merge, not after](PATTERNS.md#pattern-9-eval-before-merge-not-after) | Prompt changes silently break existing behavior |
| 10 | [Define "correct" before building](PATTERNS.md#pattern-10-define-correct-before-building) | No way to know if an AI feature is working |
| 11 | [Token cost is a product constraint](PATTERNS.md#pattern-11-token-cost-is-a-product-constraint) | $0.40/request discovered at billing, not design |

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

### AI & Engineering Specialisms

| Skill | What It Does |
|-------|-------------|
| [harness-engineering](dev-pm-skills/harness-engineering/SKILL.md) | Build AI eval harnesses (prompt regression tests, golden datasets, CI integration) and set up Harness.io CI/CD pipelines |
| [forward-deployed-engineering](dev-pm-skills/forward-deployed-engineering/SKILL.md) | FDE career roadmap (Palantir/Anduril/Scale AI) and day-to-day practice (technical discovery, rapid deployment, stakeholder comms) |

### Observability

| Skill | What It Does |
|-------|-------------|
| [logging](dev-pm-skills/logging/SKILL.md) | Structured logging: what to log, what to redact, log levels |
| [doc-generator](dev-pm-skills/doc-generator/SKILL.md) | Generate documentation from code |

### Examples

| Skill | What It Does |
|-------|-------------|
| [fitness-coach](dev-pm-skills/fitness-coach/) | Pattern 7 example: 4 focused sub-skills (exercise, nutrition, recovery, safety) under 200 lines each |

## Works With

The same `SKILL.md` files work across every major AI coding tool. The skill content (output templates, safety rules, worked examples) is plain Markdown — only the loading mechanism differs per tool.

| Tool | How skills load | Invoke | Setup guide |
|------|----------------|--------|-------------|
| **Claude Code** | Native — auto-routes from natural language | `"review my code"` or `/code-review` | [claude-code-setup.md](docs/claude-code-setup.md) |
| **Cursor** | `.cursor/rules/*.mdc` — `@mention` in chat | `@code-review` | [cursor-setup.md](docs/cursor-setup.md) |
| **VS Code + Copilot** (Copilot, Cline, Continue) | `#file:` reference or always-on instructions | `#file:.github/skills/name.md` | [vscode-setup.md](docs/vscode-setup.md) |
| **OpenAI Codex** | `.codex/playbooks/` — reference in task | Mention in task description | [codex-setup.md](docs/codex-setup.md) |
| **Windsurf** | `.windsurf/rules/` — Cascade rules | Prompt to follow procedure | [windsurf-setup.md](docs/windsurf-setup.md) |
| **Gemini CLI** | `.gemini/skills/` | `/skill-name` | [gemini-cli-setup.md](docs/gemini-cli-setup.md) |

> **Claude Code gets the most.** Auto-routing, agent PM (`/daily-checkin`, `/team-digest`), and the install script all require Claude Code. Every other tool gets the skill content but loads it manually.

### Quick install

```bash
# Claude Code — install all 25 dev/PM skills globally
./scripts/install-skills.sh --global

# Export for any other tool
./scripts/export-skills.sh all        # all tools
./scripts/export-skills.sh cursor     # Cursor only
./scripts/export-skills.sh copilot    # GitHub Copilot / VS Code
./scripts/export-skills.sh codex      # OpenAI Codex
```

## Repo Structure

```
Calude-skills/
├── README.md
├── PATTERNS.md                      ← Deep dive on all 11 patterns
├── docs/
│   ├── adoption-guide.md            ← Step-by-step adoption plan
│   ├── checklist.md                 ← One-page audit checklist
│   ├── when-to-use-skills.md        ← Skill vs agent decision framework
│   ├── agentic-patterns.md          ← 7 agentic workflow patterns
│   ├── claude-code-setup.md ← Claude Code (CLI + desktop)
│   ├── vscode-setup.md      ← VS Code (Copilot, Cline, Continue)
│   ├── cursor-setup.md      ← Cursor
│   ├── copilot-setup.md     ← GitHub Copilot (standalone)
│   ├── codex-setup.md       ← OpenAI Codex
│   ├── windsurf-setup.md    ← Windsurf
│   └── gemini-cli-setup.md  ← Gemini CLI
├── dev-pm-skills/                   ← Developer & PM skills (25 skills)
│   ├── code-review/SKILL.md
│   ├── commit-message/SKILL.md
│   ├── daily-checkin/               ← Agent PM skills
│   └── ...19 more
├── extended-skills/                 ← Creative, product & personal skills (9 skills)
│   ├── slides/SKILL.md
│   ├── strategy-writer/SKILL.md
│   ├── spec-writer/SKILL.md
│   ├── exec-reviewer/SKILL.md
│   ├── no-ai-slop/SKILL.md
│   ├── infographic-designer/SKILL.md
│   ├── personal-advisor/SKILL.md
│   ├── weekend-planner/SKILL.md
│   └── skill-editor/SKILL.md
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

See [docs/adoption-guide.md](docs/adoption-guide.md) for the full guide. Two paths:

**Using the playbook (Day 1):** Install → trigger your first skill → pick your 5 daily skills → integrate into your real workflow.

**Improving or building skills (contributor path):** Audit → fix descriptions (Pattern 1–2) → add templates and examples (Pattern 5–6) → split long skills (Pattern 7) → validate with `./scripts/test-consistency.sh`.

## Contributing

1. Fork the repo
2. Add or improve a skill in `dev-pm-skills/`
3. Run `./scripts/export-skills.sh all` to regenerate tool exports
4. Submit a PR — the CI linter will check your skill automatically

## License

MIT
