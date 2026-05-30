---
name: changelog
description: >
  Use this skill when the user wants to generate, write, or format a changelog,
  release notes, or version history entry. Triggers on 'write a changelog',
  'generate release notes', 'what changed in this version', 'CHANGELOG.md',
  'summarize commits for release', 'what should I put in the release notes',
  or when the user pastes a list of commits or a git log and wants a release
  summary. Also triggers on 'Keep a Changelog format', 'semantic versioning
  notes', or 'what broke in this release'. Do NOT use for commit messages —
  use /skills/commit-message instead. Do NOT use for PR descriptions — use
  /skills/pr-description instead.
version: "1.0"
updated: "2026-05-30"
---

# Changelog Skill

## Output Template (Keep a Changelog format)

```
## [{version}] - {YYYY-MM-DD}

### Breaking Changes
- {change that requires action from users/callers — include migration step}

### Added
- {new feature or capability}

### Changed
- {change to existing behavior that is non-breaking}

### Fixed
- {bug fix}

### Deprecated
- {feature that will be removed in a future version}

### Removed
- {feature or API that was removed}

### Security
- {vulnerability fix — reference CVE if applicable}
```

Only include sections that have entries. Omit empty sections.

## Worked Examples

### Example 1 — From commit list

INPUT:
```
fix: correct session token expiry calculation
feat: add pagination to GET /api/users
refactor: extract email sending into EmailService
fix: handle null user gracefully in getUserById
chore: upgrade bcrypt from 4.x to 5.x
feat: add rate limiting to login endpoint (10 req/min)
BREAKING: rename response field `data` to `items` in all list endpoints
```

OUTPUT:
```
## [2.1.0] - 2026-05-17

### Breaking Changes
- Renamed `data` to `items` in all list endpoint responses — update any
  client code that reads `response.data` to use `response.items` instead

### Added
- Pagination support for GET /api/users — accepts `?page` and `per_page` params
- Rate limiting on POST /login — max 10 requests/minute per IP

### Fixed
- Session tokens now expire at the correct time (was expiring 1000x faster)
- getUserById no longer crashes when user does not exist

### Security
- Upgraded bcrypt from 4.x to 5.x (addresses timing attack in comparison)
```

### Example 2 — Bug fix release

INPUT:
Patch release. Fixed two bugs: 1) CSV export was including the header row twice.
2) Date filter on the reports page was off by one day due to timezone handling.

OUTPUT:
```
## [1.4.2] - 2026-05-17

### Fixed
- CSV export no longer duplicates the header row
- Date filter on reports page now handles timezones correctly (was off by one day)
```

## Versioning Guide (Semantic Versioning)

| Change type | Version bump | Example |
|-------------|-------------|---------|
| Breaking change | MAJOR (X.0.0) | Renamed field, removed endpoint, changed return type |
| New feature, non-breaking | MINOR (0.X.0) | New endpoint, new optional param |
| Bug fix, no new feature | PATCH (0.0.X) | Fixed crash, corrected calculation |

## Rules (Secondary Reference)

1. **Write for users, not developers** — explain impact, not implementation
2. **Breaking changes need migration steps** — never just "renamed X to Y"
3. **Group by type, not by PR** — users don't care about your PR structure
4. **Date every entry** — ISO 8601 format (YYYY-MM-DD)
5. **Link to issues** — include #123 references where helpful
6. **Security entries always** — even minor security fixes deserve their own section
