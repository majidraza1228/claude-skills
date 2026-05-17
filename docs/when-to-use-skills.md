# When to Use Skills vs AI Agents

A decision framework distilled from production usage across Claude, Copilot, and Codex.

---

## TL;DR

- **Skill** = a reusable, standardized procedure invoked repeatedly for a narrow job.
- **Agent** = a system that executes multi-step work (plan → act → verify) using tools, memory, and control loops.
- **Skills make agents reliable and repeatable. Agents make skills useful at scale.**

---

## Decision Framework

### Use a Skill when:
- The work is **predictable** and done frequently ("more than twice")
- You want **consistency** — tone, format, compliance, steps
- The task completes in **one interaction** or a short deterministic sequence
- The failure mode is **missing steps or drifting style**

### Use an Agent when:
- The work is **multi-step** with branching paths
- It requires **tool use** — files, repos, web, APIs, databases
- It needs **monitoring + retries + verification**
- You want **autonomy** and can define guardrails

### Use Skill + Agent when:
- You want an agent to handle complex work, but ensure each subtask is done in a **repeatable** way

---

## Taxonomy (Mental Model)

| Level | What it is | Example |
|---|---|---|
| 1. Prompt | One-off assistance | "Explain this function" |
| 2. Skill | Reusable procedure (SOP) | `/commit-message`, `/code-review` |
| 3. Workflow | Chaining skills + tools | Run review → generate PR description |
| 4. Agent | Goal-seeking loop with tools + state | "Implement feature X in this repo" |
| 5. Multi-agent | Specialized agents collaborating | Planner + Implementer + Reviewer |

---

## Concrete Examples

### Social media content
**Skill:** "Turn any article into 3 LinkedIn posts in my voice"
- Input: source text + audience + CTA
- Output: 3 posts + hooks + hashtags
- Guardrails: tone rules, banned phrases, formatting

**Agent:** "Run my weekly content pipeline"
- Find source material → draft posts → check style → schedule → log performance
- Needs tool access + control loop

### Code changes
**Skill:** "Write a PR description + changelog entry"
- Deterministic template, consistent formatting

**Agent:** "Implement feature X in repo Y"
- Explore codebase → plan → implement → run tests → fix → open PR → respond to reviews

---

## Where Skills Live in a Project

```
.claude/
  CLAUDE.md              # Project constitution: goals, standards, how to work
  memory/                # Long-lived context (architecture, decisions, glossary)
  skills/                # Reusable procedures (each task in one SKILL.md)
  agents/                # Specialized sub-agents (planner, implementer, reviewer)
  hooks/                 # Automation at lifecycle events
```

- **Skills** = files in `skills/` that standardize a workflow
- **Agents** = roles in `agents/` that run multi-step work and invoke skills
- **Hooks** = ensure the system follows rules every time (they enforce what skills define)

---

## Skill Examples (by category)

- **Code review:** Given a PR diff, run a fixed checklist and output a structured review
- **Meeting notes:** Turn raw notes into Summary / Decisions / Risks / Action Items
- **SQL formatter:** Rewrite to house style, add LIMIT, block destructive statements
- **Customer email:** Rewrite in approved tone, output 3 variants

## Agent Examples (by category)

- **Bug-fix agent:** Reproduce → locate → fix → test → open PR → draft release note
- **Research agent:** Gather sources → synthesize → highlight disagreements → produce brief
- **BI agent:** Clarify metric → query warehouse → validate → produce chart + narrative

---

## Guardrails

Skills are the easiest place to encode:
- **Quality checks** ("must include citations", "must output JSON schema")
- **Safety/compliance rules**
- **Format contracts** (stable output for downstream automation)

Agents need:
- **Stop conditions**
- **Permission boundaries** (read vs write)
- **Observability** (logs, artifacts)
- **Evaluation loops** (tests, rubrics, graders)
