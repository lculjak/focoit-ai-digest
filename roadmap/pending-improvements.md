# Pending Improvements — focoit-ai-digest

Version: 1.0

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

Status: Open

Priority: High

Context

`.github/workflows/weekly-ai-digest.md` is authored from the spec (§4) but **not yet compiled** —
`gh aw compile` needs the `githubnext/gh-aw` extension installed locally. Until then there is no
`.lock.yml` and the workflow cannot run.

Acceptance

- `gh extension install githubnext/gh-aw` (pin a version).
- Validate the exact RSS/Atom feed URLs for each source host (some gate or move feeds).
- `gh aw compile` clean (0/0); commit `weekly-ai-digest.md` + `.lock.yml` +
  `.github/aw/actions-lock.json` together.

## FAD-003 — Add the `ANTHROPIC_API_KEY` repo secret (owner-only)

Status: Open — **owner action** (Claude must not enter secrets).

Priority: High

Acceptance

- Repo secret `ANTHROPIC_API_KEY` set (Settings → Secrets → Actions). Set a billing alert on the
  Anthropic account; treat month 1 as calibration.

## FAD-004 — Enable GitHub Pages (main /docs)

Status: Open

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
