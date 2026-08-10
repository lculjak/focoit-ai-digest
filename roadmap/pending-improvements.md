# Pending Improvements — focoit-ai-digest

Version: 1.1

Status: Open

Date: 2026-08-10

---

# Purpose

The backlog the dogfooding loop consumes (one item / tight slice per commit). Seeded from the draft
spec's setup checklist (§10) and Phase-1 acceptance (§11). Each item records why it matters and what
"done" looks like. See [CLAUDE.md](../CLAUDE.md) for the loop.

---

# Backlog

## FAD-001 — Adopt the AI Engineering Playbook framework (scaffold)

Status: ✅ Done (2026-08-10) — repo scaffolded with the playbook's adoption layer, **re-scoped** for a
non-sensitive static-site / gh-aw project: adapted `policies/` (execution + routing), a re-scoped
deterministic Guardian (`scripts/validate-repository.ps1` — secrets + structure + large-file; dropped
the reusable-only/doc-metadata rules), `.githooks/pre-commit` + `setup-hooks.ps1`,
`.github/workflows/guardian.yml` (CI), `CLAUDE.md`, this backlog, and the `docs/` Pages skeleton.

Priority: High

Acceptance

- Deterministic gate runs on commit and in CI; `validate-repository.ps1 -All` is clean.
- Confidentiality tier + loop written down (CLAUDE.md + policies).

## FAD-002 — Author + compile the gh-aw workflow

Status: ✅ Done (2026-08-10) — workflow authored, all feed URLs validated, frontmatter corrected for
gh-aw v0.85.4 (`github/gh-aw`); `gh aw compile` clean (0 errors, 0 warnings). Key changes vs. draft:
`copilot-requests: write` replaces the deprecated `COPILOT_GITHUB_TOKEN` PAT (gh-aw ≥ June 2026);
`base` → `base-branch`; schedule → fuzzy `weekly on monday around 11:00`; `max-ai-credits` raised
from 60 → 500 (60 was far below minimum viable for an agentic digest run); 13 confirmed RSS/Atom feed
URLs added inline with fallback notes for Anthropic (no official RSS) and Azure Updates (CDN feed
broken since mid-2024). Lock file (`.lock.yml`, 109 KB) and `.github/aw/actions-lock.json` committed.

Priority: High

Acceptance

- `gh extension install githubnext/gh-aw` (pin a version). ✅ (`github/gh-aw` v0.85.4 already installed)
- Validate the exact RSS/Atom feed URLs for each source host (some gate or move feeds). ✅
- Verify the `engine: copilot` frontmatter compiles (e.g. confirm `max-ai-credits` / cost fields are
  valid for the Copilot engine; adjust per the gh-aw reference). ✅
- `gh aw compile` clean (0/0); commit `weekly-ai-digest.md` + `.lock.yml` +
  `.github/aw/actions-lock.json` together. ✅

## FAD-003 — Enable Copilot inference for the workflow (owner-only)

Status: ✅ Done (2026-08-10) — Copilot Pro verified active on the personal account.
`copilot-requests: write` on the built-in `GITHUB_TOKEN` is sufficient; no PAT was ever
set, nothing to clean up.

Priority: High

Context

As of June 2026, `engine: copilot` no longer requires a `COPILOT_GITHUB_TOKEN` fine-grained PAT.
The workflow now uses `copilot-requests: write` on the built-in `GITHUB_TOKEN` — inference is billed
directly to the org/account. **No repo secret is needed.** The one prerequisite is an org-level
policy: *"Allow use of Copilot CLI billed to the organization"* must be enabled (it is on by default
when the Copilot CLI policy is active).

Acceptance

- Confirm org policy "Allow use of Copilot CLI billed to the organization" is enabled
  (Settings → Copilot → Policies, or the org admin panel).
- If the repo is personal (not org-owned), verify the account has an active Copilot Pro/Pro+ plan.
- Optionally: delete the old `COPILOT_GITHUB_TOKEN` secret if it was previously set
  (Settings → Secrets → Actions) — the new flow ignores it entirely.
- Watch Copilot usage/AI-credit billing after first run; treat month 1 as calibration.

## FAD-004 — Enable GitHub Pages (main /docs)

Status: ✅ Done (2026-08-10) — Pages enabled: branch `main` / folder `/docs`.
Site URL: https://lculjak.github.io/focoit-ai-digest/
Merging any digest PR now auto-deploys the site with no manual steps.

Priority: High

Acceptance

- Settings → Pages → Deploy from branch → `main` / `docs`. Merging the digest PR deploys the site.

## FAD-005 — First run: dispatch → review `[digest]` PR → merge

Status: Open

Priority: Medium

Acceptance

- Manual `workflow_dispatch` produces a single `[digest]`-labeled PR with an updated
  `docs/index.html`, `docs/data/digest-YYYY-Www.json`, and `docs/data/post-ideas.json`.
- Agent ran read-only + sandboxed; only write was via `safe-outputs`.
- Page: 15 stories, hybrid allocation satisfied (or documented relaxation), theme/search/filters work,
  renders on mobile, all cards link out; highlights block uses only Azure/Microsoft/GitHub sources.
- Merging deploys to the Pages URL with no manual HTML editing.

## FAD-006 — Auto-merge workflow (label-gated, disabled first)

Status: Open

Priority: Low

Context

`auto-merge-digest.yml` (plain Action): on a PR labeled `digest` + `automated`, wait for checks then
`gh pr merge --squash --auto`. Recommend **manual merge for ~3 weeks** to calibrate curation, then
enable.

Acceptance

- Workflow present but effectively manual until curation quality is trusted; then enabled.

## FAD-007 — Observe + tune (2–3 runs)

Status: Open

Priority: Low

Acceptance

- After 2–3 weekly runs, tune the `>=8` Azure/MS allocation floor, `max-ai-credits`, and the feed list
  (e.g. drop HN if noisy; handle Anthropic/OpenAI feeds lacking clean RSS).

## FAD-008 — Phase 2: surface on focoit.com (link first)

Status: Open — deferred (after the digest is proven).

Priority: Low

Acceptance

- Add a "Weekly AI Digest" link on focoit.com → the Pages URL (#1, zero coupling). Optional later:
  `CNAME` = `digest.focoit.com`. Do **not** wire cross-repo automation into `focoitwebsite` yet.

---

# Revision History

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-08-10 | Initial backlog seeded from the draft spec (§10 setup + §11 acceptance); FAD-001 adoption scaffold done |
| 1.1 | 2026-08-10 | FAD-002 done: workflow compiled clean; FAD-003 updated to reflect June 2026 PAT-free auth change |
| 1.2 | 2026-08-10 | FAD-003 done: Copilot Pro verified active (personal account, Path B) |
| 1.3 | 2026-08-10 | FAD-004 done: GitHub Pages enabled at https://lculjak.github.io/focoit-ai-digest/ |
