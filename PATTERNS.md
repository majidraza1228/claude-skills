# The 7 Skill-Design Patterns

Each pattern below includes: the failure mode, why it happens, before/after examples, and how to fix it.

---

## Pattern 1: Descriptions Under 100 Characters Stay Invisible

### The Failure
Claude matches user prompts against skill descriptions at routing time. Short descriptions have too few words to match on.

### Why It Happens
A 37-character description like `Suggest recipes from what's in fridge` only contains a handful of matchable words. When a user says "I have chicken and rice, what can I make?" — there's almost no overlap.

### Before (Bad — 54 chars)

```yaml
description: "Review code for bugs and style issues"
```

### After (Good — 280 chars)

```yaml
description: >
  Use this skill when the user asks for a code review, wants feedback
  on their code, asks to find bugs or issues, requests style or lint
  checks, or pastes code and says 'what do you think' or 'anything
  wrong here'. Covers Python, JavaScript, TypeScript, Go, Rust.
  Also triggers on 'refactor suggestions' or 'clean up this code'.
```

### What to Do
- Audit every `SKILL.md` description — flag anything under 150 characters
- Add 3–5 alternate trigger phrases users actually say
- Include file types, languages, or domains the skill covers
- Target 150–300 characters per description

---

## Pattern 2: Exclusions Belong in the Description

### The Failure
"Do not use for spreadsheets" on line 45 of the skill body fires *after* the wrong skill has already loaded. Claude is already committed.

### Why It Happens
Descriptions are read at routing time. The body is read at execution time. An exclusion in the body is too late — it's like a "wrong way" sign placed after the highway exit.

### Before (Bad)

```yaml
description: "Use for all document tasks"
```
```markdown
# Line 45 of SKILL.md body:
Do not use this skill for spreadsheets.
```

### After (Good)

```yaml
description: >
  Use this skill for creating, editing, and formatting Word documents
  (.docx), including reports, memos, letters, and templates.
  Do NOT use for spreadsheets or CSV files — use /skills/xlsx instead.
  Do NOT use for PDFs — use /skills/pdf instead.
  Do NOT use for plain text manipulation — those need no skill.
```

### The Rule
Every "do not use for X" **must** include "use /Y instead." Without a redirect, Claude knows this skill is wrong but doesn't know what's right.

### What to Do
- Grep skill bodies for "do not use", "don't use", "not for"
- Move every exclusion into the description
- Add a redirect path for each exclusion
- Test by prompting with the excluded use case

---

## Pattern 3: Claude Mirrors Your Instruction Tone

### The Failure
Hedging language produces hedging output. "Could you maybe check" → "You might want to consider."

### Why It Happens
Claude treats the tone of instructions as a signal for how to behave. Tentative wording = tentative output. Direct wording = direct output.

### Before (Tentative)

```markdown
Could you take a look at the code and maybe check if there are
any issues? It would be nice to point out anything that might
be improved, if you get a chance.
```

Output: "You might want to consider renaming this variable — it could be a bit clearer."

### After (Direct)

```markdown
Flag every issue. Classify severity: critical, warning, nit.
Reference exact file and line number. Do not soften language.
If the code is broken, say it is broken.

Format:
| Severity | File:Line | Issue | Fix |
```

Output: `| Critical | auth.py:42 | SQL injection via string interpolation | Use parameterized queries |`

### What to Do
- Search for hedge words: "maybe", "could", "might", "consider", "perhaps"
- Replace with imperatives: "Flag", "List", "Output", "Return", "Classify"
- If you want structured output, write the instructions in structured form

---

## Pattern 4: Three-Column Tables Beat "Check the Relevant Files"

### The Failure
"Check the relevant files" forces Claude to guess which files, where they are, and what to extract. It guesses wrong.

### Before (Vague)

```markdown
Before generating the report, check the relevant configuration
files and extract the necessary settings.
```

### After (Explicit)

```markdown
Extract data from these sources before generating the report:

| Source         | Path                          | What to Extract                    |
|----------------|-------------------------------|-------------------------------------|
| App config     | /config/app.yaml              | app.name, app.version, app.env     |
| DB settings    | /config/database.yml          | host, port, pool_size              |
| Feature flags  | /config/features.json         | All keys where value is true       |
| Deploy log     | /var/log/last_deploy.log      | Timestamp of last line, exit code  |
```

