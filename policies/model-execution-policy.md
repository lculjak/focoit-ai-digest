# Model Execution & Confidentiality Policy — focoit-ai-digest

Version: 1.2

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

**Client, customer, and proprietary data — source code, correspondence, calendars, tickets, business
records and documents alike — and any secrets — must never be sent to hosted-free AI services, and
must never drive a hosted agentic CI workflow.** This repo is classified non-sensitive, so the rule
does not restrict it today; it is stated so a future change of contents is caught.

## Irreversible actions

The rule above governs what a tool **receives**; this one governs what it **emits, grants or spends** —
**egress**, **credential grant**, **publication**, **spend**.

1. **No default-on egress.** A tool that transmits unless told not to is not acceptable. Where one is
   wanted anyway, the transmission is disabled **before the first invocation** and recorded; where it
   cannot be disabled, the tool is not adopted.
2. **One class per command.** No single command or flag may combine more than one of the four classes
   without a decision recorded in advance.

**Both clauses are needed:** an *opt-in* flag can still bundle an OAuth grant, an ambient-credential
read and a permanent publication — which clause 1 alone would clear. Rationale and worked examples
upstream in the playbook policy v1.7.

---

# Execution tiers

| Tier | Where | Use for | Speed |
|------|-------|---------|-------|
| **1. Local** | Ollama (Aider) | Offline / privacy-critical edits | Slow (CPU) |
| **2. Hosted** | **DeepSeek API in Claude Code** (primary — metered, prepaid, runs unattended); **Cline FREE** ($0, **VS Code only**, needs a human). ~~GitHub Copilot Pro~~ **stopped** | Fast routine edits: HTML/CSS/JS tweaks, docs, small refactors | Fast |
| **3. Cloud reasoning** | **Claude Code Max** ($100/mo, 5×, **Usage Credits OFF**) | Architecture, the gh-aw workflow design, curation-prompt tuning, debugging | Fast |

> **The paid floor is an assumption, not a constant** (playbook v1.11, PI-067). **GitHub Copilot Pro
> is stopped**, and **Claude Code Max is under budget pressure and a candidate for removal** — so any
> routing that depends on Tier 3 depends on a decision not yet made. Two consequences carried over
> from the playbook: a subscription makes the *marginal* token free, **not the tool**, so quote
> **metered-equivalent** cost when comparing against a metered alternative and **never quote $0
> without naming the assumption**; and **with Copilot Pro gone there is no free hosted route outside
> VS Code**, so unattended or scripted work falls to the metered DeepSeek route. The DeepSeek route is
> scoped **demo/dev, non-sensitive only**, and DeepSeek is a **PRC-jurisdiction** provider — a fact,
> not a new rule, which excludes it wherever a data-residency clause applies.

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
| 1.1 | 2026-08-31 | Propagated playbook v1.6–v1.8 (PI-053 / PI-063). **Confidentiality rule now governs client *data*** — correspondence, calendars, tickets, documents — not *code* alone; the old wording let a hosted agent take client email without breaching it. **Added the irreversible-actions rule** (no default-on egress; one irreversible class per command). **Tier 3 corrected: Claude Pro → Claude Code Max ($100/mo, 5×)** — Pro is no longer held. Copilot Pro is unchanged and still this repo's gh-aw engine. **Draft propagated by `/propagate-policy`; left uncommitted for the repo owner.** |
| 1.2 | 2026-09-02 | Propagated playbook **v1.9–v1.14** (PI-067 / PI-069). **Tier 2 restructured:** **GitHub Copilot Pro is stopped**, so the tier has **no flat-rate option**; **DeepSeek API in Claude Code is primary** (metered, prepaid, **runs unattended**) and **Cline FREE is second** (**VS Code only**, needs a human) — the metered route deliberately outranks the free one because **operator time dominates a ~$0.011 task**. Adds the **paid-floor-is-an-assumption** note: Max is under budget pressure, **quote metered-equivalent cost and never $0 without naming the assumption**, and **with Copilot gone there is no free hosted route outside VS Code**. DeepSeek scoped **demo/dev, non-sensitive**, with **PRC jurisdiction recorded as a fact**. **This repo's confidentiality rule, tier boundaries and agentic-CI section are unchanged.** Tier 3 already carried v1.9–v1.10's *Usage Credits OFF* |
