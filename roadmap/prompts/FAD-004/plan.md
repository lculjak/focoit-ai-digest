# FAD-004 — Enable GitHub Pages (main /docs) — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-004](../../pending-improvements.md#fad-004)

## Design decisions

- No code changes needed — `docs/index.html` already exists as the Pages skeleton.
- Pure owner action: one settings toggle in the GitHub UI.
- Deploy source: branch `main`, folder `/docs`. This means every merge to `main` that
  touches `docs/` automatically redeploys the site — including the weekly digest PRs.
- No custom domain for now (FAD-008 is the optional `CNAME` step, deferred).

## Scope

Files touched: none (owner action only)

Out of scope:
- Custom domain / CNAME configuration (FAD-008)
- Any workflow or code change

## Acceptance recap

- Settings → Pages → Deploy from branch → `main` / `docs`.
- Pages URL resolves and renders `docs/index.html` (the skeleton placeholder).

## Outcome

Status: Pending owner action
Commit: n/a (no code change)
Notes: Once enabled, record the Pages URL in `responses/01-executor.md` and mark
FAD-004 done in the backlog.
