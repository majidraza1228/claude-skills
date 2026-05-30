# The 11 Skill-Design Patterns

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

---

## Pattern 8: Parse Structure, Not Text

### The Failure
Regex and string splitting on AI output breaks silently. The skill changes, the model upgrades, or a prompt tweak shifts the format — and the parser returns garbage with no error.

### Why It Happens
Free-text output looks stable until it isn't. `response.split('\n')[0]` works in dev, breaks in prod when the model adds a preamble sentence. There's no contract between the prompt and the parser.

### Before (Fragile)

```python
response = client.messages.create(...)
text = response.content[0].text

# Extract severity from first line
severity = text.split('\n')[0].split(':')[1].strip()
issues = re.findall(r'- (.+)', text)
```

One preamble sentence — `"Here's my review:"` — and `severity` is `"Here's my review"`.

### After (Robust — tool use / JSON mode)

```python
tools = [{
    "name": "code_review_result",
    "description": "Structured code review output",
    "input_schema": {
        "type": "object",
        "properties": {
            "severity": {"type": "string", "enum": ["critical", "warning", "nit", "pass"]},
            "issues": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "file": {"type": "string"},
                        "line": {"type": "integer"},
                        "description": {"type": "string"}
                    }
                }
            }
        },
        "required": ["severity", "issues"]
    }
}]

response = client.messages.create(tools=tools, tool_choice={"type": "any"}, ...)
result = response.content[0].input   # Always a dict — no parsing needed
```

### What to Do
- Any AI output consumed by code (not just displayed to a user) must use tool use or a JSON schema
- Free-text output is fine for human-facing responses — not for anything downstream
- If you're writing a regex to parse AI output, stop and add a tool definition instead

---

## Pattern 9: Eval Before Merge, Not After

### The Failure
A skill update ships, existing behavior silently breaks. Nobody notices until a user complains three days later. There's no diff for a prompt change — only a behavior diff.

### Why It Happens
Developers run tests before merging code. They don't run tests before merging a `SKILL.md` change. A prompt is treated like documentation, not like code.

### Before (No gate)

```bash
# Developer updates skill, eyeballs one example, opens PR
git add dev-pm-skills/code-review/SKILL.md
git commit -m "tighten code review instructions"
git push
# Merged. 3 days later: "why is severity always 'nit' now?"
```

### After (Eval in CI)

```yaml
# .github/workflows/eval.yml
name: Skill evals
on: [push, pull_request]
jobs:
  eval:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - run: pip install anthropic pyyaml
      - run: python evals/runner.py evals/code-review.yaml dev-pm-skills/code-review/SKILL.md
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

The runner exits 1 on any golden case failure — merge is blocked.

### The Rule
A `SKILL.md` change without an eval run is a deploy without tests. Treat it the same way.

### What to Do
- Add a golden test case file (`evals/<skill-name>.yaml`) for every skill that feeds downstream code
- Wire eval runner into CI — see `dev-pm-skills/harness-engineering/SKILL.md` for the full setup
- Minimum viable eval: 5 golden cases per skill. 10 is enough. More than 20 slows CI for no gain
- Update goldens when you intentionally change behavior — never as a workaround for failures

---

## Pattern 10: Define "Correct" Before Building

### The Failure
The AI feature ships. Users complain the output isn't right. The team argues about whether it's right. Nobody defined right before they started.

### Why It Happens
PMs write acceptance criteria for deterministic features: "button saves the form." They apply the same approach to AI features: "it should give good recommendations." Good is not a test.

### Before (No success criteria)

```
User story: As a user, I want AI-suggested next steps so I can
move my tasks forward faster.

Acceptance criteria:
- AI generates at least 3 suggestions
- Suggestions are relevant to the task
- Response loads within 5 seconds
```

"Relevant" is not measurable. This ships with no way to know if it's working.

### After (Measurable criteria)

```
Success criteria — defined before first line of code:

Correctness:  8/10 suggestions must appear in the expert-curated
              golden set for that task type (evaluated on 50 test tasks)

Precision:    No suggestion may contradict an existing task dependency
              (zero tolerance — automated check)

Latency:      P95 response < 3s measured at feature launch

User signal:  Suggestion acceptance rate ≥ 30% within 2 weeks of launch
              (below 20% = revisit the prompt, below 10% = kill the feature)
```

### What to Do
- For every AI feature, write success criteria before writing the prompt
- At least one criterion must be measurable without asking a user ("does this contain X")
- Set a kill threshold: if metric Y drops below Z after launch, the feature gets rolled back or reworked
- Run the criteria against 10 real examples before the PR is opened — not after

---

## Pattern 11: Token Cost Is a Product Constraint

### The Failure
A feature that costs $0.40 per request looks fine in dev with 10 test users. At 10,000 daily active users it's $4,000/day. The PM learns this at the billing alert.

### Why It Happens
Devs think in latency. PMs think in user value. Neither thinks in token budget during design. Context window size feels like a technical detail — it's actually a cost and a latency dial.

### Before (Ignoring token budget)

```python
# Sends full document history + entire thread + full system prompt every call
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=4096,
    system=full_system_prompt,          # 2,000 tokens
    messages=full_conversation_history  # grows unbounded
)
```

Day 1: 3,000 tokens/call. Day 30: 40,000 tokens/call. Same feature, 13× the cost.

### After (Token-aware design)

```python
# 1. Cache the static system prompt — charged once, not every call
# 2. Summarise history beyond last 5 turns instead of sending it all
# 3. Chunk documents — only send the relevant section, not the whole file
# 4. Use the right model for the task — Haiku for triage, Sonnet for reasoning

HISTORY_WINDOW = 5   # last N turns only
history = conversation[-HISTORY_WINDOW:]

if len(conversation) > HISTORY_WINDOW:
    summary = summarise_older_turns(conversation[:-HISTORY_WINDOW])
    history = [{"role": "user", "content": f"[Earlier context]: {summary}"}] + history
```

### The Rule
Token budget is a product decision, not an implementation detail. PMs and devs should agree on it before the first prototype, the same way they agree on SLAs.

### What to Do
- Estimate token cost per request at design time: (system prompt + avg context + avg response) × model price
- Set a per-request budget and build to it
- Use prompt caching for any system prompt over 1,000 tokens that doesn't change per request
- Pick model tier by task: routing/triage → Haiku, reasoning/generation → Sonnet, complex multi-step → Opus
- Monitor token usage in prod from day one — add it to your observability dashboard, not just dollar spend
