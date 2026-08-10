# FAD-005 — First run: dispatch → review [digest] PR → merge — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-005](../../pending-improvements.md#fad-005)

## Design decisions

- Owner triggers `workflow_dispatch` manually from the Actions tab — no code change needed
  to initiate.
- The workflow runs read-only + sandboxed; all writes flow through `safe-outputs` (one PR,
  max: 1, labels: digest + automated).
- Kiro's role in this item is **reviewer**: read the generated PR diff, check the HTML output
  and JSON data files against the acceptance checklist, and flag any issues before the owner
  merges.
- The owner merges the PR; Kiro does not merge.
- If the agent relaxed the >=8 Azure/MS floor (too few qualifying entries), it should have
  documented that in the PR body — that is acceptable for run 1.
- First run is calibration: expect to need FAD-007 tuning after seeing real AIC usage and
  feed quality.

## Scope

Files Kiro may touch during review:
- `roadmap/prompts/FAD-005/responses/01-executor.md` — owner dispatch confirmation
- `roadmap/prompts/FAD-005/responses/02-reviewer.md` — Kiro's review report
- `roadmap/pending-improvements.md` — mark done after merge

Files the workflow will touch (in the PR, not on main until merged):
- `docs/index.html`
- `docs/data/digest-YYYY-Www.json`
- `docs/data/post-ideas.json`

Out of scope:
- Any manual edits to the generated HTML/JSON
- Triggering the workflow a second time before reviewing the first PR

## Acceptance recap

- `workflow_dispatch` produces exactly one `[digest]`-labeled PR.
- Agent ran read-only + sandboxed; only write via `safe-outputs`.
- PR contains: `docs/index.html`, `docs/data/digest-YYYY-Www.json`, `docs/data/post-ideas.json`.
- Page: 15 stories (or documented relaxation), hybrid allocation satisfied, theme/search/
  filters work, renders on mobile, all cards link out.
- Highlights block uses only Azure/Microsoft/GitHub sources.
- Merging deploys to https://lculjak.github.io/focoit-ai-digest/ with no manual HTML editing.

## Outcome

Status: Pending
Commit: n/a until PR merged
Notes: Record actual AIC usage from the workflow run summary for FAD-007 tuning baseline.
