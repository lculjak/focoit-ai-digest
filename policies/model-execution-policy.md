# Model Execution & Confidentiality Policy — focoit-ai-digest

Version: 1.0

Status: Active

Owner: Leonardo Culjak

Date: 2026-08-10

---

# Purpose

Records **where** code and prompts for this repo may be processed, and the confidentiality tier this
repo is classified at. Adapted from the AI Engineering Playbook's
`policies/model-execution-policy.md` for a specific project (adopt-in-a-project.md).

---

# This repo's confidentiality tier — NON-SENSITIVE / PERSONAL

`focoit-ai-digest` is a **public** repository. It contains only Focoit's own content (a curated AI
news digest) and open configuration — **no client, customer, or proprietary code, and no secrets in
the tree.** The one secret it uses (`COPILOT_GITHUB_TOKEN`, a fine-grained PAT) lives in **GitHub
Actions repo secrets**, never in a file.

Consequence: the **full hybrid flow is allowed**, including hosted agents and hosted **agentic CI**
(see below). The confidentiality rule below still binds should that ever change.

# Confidentiality rule (highest priority)

**Client, customer, and proprietary code — and any secrets — must never be sent to hosted-free AI
services, and must never drive a hosted agentic CI workflow.** This repo is classified non-sensitive,
so the rule does not restrict it today; it is stated so a future change of contents is caught.

---

# Execution tiers

| Tier | Where | Use for | Speed |
|------|-------|---------|-------|
| **1. Local** | Ollama (Aider) | Offline / privacy-critical edits | Slow (CPU) |
| **2. Hosted paid floor** | **GitHub Copilot Pro** (primary); **Cline FREE** ($0 fallback) | Fast routine edits: HTML/CSS/JS tweaks, docs, small refactors | Fast |
| **3. Cloud reasoning** | **Claude Pro** (Usage Credits OFF) | Architecture, the gh-aw workflow design, curation-prompt tuning, debugging | Fast |

Per-task routing within these tiers: [ai-routing-policy.md](ai-routing-policy.md).

---

# Agentic CI (gh-aw) — this repo's engine

This repo's whole point is an **agentic CI workflow**: `.github/workflows/weekly-ai-digest.md`
compiles (via `gh aw compile`) to `weekly-ai-digest.lock.yml` and runs AI **inside GitHub Actions**
on a weekly schedule, publishing through a human-gated pull request (`safe-outputs`).

- **Engine: `copilot`** — aligned with the playbook's PI-023 pattern (Copilot as a CI engine). Auth
  is a **`COPILOT_GITHUB_TOKEN` fine-grained PAT** (personal account; *Copilot Requests: read*), or an
  org on centralized billing (`copilot-requests: write`, no PAT). Hosted agentic CI sends repo content
  to the engine, so it is **non-sensitive repos only** — which this is.
- **Gate for workflow changes:** `gh aw compile` with **0 errors / 0 warnings** (the deterministic
  guardian does not validate a workflow). Commit the `.md` source **+** the generated `.lock.yml`
  **+** `.github/aw/actions-lock.json` together. On staleness across gh-aw versions, **delete and
  recompile** — do not hand-patch the lock file.
- **Cost:** usage-based AI credits; agentic runs are the expensive kind. Keep the schedule weekly and
  the per-run cap (`max-ai-credits`) tuned; prefer `workflow_dispatch` for ad-hoc runs.
- **Safety:** the agent job runs read-only + sandboxed with a network allow-list; the only write is
  via `safe-outputs` (a PR). Threat-detection scans output before it becomes a PR. The **PR is the
  integration boundary.**

---

# Revision History

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-08-10 | Initial policy for focoit-ai-digest — classified non-sensitive/personal; adapted from the playbook; records the gh-aw (engine: copilot, COPILOT_GITHUB_TOKEN) agentic-CI posture, aligned with PI-023 |
