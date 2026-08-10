# FAD-002 — Executor prompt (Kiro)

<!-- Frozen. Paste-ready prompt as sent to Kiro. -->

Context: `roadmap/pending-improvements.md` FAD-002.

## Task

Compile the `weekly-ai-digest` gh-aw workflow so the repo has a valid `.lock.yml` and
`actions-lock.json`. The workflow file `.github/workflows/weekly-ai-digest.md` exists but has
never been compiled.

Steps:

1. Research the current `github/gh-aw` extension version and schema (the repo moved from
   `githubnext/gh-aw`). Confirm what `engine: copilot` frontmatter fields are valid, especially
   `max-ai-credits`, auth, and `safe-outputs.create-pull-request`.

2. Validate the RSS/Atom feed URLs for all 12 source domains listed in the workflow's Research
   section. Some feeds have moved or broken (notably the Azure Updates CDN feed). Find confirmed
   live URLs for each source.

3. Update `.github/workflows/weekly-ai-digest.md`:
   - Fix any frontmatter fields that don't match the current gh-aw schema.
   - Add the confirmed RSS/Atom feed URLs inline in the Research section.
   - Document fallback instructions for any source that lacks a clean RSS feed.

4. Run `gh aw compile weekly-ai-digest` from the repo root.
   Fix any errors iteratively until the compile is clean (0 errors, 0 warnings).

5. Commit `.github/workflows/weekly-ai-digest.md` + `.github/workflows/weekly-ai-digest.lock.yml`
   + `.github/aw/actions-lock.json` together in one atomic commit. Also update
   `roadmap/pending-improvements.md` to mark FAD-002 done.

## Gates

- `pwsh -NoProfile -File scripts/validate-repository.ps1 -All` must pass (0 blocking, 0 warnings).
- `gh aw compile weekly-ai-digest` must exit 0 with 0 errors and 0 warnings.

## Done when

- Lock file exists at `.github/workflows/weekly-ai-digest.lock.yml`.
- `actions-lock.json` exists at `.github/aw/actions-lock.json`.
- Guardian gate passes.
- FAD-002 marked done in the backlog.
