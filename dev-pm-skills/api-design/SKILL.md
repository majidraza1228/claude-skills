---
name: api-design
description: >
  Use this skill when the user is designing, reviewing, or changing an API,
  module interface, function signature, or public contract. Triggers on 'design
  an API', 'review this API', 'what should this endpoint return', 'API contract',
  'REST endpoint design', 'function interface', 'schema design', or 'breaking
  change'. Also triggers on 'should I add a parameter', 'versioning strategy',
  or 'backwards compatibility'. Do NOT use for implementing internal logic
  behind an API — use /skills/code-review instead.
version: "1.0"
updated: "2026-05-30"
---

# API Design Skill

## Safety — Read First

- NEVER design APIs that expose internal implementation details in error messages
- NEVER accept raw user input without validation at the boundary
- Flag any endpoint that returns sensitive fields (tokens, passwords, PII) without explicit justification
- If a change breaks existing clients, classify as BREAKING CHANGE and require a migration path

## Core Principle: Contract First

Define the contract before any code. The contract is:
1. **What goes in** — inputs, types, required vs optional, validation rules
2. **What comes out** — outputs, types, shape for success and error cases
3. **What can go wrong** — error codes, error messages, retry guidance
4. **What it promises** — side effects, idempotency, rate limits

## Output Template

Format every API design review using this structure:

```
## Contract Summary
Endpoint/Function: {name}
Method/Signature: {HTTP method or function signature}
Purpose: {one sentence}

## Input Contract
| Field | Type | Required | Validation | Notes |
|-------|------|----------|------------|-------|
| {field} | {type} | {yes/no} | {rules} | {notes} |

## Output Contract
Success ({status code}):
{schema or example}

Error cases:
| Code | Condition | Response |
|------|-----------|----------|
| {code} | {when} | {body} |

## Breaking Change Assessment
{BREAKING / NON-BREAKING} — {reason}
{Migration path if breaking}

## Verdict
{APPROVE / REVISE} — {one sentence justification}
```

## Worked Examples

### Example 1

INPUT:
I'm adding a `GET /users/:id` endpoint. It should return the user's profile.

OUTPUT:
```
## Contract Summary
Endpoint: GET /users/:id
Purpose: Retrieve a user's public profile by ID.

## Input Contract
| Field | Type | Required | Validation | Notes |
|-------|------|----------|------------|-------|
| id | string (path) | yes | UUID v4 format | Return 404 if not found |

## Output Contract
Success (200):
{
  "id": "uuid",
  "username": "string",
  "created_at": "ISO 8601",
  "avatar_url": "string | null"
}

Error cases:
| Code | Condition | Response |
|------|-----------|----------|
| 404 | User not found | { "error": "user_not_found" } |
| 400 | Invalid UUID format | { "error": "invalid_id_format" } |
| 401 | Unauthenticated | { "error": "unauthorized" } |

## Breaking Change Assessment
NON-BREAKING — new endpoint, no existing clients affected.

## Verdict
APPROVE — clean contract, proper error semantics.
```

### Example 2

INPUT:
I want to rename the `email` field to `email_address` in the user response.

OUTPUT:
```
## Contract Summary
Change: Rename response field `email` → `email_address` in GET /users/:id

## Breaking Change Assessment
BREAKING — any client reading `response.email` will get undefined after this change.

Migration path:
1. Add `email_address` alongside `email` in v1 response (dual-write)
2. Document deprecation of `email` with sunset date
3. Remove `email` in v2 (version the endpoint or use a header)

## Verdict
REVISE — ship as additive change first, deprecate `email`, then remove in v2.
```

## Design Rules (Secondary Reference)

1. **Hyrum's Law:** Any observable behavior will be depended on. If you expose it, treat it as a contract.
2. **One-version rule:** Prefer one authoritative version. Versioning is expensive — exhaust additive options first.
3. **Errors are part of the contract:** Every error code is a promise. Be specific and consistent.
4. **Validate at the boundary:** Never trust input from outside your system. Validate before it touches business logic.
5. **Idempotency for mutations:** POST/PUT/DELETE that may be retried should be idempotent or clearly documented as not.
6. **No internal leakage:** Stack traces, database errors, and internal field names must not appear in API responses.
