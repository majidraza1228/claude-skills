# Extended Skills

9 skills for creative, product, and personal work — complements the `dev-pm-skills/` set.

## Install

```bash
# Install all extended skills globally
./scripts/install-skills.sh --global --dir extended-skills

# Or install one at a time
mkdir -p ~/.claude/skills/slides
cp extended-skills/slides/SKILL.md ~/.claude/skills/slides/SKILL.md
cp extended-skills/slides/STYLES.md ~/.claude/skills/slides/STYLES.md
cp extended-skills/slides/render_slides.py ~/.claude/skills/slides/render_slides.py
```

Some skills have companion files you should customize before first use — see each skill's notes below.

---

## Skills

### Product

| Skill | What It Does |
|-------|-------------|
| [strategy-writer](strategy-writer/SKILL.md) | Shape a one-page product strategy: problem, vision, principles, strategy, milestones |
| [spec-writer](spec-writer/SKILL.md) | Turn rough notes into a build-ready PRD using a structured template |
| [exec-reviewer](exec-reviewer/SKILL.md) | Stress-test a plan or doc the way a sharp exec would — ships with a built-in reviewer profile |

### Writing & Content

| Skill | What It Does |
|-------|-------------|
| [no-ai-slop](no-ai-slop/SKILL.md) | Edit any draft into sharper, more human writing — cuts AI-speak and vague filler |
| [infographic-designer](infographic-designer/SKILL.md) | Build a structured 9:16 infographic prompt and generate it with gpt-image-2 |
| [slides](slides/SKILL.md) | Generate a full HTML slide deck with Dark/Light/Corporate styles, 12 formats, and Visual QA |

### Personal

| Skill | What It Does |
|-------|-------------|
| [ai-career-advisor](ai-career-advisor/SKILL.md) | Personalised learning roadmap with curated YouTube, articles, books, and projects for your career goal |
| [weekend-planner](weekend-planner/SKILL.md) | Surface 10 time-sensitive local activities tailored to your family's profile |

### Builder Tools

| Skill | What It Does |
|-------|-------------|
| [skill-editor](skill-editor/SKILL.md) | Audit and tighten an existing SKILL.md — cuts bloat, fixes structure, evals before shipping |

---

## Companion files

Some skills use a companion file you fill in once. Keep these out of version control if they contain personal information.

| Skill | Companion file | What to do |
|-------|---------------|------------|
| `weekend-planner` | `weekend-planner/plan.md` | Fill in family profile (ages, location, walking limits, activity preferences) |
| `exec-reviewer` | `exec-reviewer/leader-review.md` | Built-in reviewer — or run `/exec-reviewer` to build a custom profile |
| `spec-writer` | `spec-writer/prd-template.md` | PRD template — edit sections to match your team's format |
| `slides` | `slides/STYLES.md`, `slides/render_slides.py` | Style reference and QA renderer — copy alongside SKILL.md |
