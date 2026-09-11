# AI Routing Policy — focoit-ai-digest

Version: 1.2

Status: Active

Date: 2026-09-02

> Subordinate to [model-execution-policy.md](model-execution-policy.md): first choose the execution
> **tier** and honor the **confidentiality rule**, then apply the task routing below. This repo is
> classified non-sensitive, so all tiers are available. Copied and trimmed from the AI Engineering
> Playbook's routing policy for this project's (non-.NET, static-site + agentic-CI) surface.

## Purpose

Which AI engine to use for each task type in this repo. Goals: prefer local/hosted-cheap tiers for
routine work; reserve Claude for high-value reasoning; keep quality high.

> **Scope note (playbook v1.2, PI-042):** routing decides *which model*, which measurement puts at
> about **16%** of actual cost. The larger share — **~84%** — is cache mechanics driven by **context
> size**. This is the **smaller lever**; the playbook's `cost-discipline-policy.md` holds the larger
> one. That doc is deliberately **not mirrored here** (this repo has no measured session data), so
> the pointer is to the playbook, not to a local file.

---

# Decision matrix (this repo's tasks)

| Task | Local / DeepSeek / Cline | Claude |
|------|--------------------------|--------|
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

1. Try the cheap tier — **named by property, not product** (playbook PI-083): the fastest route this repo's `model-execution-policy.md` permits for non-sensitive work. **Currently the DeepSeek API in Claude Code.** *(This line read `Copilot Pro / Cline FREE / local Aider` until 2026-09-11; **all three were stale** — Copilot Pro stopped, Cline is metered and unfunded, Aider too slow to reach for.)*
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
| 1.1 | 2026-09-02 | Propagated playbook routing-policy **v1.2** (PI-042) and the **Tier-2 restructure** (`model-execution-policy.md` v1.13–v1.14, PI-069). Adds the **scope note**: routing is ~**16%** of measured cost and context size is the rest, so this is the *smaller* lever — pointed at the playbook's `cost-discipline-policy.md`, which the registry deliberately does **not** mirror here. Matrix column **`Local / Copilot / Cline` → `Local / DeepSeek / Cline`**: **Copilot Pro is stopped**. Task rows, the local-first bias and this repo's quality checklist are **unchanged**. **Draft propagated by `/propagate-policy`; left uncommitted for the repo owner.** |
| 1.2 | 2026-09-11 | **The escalation ladder named three products and all three were stale (playbook PI-083/PI-085).** *"Try the cheap tier (Copilot Pro / Cline FREE / local Aider)"* — **Copilot Pro stopped**, **Cline is metered and unfunded**, **Aider too slow to reach for**. Restated **by property**: the fastest route this repo's `model-execution-policy.md` permits for non-sensitive work, **currently the DeepSeek API in Claude Code**. **A roster written as product names goes stale silently; a property does not.** No routing decision changes. |