### What to Do
- Find every instruction that says "check", "look at", or "review" without specifics
- Replace with a Source / Path / What to Extract table
- Use exact field names, not vague descriptions

---

## Pattern 5: Without an Output Template, Formats Drift

### The Failure
Same skill, same prompt, three mornings, three different output structures. Breaks automation and confuses users.

### Before (No template)

```markdown
Analyze the git commit and write a summary.
```

Monday: plain text. Tuesday: markdown headers. Wednesday: bullet list.

### After (Explicit template)

```markdown
Format every commit analysis using this exact template:

---
**Commit:** {short_hash} — {title}
**Author:** {author} | **Date:** {date}
**Risk:** {Critical | High | Medium | Low}

**What changed:**
- {file_path}: {one-line description of change}

**Why it matters:** {1-2 sentences on impact}

**Testing:** {coverage description or "No tests added — flag for review"}
---
```

### What to Do
- Define exact output structure for every skill
- Use `{placeholder}` syntax so Claude knows what to fill
- Run the same prompt 3x — if format differs, you need a template
- For machine-consumed output, specify JSON schema

---

## Pattern 6: One Example Beats Five Rules

### The Failure
12 formatting rules → inconsistent output across runs. 2 worked examples → identical output every time.

### Why It Happens
Rules require interpretation. "Use imperative mood" — Claude might apply this inconsistently. An example showing `fix: Add retry logic` is unambiguous.

### Before (Rules only)

```markdown
1. Start with a type prefix (feat, fix, refactor, docs, test, chore)
2. Use imperative mood
3. Keep the subject line under 72 characters
4. Add a blank line after the subject
5. Explain what and why in the body, not how
...8 more rules...
```

### After (Worked examples)

```markdown
Write commit messages following these examples:

EXAMPLE 1:
INPUT: Added error handling to the payment processing module,
catches timeout errors and retries up to 3 times before failing
gracefully. Related to bug report #234.

OUTPUT:
fix: Add retry logic for payment timeout errors

Add try/catch around payment gateway calls with exponential
backoff. Retry up to 3 times on timeout before returning a
user-friendly error instead of a 500.

Closes #234

EXAMPLE 2:
INPUT: Moved all the database query functions from the user
controller into a separate repository file for better separation
of concerns.

OUTPUT:
refactor: Extract database queries into user repository

Move all raw SQL calls from UserController into UserRepository.
Controller now depends on repository interface, making it
testable with mocks.
```

### What to Do
- For every skill with >5 formatting rules, add 1–2 worked examples
- Show real input → exact expected output
- Keep rules as secondary reference; lead with examples

---

## Pattern 7: Skills Over 500 Lines Drop Their Bottom Half

### The Failure
In an 800-line fitness skill, safety rules at line 700+ never fired. Not once in testing.

### Why It Happens
Claude's attention to instructions degrades with length. Think of line position as a priority ranking — the higher something appears, the more reliably it fires.

```
Lines 1-100:    Exercise selection      ✅ Always works
Lines 100-200:  Rep calculations        ✅ Always works
Lines 200-350:  Progression models      ✅ Usually works
Lines 350-500:  Nutrition guidance      ⚠️  Sometimes works
Lines 500-650:  Recovery protocols      ⚠️  Unreliable
Lines 650-800:  Safety warnings         ❌ Never fires
```

### Fix Option A — Reorder (critical content first)

```markdown
# SAFETY — READ FIRST
- NEVER recommend heavy compound lifts without asking about injuries
- ALWAYS suggest medical clearance for users reporting chronic pain
- If user mentions heart condition, diabetes, or pregnancy: defer to doctor

# CORE LOGIC
(rest of skill follows)
```

### Fix Option B — Split into sub-skills

```
/skills/fitness/exercise-selection/SKILL.md   (120 lines)
/skills/fitness/programming/SKILL.md          (150 lines)
/skills/fitness/nutrition/SKILL.md            (130 lines)
/skills/fitness/safety/SKILL.md               (80 lines)
```

### What to Do
- Count lines in every skill — flag anything over 400
- Move safety-critical rules to the first 100 lines
- Split skills over 500 lines into focused sub-skills
- Re-test after splitting to confirm bottom-half rules now fire
