# FAD-003 — Owner action checklist

> No Kiro execution for this item. Complete the steps below manually, then mark
> FAD-003 done in `roadmap/pending-improvements.md` and record the outcome in
> `responses/01-executor.md`.

---

## Prerequisite check — which account type?

**Org-owned repo** → follow the Org policy path below.
**Personal repo** → follow the Personal account path below.

---

## Path A — Org-owned repo

1. Go to your GitHub org settings:
   `https://github.com/organizations/<org>/settings/copilot/policies`

2. Confirm **"Allow use of Copilot CLI billed to the organization"** is **Enabled**.
   - This is on by default when the Copilot CLI policy is active.
   - If it is off, enable it. No additional secret is needed after that.

3. Confirm the repo has Actions enabled:
   `https://github.com/<org>/focoit-ai-digest/settings/actions`

---

## Path B — Personal repo (Copilot Pro / Pro+)

1. Confirm your personal Copilot plan is active:
   `https://github.com/settings/copilot`
   - Plan must be **Pro** or **Pro+** (Free tier does not support CLI billing).

2. No additional settings required — `copilot-requests: write` on the built-in
   `GITHUB_TOKEN` is sufficient for personal repos on Pro/Pro+.

---

## Optional cleanup

If a `COPILOT_GITHUB_TOKEN` secret was previously set in this repo, delete it:
`https://github.com/<owner>/focoit-ai-digest/settings/secrets/actions`

The new auth flow ignores it entirely, but removing it avoids confusion.

---

## Done when

- [ ] Copilot CLI policy confirmed enabled (org) OR Pro/Pro+ plan confirmed active (personal).
- [ ] `COPILOT_GITHUB_TOKEN` secret removed if it existed.
- [ ] FAD-003 marked ✅ Done in `roadmap/pending-improvements.md` with date + notes.
- [ ] Outcome recorded in `roadmap/prompts/FAD-003/responses/01-executor.md`.

---

## Next step

Once this is done, proceed to **FAD-004** (enable GitHub Pages) and then **FAD-005**
(first `workflow_dispatch` run).
