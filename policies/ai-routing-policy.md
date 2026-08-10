# AI Routing Policy — focoit-ai-digest

Version: 1.0

Status: Active

Date: 2026-08-10

> Subordinate to [model-execution-policy.md](model-execution-policy.md): first choose the execution
> **tier** and honor the **confidentiality rule**, then apply the task routing below. This repo is
> classified non-sensitive, so all tiers are available. Copied and trimmed from the AI Engineering
> Playbook's routing policy for this project's (non-.NET, static-site + agentic-CI) surface.

## Purpose

Which AI engine to use for each task type in this repo. Goals: prefer local/hosted-cheap tiers for
routine work; reserve Claude for high-value reasoning; keep quality high.

---

# Decision matrix (this repo's tasks)

| Task | Local / Copilot / Cline | Claude |
|------|-------------------------|--------|
| HTML/CSS/JS tweaks to the site template | ✅ | |
| Small refactors of the generated page structure | ✅ | |
| Docs / README / Markdown | ✅ | |
| JSON schema shaping (digest / post-ideas) | ✅ | |
| PowerShell (validator) edits | ✅ | |
| Git / GitHub Actions YAML edits | ✅ | |
| Regexes, small fixes, log analysis | ✅ | |
| Designing the gh-aw workflow + curation prompt | | ✅ |
| Curation-quality / allocation-rule tuning | | ✅ |
| Threat-model / safety review of the workflow | | ✅ |
| Multi-step planning across the repo | | ✅ |
| Final architecture / Phase-2 integration decisions | | ✅ |

---

# Local-first bias, then escalate

1. Try the cheap tier (Copilot Pro / Cline FREE / local Aider).
2. Evaluate quality.
3. Escalate to Claude when: reasoning spans many parts, the cheap tier is inconsistent, repeated
   failures occur, or the decision affects the whole system (workflow design, safety, curation logic).

---

# Quality checklist (before accepting generated changes)

- The static site still renders (open `docs/index.html`); theme/search/filters work.
- No secret or `.env` content introduced; the guardian passes.
- Changes are scoped and reviewable; no unrelated edits.
- For any gh-aw workflow change: `gh aw compile` is clean and the `.lock.yml` is committed.

---

# Revision History

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-08-10 | Initial routing policy for focoit-ai-digest — task matrix retargeted to a static-site + agentic-CI repo |
