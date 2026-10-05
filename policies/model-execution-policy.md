# Model Execution & Confidentiality Policy — focoit-ai-digest

Version: 1.7

Status: Active

Owner: Leonardo Culjak

Date: 2026-10-05

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
| **2. Hosted** | **DeepSeek API in Claude Code** (primary — metered, prepaid, runs unattended **given an isolated `CLAUDE_CONFIG_DIR`; see the note below**); **Cline** — **manual, exceptional**; ~~$0~~ it bills **metered Cline Credits** (playbook PI-085) ( **VS Code only**, needs a human). ~~GitHub Copilot Pro~~ **stopped** | Fast routine edits: HTML/CSS/JS tweaks, docs, small refactors | Fast |
| **3. Cloud reasoning** | **Seat ①** — model and route in the playbook's [model registry](https://github.com/lculjak/ai-engineering-playbook/blob/main/specs/model-registry.md) (**mirrored, not re-decided**; playbook PI-120). ~~`kimi-k3` via opencode Go~~ · ~~Claude Code Max~~ **cancelled 2026-09-11** (playbook v1.19, PI-085) | Architecture, the gh-aw workflow design, curation-prompt tuning, debugging | Fast (~40 s/turn) |

> **The harness is not a tier.** **Claude Code Pro ($20/mo) is the *client* every tier runs inside** — it is **not** the Tier-3 model. ~~Its inference is **deliberately unspent**, so *"never a Claude model reviewing a Claude-executed change"* holds **by construction**.~~ **Since playbook PI-087 (2026-10-04) its inference holds seat ③a**, so that rule now holds **because seat ② is not Claude**: a property of ②'s pin, not of the roster. **Paid floor: $30/mo** (Claude Pro $20 + opencode Go $10, **Go on hold since 2026-10-03**) plus the DeepSeek API metered.
> ~~**Connectivity is proven; capability is not** — the Go models are verified to *answer* through this harness; **none is scored**.~~ **Capability is measured now** (playbook PI-087): each seat's score is in the [model registry](https://github.com/lculjak/ai-engineering-playbook/blob/main/specs/model-registry.md), and its basis in the playbook's `model-execution-policy.md` § *Review seats*.
> ~~**All model seats are PRC-jurisdiction vendors**~~ **Seat vendors and hosting are in the [model registry](https://github.com/lculjak/ai-engineering-playbook/blob/main/specs/model-registry.md)** (some are PRC-jurisdiction, some are not). **Every hosted seat is non-sensitive only**: nothing breaks on a non-sensitive repo, and it binds the moment client work returns.

> **The paid floor is an assumption, not a constant** (playbook v1.11, PI-067). **GitHub Copilot Pro
> is stopped**, and ~~**Claude Code Max is under budget pressure and a candidate for removal**~~ — **it was cancelled on 2026-09-11** (playbook PI-085), so this is no longer a prediction but a record: **routing that depends on a subscription depends on a decision that can be taken without it.** Two consequences carried over
> from the playbook: a subscription makes the *marginal* token free, **not the tool**, so quote
> **metered-equivalent** cost when comparing against a metered alternative and **never quote $0
> without naming the assumption**; and **with Copilot Pro gone there is no free hosted route outside
> VS Code**, so unattended or scripted work falls to the metered DeepSeek route. The DeepSeek route is
> scoped **demo/dev, non-sensitive only**, and DeepSeek is a **PRC-jurisdiction** provider — a fact,
> not a new rule, which excludes it wherever a data-residency clause applies.

> **That "runs unattended" has a precondition, and the configuration that breaks it is the normal one**
> (playbook **v1.16** / PI-073, 2026-09-03). On a machine **signed in to any Claude subscription** — Pro since 2026-09-11, Max before it, and **the trap is identical on either** — Claude Code tags the request `provider: firstParty` **even against a
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
>
> **The export's model column is also the only admissible model identity** (playbook PI-109,
> 2026-09-29). The session record *labels* a request and the result JSON *echoes* it. **On this
> account, requests for `deepseek-v4-flash` have billed as `deepseek-flash` since 2026-09-10**, while the
> session record said `deepseek-v4-flash` for some of them. When a pin or a label is in doubt, the export
> settles it.

Per-task routing within these tiers: [ai-routing-policy.md](ai-routing-policy.md).

---

# Agentic CI (gh-aw) — this repo's engine

