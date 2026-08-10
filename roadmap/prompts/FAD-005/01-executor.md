# FAD-005 — Owner action: trigger first workflow_dispatch

> No Kiro execution for this step. Complete the steps below manually, then record
> the outcome in `responses/01-executor.md` so Kiro can proceed with the review.

---

## Steps

1. Go to the Actions tab:
   `https://github.com/lculjak/focoit-ai-digest/actions`

2. Select **"Weekly Focoit AI & Cloud Digest"** from the workflow list on the left.

3. Click **"Run workflow"** → **"Run workflow"** (branch: main).

4. Wait for the run to complete (~10–20 min depending on feed fetch time).

5. Once the run succeeds, a PR will appear labeled `digest` + `automated`:
   `https://github.com/lculjak/focoit-ai-digest/pulls`

---

## Record in responses/01-executor.md

- Workflow run URL (Actions tab link to the specific run)
- PR URL
- Actual AI credits consumed (shown in the run summary)
- Whether the run succeeded or had any warnings/errors

---

## Done when

- [ ] Workflow run completed successfully.
- [ ] `[digest]` PR opened with labels `digest` + `automated`.
- [ ] Run details recorded in `responses/01-executor.md`.

Then hand off to Kiro for the review step (`02-reviewer.md`).
