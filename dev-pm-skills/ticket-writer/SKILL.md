---
name: ticket-writer
description: >
  Use this skill when the user wants to write a well-formed ticket, issue, or
  task for Jira, Linear, GitHub Issues, or any task tracker. Triggers on 'write
  a ticket for', 'create a Jira issue', 'turn this into a Linear ticket', 'write
  up this bug', 'help me write an issue', 'make a task for', or when the user
  pastes rough notes and asks to formalize them into a ticket. Also handles
  bug reports, feature requests, and technical debt tickets. Do NOT use for
  planning a full sprint — use /skills/sprint-planning instead. Do NOT use for
  writing a full PRD — use /skills/spec-writer instead.
version: "1.0"
updated: "2026-05-30"
---

# Ticket Writer Skill

## Safety — Read First

- NEVER include credentials, tokens, or PII from any pasted context in the ticket output
- NEVER invent acceptance criteria the user hasn't implied — flag gaps and ask
- If the ticket involves a security issue, add a SECURITY label and flag it for private triage

## Output Template

```
**Title:** {verb + subject — max 72 chars, imperative mood}

**Type:** {Bug / Feature / Chore / Spike / Debt}  
**Priority:** {Critical / High / Medium / Low}  
**Estimate:** {story points or T-shirt size}  
**Labels:** {comma-separated}

---

**Problem / Context**
{2–4 sentences. What's broken or missing, and why it matters. For bugs: what the user sees vs. what should happen.}

**Acceptance Criteria**
- [ ] {criterion 1 — specific, testable, starts with a verb}
- [ ] {criterion 2}
- [ ] {criterion 3}

**Technical Notes** *(optional)*
{Implementation hints, files to touch, known gotchas. Skip if not relevant.}

**Out of scope**
- {thing explicitly not included in this ticket}

**Linked issues / context**
- {#issue or URL if applicable}
```

## Worked Examples

### Example 1 — Bug ticket

INPUT: "Users are getting logged out randomly. Seems to happen after about 30 mins. JWT expiry might be set too short."

OUTPUT:
```
**Title:** Fix premature session expiry logging users out after ~30 minutes

**Type:** Bug  
**Priority:** High  
**Estimate:** M (4–8h)  
**Labels:** auth, regression, user-reported

---

**Problem / Context**
Users are being logged out unexpectedly after approximately 30 minutes of activity. The likely cause is a JWT expiry value set too short or a refresh token flow that isn't extending the session on activity. This is a regression — sessions previously lasted the full 24h intended lifetime.

**Acceptance Criteria**
- [ ] Identify the current JWT expiry config value and compare against intended value
- [ ] Sessions remain active for 24h with continued activity (verified by manual test + automated test)
- [ ] Idle sessions expire after the configured inactivity timeout (not wall-clock expiry)
- [ ] No users are logged out mid-session on staging after the fix is deployed

**Technical Notes**
- Check `config/auth.yaml` for `jwt_expiry` and `refresh_token_ttl` values
- Review the refresh token middleware — confirm it's touching the session TTL on each authenticated request
- Check if the bug was introduced in the auth refactor (commit range: last 2 weeks)

**Out of scope**
- Session management UI (showing users their active sessions)
- Changing the inactivity timeout policy — that's a product decision

**Linked issues / context**
- Related to #234 (auth refactor)
```

### Example 2 — Feature ticket

INPUT: "We need dark mode. Users have been asking for it. It should respect the OS setting by default."

OUTPUT:
```
**Title:** Add dark mode support with OS preference detection

**Type:** Feature  
**Priority:** Medium  
**Estimate:** L (1–2 days)  
**Labels:** ui, accessibility, user-requested

---

**Problem / Context**
Users have repeatedly requested dark mode. Working in bright-light environments or at night with the current light-only UI causes eye strain. Dark mode should follow the OS preference by default (`prefers-color-scheme`) and allow manual override via a toggle in settings.

**Acceptance Criteria**
- [ ] App detects `prefers-color-scheme: dark` and applies dark theme on load
- [ ] Manual toggle in Settings > Appearance persists across sessions (localStorage)
- [ ] Toggle overrides OS preference when set
- [ ] All existing pages and components render correctly in dark theme (no missing contrast, no hard-coded colors)
- [ ] Dark theme passes WCAG AA contrast ratio on all interactive elements

**Technical Notes**
- Use CSS custom properties (`--bg`, `--text`, etc.) — avoid hard-coded hex in components
- Add `data-theme="dark"` on `<html>` and drive all colors from `:root[data-theme="dark"]` overrides
- Audit for any `color: #fff` or `background: #000` hard-codes that will break in light mode

**Out of scope**
- Per-page theme customization
- High-contrast / accessibility theme (separate ticket)

**Linked issues / context**
- Requested in user feedback thread: #threads/ux-feedback
```

### Example 3 — Technical debt ticket

INPUT: "Our auth middleware is copy-pasted in 6 different routes. We need to centralize it."

OUTPUT:
```
**Title:** Extract duplicated auth middleware into a single shared module

**Type:** Debt  
**Priority:** Medium  
**Estimate:** S (2–4h)  
**Labels:** refactor, auth, maintainability

---

**Problem / Context**
Auth token validation logic is copy-pasted across 6 route files. Any change to auth behavior (e.g., new token fields, expiry logic) requires 6 edits and risks divergence. This has already caused one bug where one copy wasn't updated during the JWT migration.

**Acceptance Criteria**
- [ ] Single `middleware/auth.js` (or equivalent) contains all token validation logic
- [ ] All 6 routes import from this shared module — no inline validation
- [ ] Behavior is identical before and after (existing integration tests pass unchanged)
- [ ] No new logic introduced — this is a pure extraction

**Technical Notes**
- Files to refactor: `routes/users.js`, `routes/projects.js`, `routes/billing.js`, `routes/admin.js`, `routes/api.js`, `routes/webhooks.js`
- Use the version in `routes/users.js` as the source of truth — it's the most recently updated

**Out of scope**
- Changing auth behavior or adding new checks
- Migrating to a different auth library

**Linked issues / context**
- Divergence bug from JWT migration: #189
```

## Ticket-Writing Rules (Secondary Reference)

**Title formula:** `{Verb} {object} {qualifier}`
- Bug: "Fix {what breaks} {when/where}"
- Feature: "Add {capability} {for whom/context}"
- Chore: "Extract / Remove / Update / Migrate {thing}"
- Spike: "Investigate / Evaluate {question}"

**Acceptance criteria formula:** "Given {context}, when {action}, then {outcome}"
- Must be independently testable
- Must be completable by a single engineer without follow-up questions
- Aim for 3–5 criteria — more means the ticket is too large

**When to split a ticket:**
- Estimate is XL or larger
- More than 6 acceptance criteria
- Requires simultaneous changes to more than 3 separate systems
- Frontend and backend changes that can ship independently
