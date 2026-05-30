---
name: code-review
description: >
  Use this skill when the user asks for a code review, wants feedback on their
  code, asks to find bugs or issues, requests style or lint checks, or pastes
  code and says 'what do you think', 'anything wrong here', 'review this', or
  'check my code'. Covers Python, JavaScript, TypeScript, Go, Rust, Java, and
  C/C++. Also triggers on 'refactor suggestions', 'clean up this code', or
  'code quality check'. Do NOT use for writing new code from scratch — use
  /skills/code-generator instead. Do NOT use for explaining code — use
  /skills/code-explainer instead.
version: "1.0"
updated: "2026-05-30"
---

# Code Review Skill

## Safety — Read First

- NEVER execute or run user-submitted code
- NEVER suggest changes that would disable security features (auth, validation, encryption)
- If code contains hardcoded secrets, flag as CRITICAL and advise immediate rotation
- If code handles user input without sanitization, always flag as CRITICAL

## Output Template

Format every review using this exact structure:

```
## Summary
{1-2 sentence overview of code quality and main concern}

## Issues

| Severity | Location | Issue | Fix |
|----------|----------|-------|-----|
| {CRITICAL/WARNING/NIT} | {file:line} | {what's wrong} | {specific fix} |

## What's Good
- {1-2 things done well — always include this}

## Verdict
{APPROVE / REQUEST CHANGES / NEEDS DISCUSSION} — {one sentence justification}
```

## Worked Examples

### Example 1

INPUT:
```python
def login(username, password):
    query = f"SELECT * FROM users WHERE name='{username}' AND pass='{password}'"
    user = db.execute(query)
    return user
```

OUTPUT:
```
## Summary
Authentication function with a critical SQL injection vulnerability.

## Issues

| Severity | Location | Issue | Fix |
|----------|----------|-------|-----|
| CRITICAL | login.py:2 | SQL injection via f-string interpolation | Use parameterized query: `db.execute("SELECT * FROM users WHERE name=? AND pass=?", (username, password))` |
| WARNING | login.py:3 | Storing/comparing plain-text passwords | Use bcrypt or argon2 for password hashing |
| NIT | login.py:1 | No type hints on function signature | Add `def login(username: str, password: str) -> Optional[User]:` |

## What's Good
- Function has a clear single responsibility
- Naming is descriptive

## Verdict
REQUEST CHANGES — Critical security vulnerability must be fixed before merge.
```

### Example 2

INPUT:
```javascript
const fetchUser = async (id) => {
  try {
    const res = await fetch(`/api/users/${id}`);
    const data = await res.json();
    return data;
  } catch (err) {
    console.log(err);
    return null;
  }
};
```

OUTPUT:
```
## Summary
Clean async function with minor error-handling gaps.

## Issues

| Severity | Location | Issue | Fix |
|----------|----------|-------|-----|
| WARNING | fetchUser:3 | No response status check before parsing JSON | Add `if (!res.ok) throw new Error(\`HTTP ${res.status}\`)` before `.json()` |
| WARNING | fetchUser:6 | console.log in production error path | Use a proper logger or error reporting service |
| NIT | fetchUser:4 | Unnecessary intermediate variable | Return directly: `return await res.json()` |

## What's Good
- Uses async/await correctly
- Has try/catch error boundary

## Verdict
APPROVE — Minor improvements suggested but no blockers.
```

## Review Rules (Secondary Reference)

1. Always check for: injection vulnerabilities, auth bypass, data exposure, race conditions
2. Classify severity: CRITICAL (security/data loss), WARNING (bugs/bad practice), NIT (style/preference)
3. Reference exact file and line number for every issue
4. Provide a specific fix, not just a description of the problem
5. Always include "What's Good" — never deliver a review that's only negative
6. End with a clear verdict and one-sentence justification
