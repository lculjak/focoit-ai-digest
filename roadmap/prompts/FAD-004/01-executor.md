# FAD-004 — Owner action checklist

> No Kiro execution for this item. Complete the steps below manually, then mark
> FAD-004 done in `roadmap/pending-improvements.md` and record the outcome in
> `responses/01-executor.md`.

---

## Steps

1. Go to the repo's Pages settings:
   `https://github.com/<owner>/focoit-ai-digest/settings/pages`

2. Under **"Build and deployment"**, set:
   - Source: **Deploy from a branch**
   - Branch: **main**
   - Folder: **/ (docs)**

3. Click **Save**.

4. Wait ~30–60 seconds, then refresh. GitHub will show the Pages URL:
   `https://<owner>.github.io/focoit-ai-digest/`

5. Open the URL and confirm the placeholder `docs/index.html` loads without errors.

---

## Done when

- [ ] Pages enabled (Source: branch `main` / folder `/docs`).
- [ ] Pages URL resolves and renders the placeholder page.
- [ ] Pages URL recorded in `responses/01-executor.md`.
- [ ] FAD-004 marked ✅ Done in `roadmap/pending-improvements.md` with date + URL.

---

## Next step

With FAD-003 and FAD-004 both done, proceed to **FAD-005**: trigger the first
`workflow_dispatch` from the Actions tab and review the generated `[digest]` PR.
