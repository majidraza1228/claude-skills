---
description: Refresh the "What's new" section on docs/claude.html with updates from the last 2 weeks
allowed-tools: Bash, Read, Edit, WebFetch
---

Update the **What's new** section in `docs/claude.html` to cover the last 2 weeks.

## What "last 2 weeks" means

Compute the window as **today minus 14 days → today**. Show both dates in the eyebrow:
`What's new — last 2 weeks (May 30 → Jun 13, 2026)` (use the real current dates).

## Sources — fetch all three in parallel

1. **Playbook changes** (verified, local):
   ```bash
   git log --since="2 weeks ago" --pretty=format:"%h %ad %s" --date=short
   ```

2. **Anthropic news** (web):
   `WebFetch` `https://www.anthropic.com/news` — extract posts from the window only.

3. **Claude Code changelog** (web):
   `WebFetch` `https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md` — entries from the window only.

## Section structure to preserve

Replace **everything** between `<!-- WHATS-NEW:START -->` and `<!-- WHATS-NEW:END -->` in `docs/claude.html`. Keep this skeleton:

```
1. Headline card    — the single biggest release in the window (new model, major CC feature)
                       Include model ID, link to announcement, 4–6 bullet improvements, "Adopt this week" apply-box
2. Anthropic news   — table: Date | Update (linked) | Why it matters for dev/PM
3. Playbook updates — table: Date | What | Jump-to anchor
4. Adoption         — two-column .tool-grid: For developers / For PMs (ordered lists, 3–5 items each)
```

Reuse existing classes already on the page: `.ag-section`, `.ag-eyebrow`, `.ag-title`, `.ag-lead`, `.card`, `.trigger-table`, `.tool-grid`, `.tool-section-title`, `.apply-box`, `.btn-outline`, `.tool-badge`. Do not introduce new CSS.

## Rules

- **Don't fabricate.** If a category has nothing in the window, drop that block — better an empty section than invented news.
- **Cite every external claim** with a real link to anthropic.com or the changelog.
- **Headline = biggest impact**, not biggest announcement. A new Opus release beats a partnership press release.
- Keep the `id="whats-new"` and the sidebar entry pointing to it untouched.
- Adoption checklists must reference real existing skills or sections — link to them with anchors (`#subagents-examples`, etc.) or files (`guide.html`).
- Update the eyebrow date range to the real new window.

## After editing

- Show a diff summary of what changed (headline, new items added, items dropped).
- Do not commit unless asked.
