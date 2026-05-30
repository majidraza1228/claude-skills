# Forward Deployed Engineer — Career Roadmap

Generated from the `forward-deployed-engineering` skill · Mode A · 2026-05-30

---

## Skills that matter most

| Skill | Why it matters |
|-------|---------------|
| Full-stack coding | Deploy and debug in customer environments with no support |
| Systems thinking | Map an enterprise's existing stack and find where to plug in |
| Fast prototyping | Build a working demo in 48 hours, not 2 weeks |
| Stakeholder communication | Translate between a CTO and a front-line analyst in the same meeting |
| Documentation | Every custom integration needs a handoff doc the customer can maintain |
| Security awareness | Enterprise environments have strict controls; you work within them |

---

## Phase 1 — Build the engineering foundation (months 1–9)

You need to be a credible engineer first. Palantir, Scale AI, and Harness.io all reject FDE candidates who can't code their way out of a real problem.

- Get comfortable in at least 2 languages: **Python + one of TypeScript, Go, or Java**
- Build 2–3 full-stack projects you can demo end-to-end
- Get real with APIs, auth, databases, and deployment (Docker, basic k8s)

**Resources:**
- YouTube: **Fireship** — rapid exposure to tools and patterns
- YouTube: **TechWorld with Nana** — k8s, Docker, CI/CD from scratch
- Project: Build an internal tool for a real team (not a toy app). Ship it.

**Verify:** You can take a vague spec and ship something working in 2 days.

---

## Phase 2 — Build the customer-facing layer (months 6–12)

FDE interviews test your ability to think in a customer context, not just code.

- Practice technical discovery: interview a real user about their workflow and map it to a system diagram
- Write one integration doc as if a stranger needs to maintain it
- Do a mock POC: pick a real enterprise tool and build a minimal integration
- Read: *The Trusted Advisor* (Maister et al.)

**Verify:** You can run a discovery conversation and produce a 1-page summary with clear next steps.

---

## Phase 3 — Target and apply (months 9–18)

| Company | Role title to search | What to expect |
|---------|---------------------|---------------|
| **Palantir** | Forward Deployed Software Engineer | Take-home deployment challenge; expect a real codebase, real constraints |
| **Anduril** | Deployment Engineer / Field Engineer | Defence context; strong systems and networking expected |
| **Scale AI** | Forward Deployed Engineer | Heavy ML ops and data pipeline work |
| **Harness.io** | Customer Engineer / Solutions Engineer | Live debugging in customer CI/CD environments |
| **Databricks** | Field Engineering | Data + ML platform; SQL and Spark expected |

**CV tip:** Lead with customer impact — *"shipped X for [customer type], reduced their Y by Z"* — not internal projects.

---

## Interview prep

### Round 1 — Coding

Standard LeetCode medium. Brush up on arrays, hashmaps, graphs. Occasionally a light systems design question (design a URL shortener, rate limiter).

### Round 2 — Customer simulation

Mock customer conversation. Scenario: the integration is broken, the customer is unhappy, the scope has changed mid-call. Evaluators watch for:

- Do you stay calm?
- Do you ask clarifying questions before promising anything?
- Do you say "let me confirm and get back to you" instead of guessing?

### Round 3 — Deployment challenge

Take-home or live: given a spec and a codebase, deploy something. Speed matters. Clarity of your documentation matters as much as the code itself. Treat the README as a deliverable.

---

## Next steps

- [ ] Pick your target company from the table above
- [ ] Identify your current phase (1, 2, or 3)
- [ ] Set a 30-day milestone for the next phase gate
- [ ] Run `/forward-deployed-engineering` Mode B for day-to-day FDE practice frameworks
