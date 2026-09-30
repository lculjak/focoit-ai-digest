# Pending Improvements — focoit-ai-digest

Version: 1.5

Status: Open

Date: 2026-09-30

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

Status: ✅ **Done — actually, as of 2026-09-09.** Site live: https://lculjak.github.io/focoit-ai-digest/
Merging a digest PR now auto-deploys the site with no manual steps.

Priority: High

Acceptance

- Settings → Pages → Deploy from branch → `main` / `docs`. Merging the digest PR deploys the site.
- **Load the site URL and get a 200.** Added 2026-09-09 — the criterion above describes a settings
  screen, and a settings screen is not a served page. See below.

### ⚠️ This item read ✅ Done from 2026-08-10 and was not true for a month

**The claim was `main` / `/docs`. The configuration was neither.** Measured 2026-09-09 against the
Pages API:

```
build_type: "workflow"        <- waits for a Pages deploy workflow; none exists in .github/workflows/
source:     { branch: "main", path: "/" }   <- "/", not "/docs"; there is no index.html at the root
builds:     none, ever
```

**Two independent faults, either one enough alone.** `build_type: workflow` means Pages waits for a
deploy workflow that was never written, so **nothing ever built** — zero builds, zero deployments, and
`/`, `/docs/`, `/index.html` and `/docs/index.html` all returned **404**. The `path` was wrong too, so
even switching to branch-deploy without correcting it would still have served nothing.

**The consequence is the part worth keeping.** Because this item read ✅ Done, the unmerged digest PRs
looked like the only thing between a run and a published page. They were not: **merging them would
have published nothing.** Three (W35/W36/W37) sat open from 2026-08-24 while the backlog said the
publishing path was finished. The site was believed working for a month because **the status was
written from the intent, not from the result** — nobody loaded the URL.

**Fixed 2026-09-09:** `build_type` → `legacy`, `source` → `main` `/docs` — what this item claimed all
along. Verified in the order that keeps the two questions apart: a build was triggered **before** any
digest PR was merged, so *"does Pages work"* was answered independently of *"do the merges work"*.
Result **built in 43s, site 200**. W35/W36/W37 were then merged oldest-first (each rewrote
`docs/index.html` and `post-ideas.json`, so #7 and #8 needed conflict resolution taking the newer
week); a second build (39s) serves **W37**, with all four archives `W33/W35/W36/W37` intact.

**W34 is permanently missing and is not a gap to backfill.** The 2026-08-17 scheduled run **failed** on
the Copilot CLI path bug that PR #5 fixed on 2026-08-20. The workflow reads the last 14 days, so a
backfill today would return current stories under a W34 label — a worse record than an honest gap.

**The lesson is not "check Pages".** It is that **a status asserting an outcome nobody observed is
indistinguishable from one that was verified**, and nothing here could tell them apart. Hence the new
acceptance line above: the old one described a settings screen.

## FAD-005 — First run: dispatch → review `[digest]` PR → merge

Status: ✅ Done (2026-09-30) — criteria met on **different dates**, recorded as such. **Run + PR:**
first dispatch produced PR #2 (`[digest]` 2026-W33, labels `digest` + `automated`, exactly the three
expected `docs/` files); reviewer **PASS** 2026-08-10
([response](prompts/FAD-005/responses/02-reviewer.md)); merged 2026-08-20. **Deploy-on-merge was
*not* met by that merge** — Pages was misconfigured (see FAD-004) and it published nothing. First
met **2026-09-09**, when W35/W36/W37 merged onto working Pages and the site served W37 with no manual
HTML editing. **Mobile** was not in the 2026-08-10 review; checked 2026-09-30 on the live URL at
375 px: **200**, no horizontal scroll, 15 outbound cards, Azure/Microsoft + GitHub source chips
selected by default (by design, per the workflow spec), so the counter reads *10 of 15* on load.

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

Status: Open — **one baseline recorded**: W33 used **125.7 AIC (+12.4 overhead)** against the 500 cap
(~25%) ([FAD-005 review](prompts/FAD-005/responses/02-reviewer.md)). One run is not a trend — no
tuning decision yet.

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
| 1.4 | 2026-09-09 | **FAD-004's ✅ Done was false for a month, and the site was never live.** Measured against the Pages API: `build_type` was **`workflow`** — waiting on a deploy workflow that does not exist in `.github/workflows/` — and `source.path` was **`/`**, not `/docs`. **Zero builds ever**; `/`, `/docs/`, `/index.html` and `/docs/index.html` all **404**. Two independent faults, either enough alone. **What it cost:** the ✅ made the unmerged digest PRs look like the only thing between a run and a published page, when **merging them would have published nothing** — three sat open from 2026-08-24 while this backlog said publishing was finished. **Fixed:** `legacy` + `main` `/docs`, with the build triggered **before** any merge so *"does Pages work"* stayed separable from *"do the merges work"* — **built 43s, site 200**. W35/W36/W37 then merged oldest-first with conflict resolution on `docs/index.html` and `post-ideas.json` (each rewrites both); second build 39s, serving **W37**, archives `W33/W35/W36/W37` intact. **W34 stays missing on purpose** — its 2026-08-17 run failed on the Copilot CLI path bug PR #5 fixed, and the workflow reads the last 14 days, so a backfill would file current stories under a W34 label. **A new acceptance line added: load the URL and get a 200** — the original criterion described a settings screen, and a settings screen is not a served page. **Also corrected in passing: this file's own header said `Version: 1.1` while its revision history ended at `1.3`** — the same defect in miniature, a record disagreeing with itself because nobody re-read it |
| 1.5 | 2026-09-30 | **FAD-005 done, with the dates it was actually met.** Run + PR #2 reviewed PASS 2026-08-10 and merged 2026-08-20, but that merge **deployed nothing** (FAD-004's broken Pages), so *"merging deploys"* was first met **2026-09-09** (W35–W37). **Mobile was never in the original review** — verified 2026-09-30 on the live URL at 375 px rather than inferred from the PASS. FAD-007 gets its first **AIC baseline** (125.7 + 12.4 overhead, ~25% of cap), marked as one data point, not a trend |
