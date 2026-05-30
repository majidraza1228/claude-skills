---
name: retro
description: >
  Use this skill when the user wants to run or write up a sprint retrospective,
  team retro, project post-mortem, or incident review. Triggers on 'run a retro',
  'help me write up the retro', 'what went well this sprint', 'post-mortem for
  this incident', 'retrospective notes', 'team retrospective', 'what should we
  improve', or 'lessons learned'. Works from notes, sprint data, incident
  timelines, or a described situation. Do NOT use for sprint planning — use
  /skills/sprint-planning instead. Do NOT use for writing a single ticket —
  use /skills/ticket-writer instead.
version: "1.0"
updated: "2026-05-30"
---

# Retro Skill

## Safety — Read First

- NEVER assign blame to individuals — frame issues as system or process failures
- NEVER skip the "what went well" section — teams that only hear problems disengage
- If the user describes a serious incident (data loss, outage, security breach), recommend a formal blameless post-mortem process and flag that this skill covers lightweight retros only

## Output Template

```
## Retro: {Sprint / Project / Incident Name}
**Date:** {date}  
**Format:** {Start / Stop / Continue  |  What Went Well / Delta / Actions  |  Timeline}

---

### What Went Well
- {specific, concrete — not "good teamwork" but what specifically worked}
- {second item}

### What to Improve
- {specific process or system issue — not a person}
- {second item}

### Action Items
| Action | Owner | By when |
|--------|-------|---------|
| {specific change to make} | {name or role} | {date or sprint} |

### Parking Lot
- {item raised but not actioned — revisit later}
```

## Worked Examples

### Example 1 — Sprint retro from notes

INPUT: "Sprint 12 retro. Good: shipped the auth feature on time, PR reviews were fast this sprint. Bad: 3 bugs slipped to prod, we didn't have enough test coverage on the edge cases, standups are running too long (30+ min). Action: fix tests, shorter standups."

OUTPUT:
```
## Retro: Sprint 12
**Date:** 2026-05-30  
**Format:** What Went Well / What to Improve / Actions

---

### What Went Well
- Auth feature shipped on time and in scope — planning and estimation held
- PR review turnaround improved this sprint — most PRs reviewed within 4h of opening

### What to Improve
- 3 bugs reached production: edge cases weren't covered by the test suite
  - Root cause: acceptance criteria didn't specify edge cases, so no tests were written for them
- Standups running 30+ minutes — problem-solving is happening in standup instead of async

### Action Items
| Action | Owner | By when |
|--------|-------|---------|
| Add edge case requirements to ticket template's AC checklist | EM / PM | Sprint 13 start |
| Set standup hard stop at 15 min — blockers go to a thread, not standup | Scrum lead | Immediately |
| Audit test coverage on the 3 bug areas — write missing tests | Dev lead | Sprint 13, day 3 |

### Parking Lot
- Discussion on whether to add a staging smoke test before prod deploy — needs more time to scope
```

### Example 2 — Incident post-mortem

INPUT: "We had an outage Saturday. The deploy at 2pm broke the login endpoint. Took us 3 hours to fix because we didn't have good rollback tooling and nobody had the db credentials on hand. About 400 users affected."

OUTPUT:
```
## Retro: Login Outage — 2026-05-28
**Date:** 2026-05-30  
**Format:** Incident Timeline / What Went Well / What to Improve / Actions

---

### Timeline
- 14:00 — Deploy pushed to production
- 14:08 — First error reports in Slack (login endpoint returning 500)
- 14:15 — On-call alerted, investigation started
- 15:20 — Root cause identified (DB credential config missing in new deploy)
- 17:00 — Fix deployed, login restored
- **Total impact:** ~3h, ~400 users unable to log in

### What Went Well
- Error was detected quickly (8 min) through user reports + monitoring
- Team rallied and communicated clearly in the incident channel throughout

### What to Improve
- No automated rollback tooling — a 3-hour fix should have been a 5-minute rollback
  - Root cause: rollback procedure exists in a doc nobody could find under pressure
- DB credentials not accessible to on-call engineer — added 65+ minutes to resolution
  - Root cause: credentials stored in a personal 1Password vault, not a shared team vault
- Deploy had no staging validation step — the broken config would have been caught pre-prod

### Action Items
| Action | Owner | By when |
|--------|-------|---------|
| Set up one-command rollback script and test it on staging | DevOps | Sprint 13, day 5 |
| Move all prod credentials to shared team vault with on-call access | DevOps | This week |
| Add staging smoke test (login flow) as required CI step before prod deploy | Dev lead | Sprint 13 |
| Add login endpoint to uptime monitoring with 2-min alert threshold | DevOps | This week |

### Parking Lot
- Broader conversation about feature flags / progressive deploys — reduces blast radius for future deploys
```

### Example 3 — Quick team retro (minimal input)

INPUT: "Quick retro after a tough sprint. Team was stressed, we shipped late, but quality was good."

OUTPUT:
```
## Retro: Sprint 11
**Date:** 2026-05-30

---

### What Went Well
- Quality held despite schedule pressure — QA found only minor issues, nothing shipped broken
- Team pushed through and delivered, even under stress

### What to Improve
- Sprint shipped late — the estimate didn't account for the complexity that emerged mid-sprint
- Team stress level was high: this is a signal, not a personality issue — the system created the pressure

### Action Items
| Action | Owner | By when |
|--------|-------|---------|
| Add a mid-sprint scope check (Wednesday sync) to catch slippage earlier | Scrum lead | Sprint 12 |
| Break the largest tickets further — anything > L gets split at planning | Team | Sprint 12 planning |

### Parking Lot
- Team morale / workload conversation — schedule a dedicated 30-min session, not a retro item
```

## Facilitation Tips (Secondary Reference)

**Format options:**
| Format | Best for |
|--------|---------|
| Start / Stop / Continue | Quick, high-signal, team of 4–8 |
| What Went Well / Delta / Actions | Post-sprint, focused on process |
| 4Ls (Liked, Learned, Lacked, Longed for) | Deeper reflection, longer projects |
| Timeline | Incidents, post-mortems, project reviews |

**Action item rules:**
- Every action needs a named owner and a due date — "team will do X" means nobody will do X
- Maximum 3–5 actions per retro — more than that and none get done
- Start the next retro by reviewing last retro's actions

**Blameless framing:**
- Replace "X person didn't do Y" with "the process didn't make Y easy to do"
- Replace "we need to be more careful" with "we need a system that makes the careful thing the default"
