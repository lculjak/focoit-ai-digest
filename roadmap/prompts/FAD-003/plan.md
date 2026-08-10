# FAD-003 — Enable Copilot inference for the workflow — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-003](../../pending-improvements.md#fad-003)

## Context: June 2026 auth change

Prior to June 11, 2026, `engine: copilot` in gh-aw required a `COPILOT_GITHUB_TOKEN`
fine-grained PAT stored as a repo secret. That approach is now deprecated.

Since June 11, 2026 (gh-aw ≥ v0.72.x), the workflow uses the built-in `GITHUB_TOKEN`
with `copilot-requests: write` permission. Inference is billed directly to the org/account
via the Copilot CLI policy — no secret to create, rotate, or scope.

The workflow was already updated in FAD-002 (`copilot-requests: write` is in the
frontmatter). The only remaining prerequisite is an **org-level policy setting**.

## Design decisions

- No code changes needed — FAD-002 already wrote the correct frontmatter.
- This item is purely an owner action: verify one org policy, then close.
- If the repo is under a personal account (not an org), the check is slightly different
  (Copilot Pro/Pro+ plan active, rather than org policy).

## Scope

Files touched: none (owner action only)

Out of scope:
- Any secret creation
- Any workflow or code change

## Acceptance recap

- Confirm org policy "Allow use of Copilot CLI billed to the organization" is enabled.
- OR confirm personal Copilot Pro/Pro+ plan is active (for personal repos).
- Optionally delete the old `COPILOT_GITHUB_TOKEN` secret if it was previously set.
- Watch Copilot usage/AI-credit billing after the first dispatch (FAD-005).

## Outcome

Status: Pending owner action
Commit: n/a (no code change)
Notes: Owner must complete the checklist in `01-executor.md` before FAD-005 can run.
Once confirmed, mark FAD-003 done in the backlog manually and record it here.
