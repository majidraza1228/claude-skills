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
cp skills/code-review/SKILL.md /path/to/your/skills/my-new-skill/SKILL.md

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
| [planning](skills/planning/SKILL.md) | Break features into tasks with done criteria and dependencies |
| [code-explain](skills/code-explain/SKILL.md) | Explain unfamiliar code, algorithms, or regex at the right depth |
| [debugging](skills/debugging/SKILL.md) | 5-step bug triage: reproduce → localize → reduce → fix → guard |
| [refactor](skills/refactor/SKILL.md) | Simplify code without changing behavior (Chesterton's Fence rule) |
| [performance](skills/performance/SKILL.md) | Measure-first optimization: N+1 queries, caching, profiling |

### Code Quality & Review

| Skill | What It Does |
|-------|-------------|
| [code-review](skills/code-review/SKILL.md) | Structured review with severity table (CRITICAL/WARNING/NIT) and verdict |
| [security](skills/security/SKILL.md) | OWASP Top 10 security review — flags critical issues before merge |
| [tdd](skills/tdd/SKILL.md) | Red-green-refactor TDD with test pyramid and worked examples |

### Git & Release

| Skill | What It Does |
|-------|-------------|
| [commit-message](skills/commit-message/SKILL.md) | Conventional commit formatting with worked examples |
| [pr-description](skills/pr-description/SKILL.md) | PR body with what/why, test steps, and reviewer notes |
| [changelog](skills/changelog/SKILL.md) | Keep a Changelog format from commit list or git log |

### Data & APIs

| Skill | What It Does |
|-------|-------------|
| [api-design](skills/api-design/SKILL.md) | Contract-first API design with breaking change assessment |
| [sql](skills/sql/SKILL.md) | Write and optimize SQL queries safely (with guards for DELETE/UPDATE) |
| [database-schema](skills/database-schema/SKILL.md) | Schema design with migration + rollback scripts |

### Observability

| Skill | What It Does |
|-------|-------------|
| [logging](skills/logging/SKILL.md) | Structured logging: what to log, what to redact, log levels |
| [doc-generator](skills/doc-generator/SKILL.md) | Generate documentation from code |

### Examples

| Skill | What It Does |
|-------|-------------|
| [fitness-coach](skills/fitness-coach/safety/SKILL.md) | Shows how to split a long skill into focused sub-skills |

## Multi-Tool Support

Skills are plain Markdown — the same SKILL.md works across all tools. Run the export script to generate tool-specific formats:

```bash
./scripts/export-skills.sh all
```

| Tool | Exported to | How to invoke | Setup guide |
|------|-------------|---------------|-------------|
| Claude Code | `skills/` (native) | Natural language or `/skill-name` | Native |
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
├── skills/                          ← Source skills (edit these)
│   ├── code-review/SKILL.md
│   ├── commit-message/SKILL.md
│   ├── doc-generator/SKILL.md
│   ├── api-design/SKILL.md
│   ├── security/SKILL.md
│   ├── tdd/SKILL.md
│   └── fitness-coach/               ← Example of sub-skill splitting
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
2. Add or improve a skill in `skills/`
3. Run `./scripts/export-skills.sh all` to regenerate tool exports
4. Submit a PR — the CI linter will check your skill automatically

## License

MIT
