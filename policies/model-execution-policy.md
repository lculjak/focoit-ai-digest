# Model Execution & Confidentiality Policy — focoit-ai-digest

Version: 1.3

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
| **2. Hosted** | **DeepSeek API in Claude Code** (primary — metered, prepaid, runs unattended **given an isolated `CLAUDE_CONFIG_DIR`; see the note below**); **Cline FREE** ($0, **VS Code only**, needs a human). ~~GitHub Copilot Pro~~ **stopped** | Fast routine edits: HTML/CSS/JS tweaks, docs, small refactors | Fast |
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

> **That "runs unattended" has a precondition, and the configuration that breaks it is the normal one**
> (playbook **v1.16** / PI-073, 2026-09-03). On a machine **signed in to Claude Code Max** — which every
> machine running Tier 3 is — Claude Code tags the request `provider: firstParty` **even against a
> third-party `ANTHROPIC_BASE_URL`**, attaches the **subscription token**, and **ignores both
> `ANTHROPIC_AUTH_TOKEN` and `ANTHROPIC_API_KEY`**. DeepSeek returns 401, Claude Code retries **ten
> times**, and the run dies to the caller's timeout — **presenting as a hang, not an error**. The fix is
> an **isolated `CLAUDE_CONFIG_DIR`** naming a directory that holds **no Claude credential**; it is state
> rather than a flag, so signing in against it silently restores the failure. **Diagnose with
> `--debug-file`** — the 401 is in that log within 200 ms and is invisible without it. **The full
> procedure lives in the playbook**, which this file mirrors rather than restates.
>
> **Two cost traps on this route, from the same diagnosis.** Claude Code's own `total_cost_usd` is
> **Anthropic pricing applied to DeepSeek tokens** — one run self-reported **$2.04** against **$0.29 for a
> whole day of 70 requests** — and `GET /user/balance` **lags by minutes**, so a reading taken straight
> after a run is not evidence of its cost. **Take cost figures from the DeepSeek dashboard's per-request
> export**; keep the balance endpoint for a pre-flight funding check only.

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
| 1.3 | 2026-09-03 | **Propagated playbook v1.16 (PI-073) — the "runs unattended" claim this file already carried was false on a Max-signed-in machine.** Claude Code tags the request `provider: firstParty` even against a third-party `ANTHROPIC_BASE_URL`, attaches the **subscription OAuth token**, and **ignores both `ANTHROPIC_AUTH_TOKEN` and `ANTHROPIC_API_KEY`**; DeepSeek 401s; Claude Code retries **ten times** and the run dies to the caller's timeout — **presenting as a hang rather than an error**, which points the diagnosis at the vendor instead of the harness. **The failing configuration is the normal one**: every machine running Tier 3 is signed in to Claude Code Max. Fixed by an **isolated `CLAUDE_CONFIG_DIR`**, recorded here as **state rather than a flag**. **The caveat is propagated; the full setup procedure is not** — this file is a condensed mirror and the procedure stays in the playbook, so there is one copy to keep true. **Cost carried in the same pass:** `total_cost_usd` on this route is Anthropic pricing applied to DeepSeek tokens (**$2.04 self-reported for one run against $0.29 for a 70-request day**) and `user/balance` **lags by minutes**, so the **dashboard's per-request export** is the authority. Diagnosed in Jobflow (**JF-053**), raised upstream as **PI-073**, propagated here. **Correction to the record while propagating:** the playbook's PI-071/PI-072 described this mirror as sitting on **1.1** — it was not; the 2026-09-02 pass had already brought it current, and the gap was one version, not fifteen |
