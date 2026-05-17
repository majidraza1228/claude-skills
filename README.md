# Claude Skill Patterns

**7 battle-tested patterns for writing Claude skills that work consistently.**

Built from 75+ tests across real skill implementations. Every pattern here solves a specific failure mode — skills that don't trigger, output that drifts between runs, safety rules that never fire.

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/your-org/claude-skill-patterns.git
cd claude-skill-patterns

# 2. Audit your existing skills
./scripts/audit-skills.sh /path/to/your/skills

# 3. Copy a starter template
cp skills/code-review/SKILL.md /path/to/your/skills/my-new-skill/SKILL.md

# 4. Run consistency tests
./scripts/test-consistency.sh /path/to/your/skills/my-new-skill/SKILL.md
```

## The 7 Patterns

| # | Pattern | Failure It Prevents |
|---|---------|-------------------|
| 1 | [Descriptions ≥ 150 chars](#pattern-1) | Skill never triggers |
| 2 | [Exclusions in description with redirects](#pattern-2) | Wrong skill loads |
| 3 | [Direct tone in instructions](#pattern-3) | Vague, hedging output |
| 4 | [Three-column source tables](#pattern-4) | Missing or wrong data |
| 5 | [Output templates](#pattern-5) | Format changes every run |
| 6 | [Worked examples over rules](#pattern-6) | Inconsistent structure |
| 7 | [Skills under 500 lines](#pattern-7) | Bottom-half instructions ignored |

## Repo Structure

```
claude-skill-patterns/
├── README.md                    ← You are here
├── PATTERNS.md                  ← Deep dive on all 7 patterns
├── docs/
│   ├── adoption-guide.md        ← Step-by-step adoption plan
│   └── checklist.md             ← One-page audit checklist
├── skills/                      ← Example skills demonstrating each pattern
│   ├── code-review/
│   │   ├── SKILL.md             ← Well-structured skill
│   │   ├── examples/            ← Input/output examples
│   │   └── tests/               ← Consistency test prompts
│   ├── commit-message/
│   ├── doc-generator/
│   └── fitness-coach/           ← Shows how to split a long skill
├── scripts/
│   ├── audit-skills.sh          ← Audit existing skills for issues
│   ├── test-consistency.sh      ← Run same prompt 3x, check drift
│   └── lint-skill.sh            ← CI-friendly linter
└── .github/
    └── workflows/
        └── skill-lint.yml       ← GitHub Action for PR checks
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
2. Add or improve a pattern example in `skills/`
3. Include a test prompt in `tests/`
4. Submit a PR — the CI linter will check your skill automatically

## License

MIT
