---
name: refactor
description: >
  Use this skill when the user wants to refactor, simplify, or clean up existing
  code without changing its behavior. Triggers on 'refactor this', 'simplify
  this code', 'this is too complex', 'clean this up', 'make this more readable',
  'reduce duplication', 'extract a function', 'too many nested ifs', or 'this
  is hard to understand'. Also triggers on 'apply DRY', 'remove dead code',
  'split this class', or 'this function is too long'. Do NOT use for adding new
  features — use /skills/code-review to check first. Do NOT use if tests do not
  exist — write tests before refactoring.
version: "1.0"
updated: "2026-05-30"
---

# Refactor Skill

## Safety — Read First

- NEVER change behavior while refactoring — tests must pass before and after
- NEVER refactor code without tests. If tests don't exist, write them first
- Apply Chesterton's Fence: before removing anything, understand WHY it exists
- Refactor in small steps — one change, run tests, commit, repeat

## The Chesterton's Fence Rule

> "Do not remove a fence until you know why it was built."

Before deleting or simplifying any code, answer: **why does this exist?**
If you can't answer, read the git history (`git log -p -- <file>`) before touching it.

## Output Template

```
## Refactor Plan: {function/module name}

### Problem
{what makes the current code hard to read/maintain}

### Approach
{what pattern or technique you'll apply}

### Before
{original code}

### After
{refactored code}

### Behavior preserved
{how to verify nothing changed — test command or assertion}

### What was NOT changed
{scope boundary — what you deliberately left alone}
```

## Worked Examples

### Example 1 — Nested conditionals

INPUT:
```python
def get_discount(user):
    if user.is_member:
        if user.years >= 5:
            if user.total_spend > 10000:
                return 0.30
            else:
                return 0.20
        else:
            return 0.10
    else:
        return 0.0
```

OUTPUT:
```
## Refactor Plan: get_discount()

### Problem
Triple nesting makes the logic hard to follow. Adding a new tier requires
modifying deeply nested code and risks introducing bugs.

### Approach
Early returns + guard clauses flatten the nesting.

### Before
(original above)

### After
def get_discount(user):
    if not user.is_member:
        return 0.0
    if user.years < 5:
        return 0.10
    if user.total_spend > 10000:
        return 0.30
    return 0.20

### Behavior preserved
pytest test_discounts.py -v  # all existing tests should pass unchanged

### What was NOT changed
Discount thresholds, membership logic, and spend calculation are untouched.
```

### Example 2 — Duplicate code

INPUT:
```javascript
function sendWelcomeEmail(user) {
  const msg = { to: user.email, subject: 'Welcome', body: `Hi ${user.name}` };
  fetch('/api/email', { method: 'POST', body: JSON.stringify(msg) });
}

function sendResetEmail(user) {
  const msg = { to: user.email, subject: 'Reset', body: `Hi ${user.name}, reset here` };
  fetch('/api/email', { method: 'POST', body: JSON.stringify(msg) });
}
```

OUTPUT:
```
## Refactor Plan: sendWelcomeEmail / sendResetEmail

### Problem
Email sending logic is duplicated. If the API path or headers change,
both functions need updating.

### Approach
Extract a shared sendEmail() helper.

### After
function sendEmail(user, subject, body) {
  const msg = { to: user.email, subject, body };
  return fetch('/api/email', { method: 'POST', body: JSON.stringify(msg) });
}

function sendWelcomeEmail(user) {
  return sendEmail(user, 'Welcome', `Hi ${user.name}`);
}

function sendResetEmail(user) {
  return sendEmail(user, 'Reset', `Hi ${user.name}, reset here`);
}

### Behavior preserved
Existing callers of sendWelcomeEmail/sendResetEmail need no changes.
Run: npm test -- --grep "email"

### What was NOT changed
Email content, recipient logic, and API endpoint are untouched.
```

## Refactoring Techniques (Secondary Reference)

| Technique | When to apply |
|-----------|--------------|
| Extract function | Block of code doing one clear thing, used more than once |
| Early return / guard clause | Nested conditionals that grow with each new case |
| Replace magic number | Literal values like `86400` → `SECONDS_PER_DAY = 86400` |
| Rename for clarity | Variable/function name doesn't match what it does |
| Split large function | Function doing more than one thing (>20–30 lines is a signal) |
| Move logic to right place | Business logic living in a controller/route instead of a service |
| Remove dead code | Code that is never called (verify with grep + git blame) |

## Rules (Secondary Reference)

1. One refactor per commit — easier to revert if something breaks
2. Run tests before and after every change
3. Never combine refactor + feature in the same PR
4. If you can't explain why the code is simpler after your change, don't commit it
