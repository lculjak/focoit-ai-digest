# FAD-005 — Reviewer prompt (Kiro)

<!-- Paste this entire file into Kiro once the owner has completed 01-executor.md. -->

The first `workflow_dispatch` run for focoit-ai-digest has completed. A `[digest]` PR is
open. The owner's run summary is at `roadmap/prompts/FAD-005/responses/01-executor.md`.

Review the PR against the FAD-005 acceptance checklist and produce a PASS or FAIL report.

## What to check

### PR structure
- [ ] Exactly one PR open with labels `digest` + `automated`.
- [ ] PR contains all three expected files:
  - `docs/index.html`
  - `docs/data/digest-YYYY-Www.json`
  - `docs/data/post-ideas.json`
- [ ] No unexpected files modified (e.g. workflow files, backlog, scripts).

### Story count and allocation
- [ ] Exactly 15 stories in `digest-YYYY-Www.json` (or a documented relaxation in the PR body).
- [ ] >= 8 stories from Azure/Microsoft + GitHub/Copilot sources combined (or documented relaxation).
- [ ] <= 3 stories from any single non-Microsoft/GitHub source.
- [ ] Each story has: title, url, source, date, tldr, why, importance, tags.
- [ ] All story URLs are unique.

### Highlights block
- [ ] Exactly 5 items in the highlights block.
- [ ] All 5 use only Azure/Microsoft/GitHub sources (no cross-source blending).

### post-ideas.json
- [ ] 3–5 LinkedIn post angles present.
- [ ] Each has: hook, angle, which_story_urls, suggested_track.

### docs/index.html
- [ ] Self-contained (no CDN links, no external JS/CSS).
- [ ] Theme toggle present (system/light/dark).
- [ ] Source filter chips present (Azure/Microsoft + GitHub selected by default).
- [ ] Tag filters present.
- [ ] Importance filter present.
- [ ] Full-text search functional (check the JS — does it reference title, source, tldr, tags?).
- [ ] "Showing X of 15 stories" counter present.
- [ ] Each card links out to the original source URL.
- [ ] Footer with "generated weekly by an agentic workflow" + last-updated timestamp.
- [ ] No secrets or hardcoded credentials in the HTML.

### Security / safety
- [ ] Agent ran read-only — no workflow file changes, no script changes, no backlog changes.
- [ ] `validate-repository.ps1 -All` would pass (no secrets in new files).

## Output

Respond PASS or FAIL with a brief summary. For FAIL, list each issue with file/location
and a suggested fix. Note the actual AIC usage from the owner's response for FAD-007 tuning.

Save your report to `roadmap/prompts/FAD-005/responses/02-reviewer.md`.
