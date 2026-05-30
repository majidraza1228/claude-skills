---
name: pr-description
description: >
  Use this skill when the user wants to write, format, or improve a pull request
  description, PR body, or merge request summary. Triggers on 'write a PR
  description', 'PR body for this change', 'describe this pull request',
  'what should I put in the PR', 'summarize these changes for review', or when
  the user pastes a diff or commit list and wants a review-ready description.
  Also triggers on 'write a merge request', 'PR template', or 'what changed in
  this branch'. Do NOT use for commit messages — use /skills/commit-message
  instead. Do NOT use for changelogs — use /skills/changelog instead.
version: "1.0"
updated: "2026-05-30"
---

# PR Description Skill

## Output Template

```
## What & Why
{1-3 bullet points: what changed and why — focus on the problem solved, not the implementation}

## How to Test
- [ ] {step to verify the happy path}
- [ ] {step to verify an edge case}
- [ ] {step to verify nothing regressed}

## Notes for Reviewer
{optional: gotchas, non-obvious decisions, areas that need extra attention}

## Related
{Links to issue, ticket, or Slack thread — or "N/A"}
```

## Worked Examples

### Example 1

INPUT:
I fixed a bug where users were getting logged out randomly. Turned out the session token expiry was being calculated in seconds instead of milliseconds, so tokens expired 1000x faster than intended.

OUTPUT:
```
## What & Why
- Fix session token expiry calculation — tokens were expiring 1000x faster than intended
- Root cause: `Date.now()` returns milliseconds but expiry was set using a seconds value
- Users were being logged out within seconds of login in some environments

## How to Test
- [ ] Log in and stay logged in for >1 minute — session should persist
- [ ] Check token expiry in browser devtools: should be ~24h from now, not ~86 seconds
- [ ] Log out and log back in — verify clean session lifecycle

## Notes for Reviewer
The fix is a one-line change but the bug had been masked by short test sessions.
Check `auth/session.js:42` — that's where the conversion lives.

## Related
Fixes #412 — "Users randomly logged out"
```

### Example 2

INPUT:
Added pagination to the /api/users endpoint. It now accepts page and per_page query params. Default is page=1, per_page=20. Max per_page is 100.

OUTPUT:
```
## What & Why
- Add pagination to GET /api/users — previously returned all users in one response
- Accepts `?page=1&per_page=20` query params (defaults: page 1, 20 per page, max 100)
- Prevents timeouts and memory spikes on large user tables

## How to Test
- [ ] `GET /api/users` returns first 20 users with `total` and `page` in response
- [ ] `GET /api/users?page=2&per_page=5` returns correct slice
- [ ] `GET /api/users?per_page=200` clamps to 100 and doesn't error
- [ ] Existing callers that don't pass pagination params still work (backwards compatible)

## Notes for Reviewer
Response shape changed: now `{ items: [...], total: N, page: N, per_page: N }`.
Old shape was `{ data: [...] }`. Check if any frontend code needs updating.

## Related
Closes #389 — "Users endpoint times out with large datasets"
```

## PR Size Guidelines

| Lines changed | Recommended action |
|---|---|
| < 100 | Good — review in one sitting |
| 100–400 | Add extra context in Notes for Reviewer |
| 400–800 | Consider splitting — explain why it can't be split |
| > 800 | Split unless it's a single atomic refactor |

## Rules (Secondary Reference)

1. **Lead with why, not what** — reviewers can read the diff; they can't read your mind
2. **Testing steps must be runnable** — "verify it works" is not a step
3. **Flag non-obvious decisions** — if you had to think hard about it, the reviewer will too
4. **Link the issue** — every PR should trace back to a ticket or decision
5. **Backwards compatibility** — always call out if the change breaks existing callers
