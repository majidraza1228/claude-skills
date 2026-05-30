---
name: security
description: >
  Use this skill when the user asks for a security review, wants to check for
  vulnerabilities, asks 'is this safe', 'any security issues', 'OWASP check',
  or pastes code that handles user input, authentication, authorization, file
  uploads, SQL queries, or API keys. Also triggers on 'hardening', 'secrets
  management', 'injection', 'XSS', 'CSRF', 'auth bypass', or 'rate limiting'.
  Do NOT use for general code quality review — use /skills/code-review instead.
version: "1.0"
updated: "2026-05-30"
---

# Security Review Skill

## Safety — Read First

- If hardcoded secrets (API keys, passwords, tokens) are found, classify as CRITICAL and advise **immediate rotation** regardless of other findings
- NEVER suggest disabling security controls (CSRF tokens, input validation, auth checks) as a fix for other problems
- If user input reaches a database query, shell command, or eval without sanitization, classify as CRITICAL

## Output Template

```
## Security Review: {component/function name}

### Critical (fix before merge)
| Vulnerability | Location | Risk | Fix |
|---------------|----------|------|-----|
| {CVE/OWASP category} | {file:line} | {what an attacker can do} | {specific fix} |

### Warnings (fix soon)
| Issue | Location | Risk | Fix |
|-------|----------|------|-----|

### Notes (low risk / hardening)
- {observation}

### Verdict
{PASS / FAIL / NEEDS REVIEW} — {one sentence}
```

## Worked Examples

### Example 1

INPUT:
```python
@app.route('/search')
def search():
    q = request.args.get('q')
    results = db.execute(f"SELECT * FROM products WHERE name LIKE '%{q}%'")
    return render_template('results.html', results=results, query=q)
```

OUTPUT:
```
## Security Review: search() route

### Critical (fix before merge)
| Vulnerability | Location | Risk | Fix |
|---------------|----------|------|-----|
| SQL Injection (OWASP A03) | search():3 | Attacker can dump or delete entire database | Use parameterized query: `db.execute("SELECT * FROM products WHERE name LIKE ?", (f"%{q}%",))` |
| Reflected XSS (OWASP A03) | results.html via `query` | Attacker can inject scripts into victim's browser | Auto-escape `query` in template: `{{ query | e }}` or use Jinja2 autoescaping |

### Warnings (fix soon)
| Issue | Location | Risk | Fix |
|-------|----------|------|-----|
| No input length limit on `q` | search():2 | Denial of service via huge queries | Add `q = q[:200]` or validate with max_length |

### Verdict
FAIL — two critical vulnerabilities. Do not merge until fixed.
```

### Example 2

INPUT:
```javascript
const token = 'sk-prod-abc123xyz'; // OpenAI key
const apiKey = process.env.INTERNAL_API_KEY || 'fallback-secret';
```

OUTPUT:
```
## Security Review: API key handling

### Critical (fix before merge)
| Vulnerability | Location | Risk | Fix |
|---------------|----------|------|-----|
| Hardcoded secret | line 1 | Key exposed in git history forever | Rotate key immediately. Move to env var: `process.env.OPENAI_KEY` |
| Hardcoded fallback secret | line 2 | Fallback used in production if env var missing | Remove fallback. Fail fast: `if (!process.env.INTERNAL_API_KEY) throw new Error('INTERNAL_API_KEY not set')` |

### Verdict
FAIL — secrets are in source. Rotate both keys now, then fix.
```

## OWASP Top 10 Checklist (Secondary Reference)

Run through this for any code handling user input or external data:

| # | Category | Check |
|---|----------|-------|
| A01 | Broken Access Control | Does every route check authorization? Are horizontal privilege escalations possible? |
| A02 | Cryptographic Failures | Any plaintext passwords, weak hashing (MD5/SHA1), unencrypted PII? |
| A03 | Injection | SQL, shell, LDAP, XML — is user input ever interpolated into a query/command? |
| A04 | Insecure Design | Are there missing rate limits, missing input validation at boundaries? |
| A05 | Security Misconfiguration | Debug mode on? Default creds? Verbose error messages leaking internals? |
| A06 | Vulnerable Components | Any dependencies with known CVEs? Check with `pip audit` or `npm audit`. |
| A07 | Auth Failures | Weak passwords allowed? Session tokens ever logged? Tokens long-lived without rotation? |
| A08 | Integrity Failures | Unsigned packages? Unvalidated deserialization? |
| A09 | Logging Failures | Are security events logged? Are logs queryable without leaking secrets? |
| A10 | SSRF | Does any endpoint make HTTP requests to a URL supplied by the user? |
