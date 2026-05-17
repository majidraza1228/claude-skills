# Adoption Guide

A step-by-step plan to adopt the 7 skill patterns in your repo.

## Before You Start

Run the audit script to get a baseline:

```bash
./scripts/audit-skills.sh /path/to/your/skills
```

This gives you a report showing:
- Which descriptions are too short
- Which skills are too long
- Where exclusions are misplaced
- Which skills lack output templates or examples

---

## Phase 1: Audit (Day 1)

**Goal:** Know what needs fixing.

- [ ] Run `./scripts/audit-skills.sh` against your skills directory
- [ ] Save the output to `docs/audit-baseline.txt`
- [ ] Categorize each finding: critical (safety rules buried), high (wrong skill triggers), medium (format drift), low (style)
- [ ] Create a tracking issue or spreadsheet with one row per finding

**Time:** 1–2 hours

---

## Phase 2: Quick Wins — Descriptions & Exclusions (Day 2–3)

**Goal:** Fix routing so the right skills trigger.

### Descriptions (Pattern 1)
- [ ] Open every skill with a description under 150 characters
- [ ] Expand to 150–300 characters
- [ ] Include 3–5 alternate trigger phrases
- [ ] Include file types, languages, or domains covered

### Exclusions (Pattern 2)
- [ ] Grep for exclusions in skill bodies: `grep -rnE 'do not use|don.t use for' skills/`
- [ ] Move each exclusion into the description
- [ ] Add "use /skills/X instead" redirect for each one
- [ ] Delete the original body exclusion

### Tone (Pattern 3)
- [ ] Search for hedge words: `grep -rnE 'maybe|could you|might want|consider|perhaps' skills/`
- [ ] Replace with imperatives

**Time:** 2–4 hours

---

## Phase 3: Templates & Examples (Day 4–5)

**Goal:** Eliminate format drift and improve consistency.

### Output Templates (Pattern 5)
- [ ] For each skill, define the exact output structure
- [ ] Use `{placeholder}` syntax for variable fields
- [ ] Add the template near the top of the skill body (within first 200 lines)

### Worked Examples (Pattern 6)
- [ ] Identify skills with >5 formatting rules
- [ ] Write 1–2 input/output examples for each
- [ ] Place examples immediately after the template
- [ ] Keep the rules as a secondary reference below

### Source Tables (Pattern 4)
- [ ] Find vague file references ("check the relevant files")
- [ ] Replace with Source / Path / What to Extract tables

**Time:** 3–5 hours

---

## Phase 4: Split & Restructure (Day 6–7)

**Goal:** Ensure every instruction gets attention.

### Split Long Skills (Pattern 7)
- [ ] List every skill over 400 lines: `find skills/ -name 'SKILL.md' -exec sh -c 'wc -l "$1" | awk "\$1 > 400"' _ {} \;`
- [ ] For each, identify logical sections that could be independent skills
- [ ] Create sub-skill directories with focused SKILL.md files
- [ ] Write descriptions for each sub-skill with proper routing
- [ ] Update any cross-references

### Reorder Within Skills
- [ ] Move safety-critical rules to lines 1–50
- [ ] Move output templates to lines 50–100
- [ ] Move examples to lines 100–150
- [ ] Keep detailed reference material after line 150

**Time:** 3–5 hours

---

## Phase 5: Validate (Day 8+)

**Goal:** Prove the fixes work.

### Format Consistency
- [ ] For each skill, pick 2 representative prompts
- [ ] Run each prompt 3 times
- [ ] Compare output structure — it should be identical
- [ ] If it varies, strengthen the template or add an example

### Routing Accuracy
- [ ] For each skill, write 3 prompts that should trigger it
- [ ] Write 2 prompts that should NOT trigger it (exclusion tests)
- [ ] Run all 5 and verify correct routing

### Safety & Critical Rules
- [ ] For skills with safety rules, write prompts that should trigger them
- [ ] Verify the rules actually fire
- [ ] If they don't, check line position — move higher

### Ongoing
- [ ] Add `./scripts/lint-skill.sh` to your CI pipeline
- [ ] Schedule monthly re-audits
- [ ] Review any new skills against the patterns before merging

**Time:** 4–8 hours initially, then 30 min/month ongoing

---

## Quick Reference

| Phase | Patterns | Effort | Impact |
|-------|----------|--------|--------|
| Audit | All | 1–2h | Baseline |
| Quick Wins | 1, 2, 3 | 2–4h | High — fixes routing |
| Templates | 4, 5, 6 | 3–5h | High — fixes consistency |
| Restructure | 7 | 3–5h | Critical — fixes safety |
| Validate | All | 4–8h | Proves it works |

Total estimated effort: **13–24 hours** for a full adoption across a typical skill repo.