This repo's whole point is an **agentic CI workflow**: `.github/workflows/weekly-ai-digest.md`
compiles (via `gh aw compile`) to `weekly-ai-digest.lock.yml` and runs AI **inside GitHub Actions**
on a weekly schedule, publishing through a human-gated pull request (`safe-outputs`).

- **Engine: `copilot` harness, inference BYOK to DeepSeek** (since 2026-10-05, FAD-010). The Copilot
  CLI still runs the agent (PI-023 pattern), but **GitHub Copilot inference is not used**: after
  Copilot Pro was stopped (v1.2), every request to it returned **HTTP 403**, and the weekly run failed
  from 2026-09-14 on. Inference now goes to **`api.deepseek.com`** (Anthropic-compatible endpoint,
  model pinned to **`deepseek-v4-flash`**, never `auto`) with a **dedicated repo secret
  `DEEPSEEK_API_KEY`**, used by nothing else so it can be revoked alone. This is the Tier-2 route,
  metered and prepaid, and **the DeepSeek billing export is the record of cost and model** (PI-109).
  Hosted agentic CI sends repo content and **fetched feed content** to the provider, so it is
  **non-sensitive repos only** — which this is; **PRC jurisdiction** applies (recorded in Tier 2).
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
| 1.4 | 2026-09-11 | **Tier 3's tool was cancelled, and the harness is not a tier (playbook PI-085, `model-execution-policy.md` v1.19).** **Claude Code Max was cancelled 2026-09-11**; Tier 3 is **`kimi-k3` via opencode Go**, and **Claude Code Pro is the *harness* every tier runs inside — not the Tier-3 model** — with its inference **deliberately unspent**. **Floor $30** (Pro $20 + Go $10) plus DeepSeek metered. The *"under budget pressure and a candidate for removal"* clause is **superseded**: **it was removed**, so it is a record rather than a prediction. **The `CLAUDE_CONFIG_DIR` precondition is generalised** — it said *"signed in to Claude Code **Max**"*, and **the trap is identical on Pro** (measured upstream: **191.3 s** against a documented ~181 s exhaustion), so a load-bearing precondition would otherwise have described a subscription nobody holds. **Cline corrected**: ~~$0~~ **metered Cline Credits**, **manual and exceptional**, not a free fallback. **Two limits carried rather than hidden:** **capability is unmeasured** (the Go models are verified to *answer*, none is scored) and **all model seats are PRC-jurisdiction**, binding the moment client work returns. **No confidentiality rule, gate or tier boundary changes.** |
| 1.5 | 2026-09-29 | **Propagated playbook v1.25 (PI-109) — the export names the model, not only the cost.** The playbook's billing export for 2026-08-31 → 09-29 shows **every flash-family request since 2026-09-10 billed as `deepseek-flash`**, including requests for the pinned `deepseek-v4-flash`, while the session record labelled some of them `deepseek-v4-flash`. **One paragraph added under this file's existing *take cost figures from the export* rule:** the export's model column is the only admissible model identity, and it settles a doubted pin. **No tier, route or confidentiality decision changed.** |
| 1.6 | 2026-10-04 | **Propagated playbook PI-087 + PI-120 (`model-execution-policy.md` v1.30, `specs/model-registry.md`).** Model ids now come from the playbook's **model registry**: this file names **seat ①** and links it. Pins are **mirrored, not re-decided**, so the next model change needs no edit here. **Struck in place:** *"inference deliberately unspent … holds by construction"* (false since PI-087: ③a is Claude; the rule now holds because ② is not Claude), *"capability is not … none is scored"*, and *"all model seats are PRC-jurisdiction vendors"*. The PI-109 billing note keeps its ids (dated evidence). No confidentiality rule changed |
| 1.7 | 2026-10-05 | **Agentic CI inference moved from GitHub Copilot to DeepSeek (BYOK), FAD-010.** The weekly digest had failed since 2026-09-14: once Copilot Pro was stopped (v1.2), Copilot inference returned **HTTP 403** to the workflow (first visible as `400 Model "auto" has no AI credits pricing`, because the 403 also hid the model catalog). The Copilot CLI harness stays; inference goes to `api.deepseek.com` (Anthropic-compatible), model pinned to `deepseek-v4-flash`, key in a **dedicated** repo secret `DEEPSEEK_API_KEY`, approved through gh-aw's safe-update review. Brings the agentic-CI section in line with the Tier-2 decision already recorded here; **no confidentiality rule or tier boundary changes** |
