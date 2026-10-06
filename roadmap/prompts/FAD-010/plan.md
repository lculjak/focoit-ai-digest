# FAD-010 — Upgrade gh-aw v0.85.4 → v0.89.21, pin the model, retire the PR #5 hand patch — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-010](../../pending-improvements.md#fad-010)

Specified 2026-09-30 as a Medium toolchain upgrade. **Re-scoped 2026-10-05 to High**: the digest has
not published since W37, and fixing that needs this item plus a model pin (see the next section).

## 2026-10-05 — the digest is down, and has been for four weeks

Found while reviewing run [37364280013](https://github.com/lculjak/focoit-ai-digest/actions/runs/37364280013).

| Run (UTC) | Copilot CLI | `/models` catalog | Result |
|---|---|---|---|
| 2026-09-07 | 1.0.80 | fetched 46 models | ✅ `auto` resolved (primary `claude-sonnet-5`); W37 published |
| 2026-09-14 | 1.0.83 | **403** | ❌ `400 Model "auto" has no AI credits pricing and no default pricing is configured` |
| 2026-09-21 | — | — | ❌ same step (*Execute GitHub Copilot CLI*) |
| 2026-09-28 | 1.0.85 | **403** | ❌ same `400`, three harness attempts, ~1 s each |
| 2026-10-05 | — | — | ❌ `activation` (`ubuntu-slim`) never acquired a runner, cancelled after 15 min. GitHub Actions incident opened 19:11; the run was queued 19:34 |

**The success and all the failures ran the same lock (`9eaabf1`).** Nothing in this repo changed.
Two unpinned inputs moved underneath it:

1. **Model.** `engine: copilot` produces `COPILOT_MODEL: auto`. The harness resolves `auto` through the
   AWF API proxy's `/models` catalog; when the catalog is empty, `auto` goes to the proxy as-is, and
   the proxy refuses a model it cannot price.
2. **Copilot CLI version.** The install step logs *"No explicit Copilot CLI version requested.
   Attempting compat-driven version resolution"* and then takes the newest version in **1.0.21..1.0.87
   from the runner's toolcache**. So the CLI follows GitHub's runner image, not the lock's recorded
   1.0.78. The catalog fetch returned 403 from 1.0.83 on.

Which of the two is the root cause and which is the trigger doesn't change the fix: **pin the
model** (never `auto`, the same rule CLAUDE.md applies to reviewers), and consider **pinning the CLI**
so the runner image can't move it again.

Also in every failed log: `[copilot-harness] pre-flight: command not found: copilot (F_OK check
failed — binary does not exist at this path)`. That is PR #5's bare `copilot`. It is non-fatal (the
CLI still ran and returned the `400`), and the upgrade retires it.

**Why nobody noticed:** a failed scheduled run opens no PR, and the PR is the only thing anyone
looks at. The site kept serving W37. Tracked below as a follow-up, outside this item.

## Why the upgrade (original rationale, still true)

1. **The lock is not pure compiler output.** PR #5 hand-patched both Copilot harness invocations
   (`/usr/local/bin/copilot` → `copilot`) because that path does not exist on current runners: the
   ENOENT that failed the 2026-08-17 run, so **W34 is missing**. Any recompile with v0.85.4 silently
   reverts the patch, so **every workflow change is blocked** until it is re-applied by hand.
   [FAD-009](../FAD-009/plan.md) was the first item stuck on this; the model pin is the second.
2. **v0.89.21 does not emit the bad path.** A throwaway compile on 2026-09-30 produced:
   ```
   "$GH_AW_NODE_EXEC" "${RUNNER_TEMP}/gh-aw/actions/copilot_harness.cjs" "${RUNNER_TEMP}/gh-aw/bin/copilot" …
   ```
   `/usr/local/bin/copilot` appears **0** times. The path is now one gh-aw controls. **Unproven
   until a run uses it.**
3. **The pin does not hold anyway.** The dev machine had v0.86.2 installed, not v0.85.4, and
   `gh extension install github/gh-aw --pin v0.85.4 --force` self-upgraded to **v0.89.21**, which is
   what is installed now. Staying on v0.85.4 means fighting the tool on every compile.

## What the upgrade changes (observed in the 2026-09-30 test compile, `gh aw compile` 0/0)

| | v0.85.4 (committed) | v0.89.21 |
|---|---|---|
| Copilot harness binary | `copilot` (hand patch) | `${RUNNER_TEMP}/gh-aw/bin/copilot` (compiler) |
| Copilot CLI (`engine_versions`) | 1.0.78 | **1.0.87** (recorded; the runner may still pick another unless pinned) |
| `github/gh-aw-actions/setup` | v0.85.4 `2709137…` | v0.89.21 `924af5f…` |
| `gh-aw-mcpg` | v0.4.8 | v0.4.25 |
| `github-mcp-server` | v1.8.0 | v1.12.2 |
| Manifest secrets | includes `COPILOT_GITHUB_TOKEN` | drops it; **adds `GH_AW_DEFAULT_OTLP_ENDPOINT` / `_HEADERS`** |
| Lock diff | — | ~920 lines (576+ / 347−) |

`actions/*` pins are unchanged. **To check while executing:** whether the two new OTLP secrets are
optional. The 2026-09-28 log already shows *"GH_AW_OTLP_ENDPOINTS not set, skipping OTLP export"*,
which suggests unset is fine. None are set in this repo, and none should be added for this item.

## Plan

**Two commits, two dispatch runs**, so each failure has one cause. A run that fails on `auto` dies in
seconds, so the first run costs almost nothing.

1. **Branch** `chore/gh-aw-v0.89.21` off `main`.
2. **Commit A — upgrade only.** `gh aw version` must report **v0.89.21**; `gh aw compile
   --no-check-update` must report 0 errors / 0 warnings (the "use ecosystem identifiers" hint is
   advisory). Review the lock diff against the table above; confirm the harness line and zero
   `/usr/local/bin/copilot`. Commit `.md` (unchanged) + `.lock.yml` + `actions-lock.json`; gate PASS.
3. **Dispatch A:** `gh workflow run weekly-ai-digest.lock.yml --ref chore/gh-aw-v0.89.21`.
   - **Pass:** the agent step finds `copilot` (no ENOENT, no pre-flight `command not found`).
   - **Expected:** it may still fail on the `auto` `400`. Record whether the `/models` fetch still
     returns 403 on the new versions.
   - If it **succeeds outright**, the upgrade alone fixed resolution; still do commit B, because `auto`
     should not be relied on.
4. **Commit B — pin the model.** In the frontmatter, set the Copilot engine's model to
   `claude-sonnet-5` (what the last good run resolved to). **Confirm the exact `engine:` syntax
   against the v0.89.21 frontmatter reference** before writing it. Decide whether to also pin the CLI
   version (`engine.version`), and record the decision and the reason. Recompile; commit `.md` +
   `.lock.yml` (+ `actions-lock.json` if changed).
5. **Dispatch B:** must succeed end to end. No `Model "auto"` anywhere in the log, the detection step
   passes, and a `[digest]` PR opens with exactly the three expected `docs/` files. Review it like any
   digest; merge it if it is good. That merge is also **FAD-008 step 7**: confirm `docs/CNAME` survives.
   - **Timing:** only when GitHub Actions is healthy (check githubstatus.com), and not on a Monday:
     the scheduled run still uses `main`'s lock.
   - **Cost:** about one digest run (W33 baseline 125.7 + 12.4 AIC). Record the actual figure for
     FAD-007.
6. **Merge** the upgrade PR only after dispatch B succeeds. The next scheduled Monday run is the
   second observation.
7. **Then** FAD-009 becomes a normal change: edit the `.md`, `gh aw compile` (v0.89.21), commit, and
   the lock diff is just the prompt hash.

**Rollback:** revert the merge commit. The old lock still carries PR #5's patch, **but it also still
fails on `auto`**, so a rollback restores today's broken state, not a working one.

## Scope

Files touched: `.github/workflows/weekly-ai-digest.md` (**frontmatter only**: the model pin, plus
the CLI version if chosen), `.github/workflows/weekly-ai-digest.lock.yml`,
`.github/aw/actions-lock.json`.

Out of scope:
- Any change to the workflow **instructions** (that is FAD-009).
- Adding secrets (OTLP or otherwise).
- Switching the network allowlist to ecosystem identifiers.
- Pinning the *local* extension: gh-aw self-updates, so the committed lock (`compiler_version`) is the
  pin of record. Record the compiling version in the commit message.
- **Backfilling W38–W41.** The workflow reads the last 14 days, so a backfill would file current
  stories under old week labels: the same reasoning that left W34 missing.
- **Failure alerting** (follow-up item): a failed scheduled run must reach a human, through an
  issue on failure, a notification, or a staleness check on the site's last-updated date.

## Acceptance recap

- Lock compiled by **v0.89.21**, `gh aw compile` 0/0; `.md` + `.lock.yml` + `actions-lock.json`
  committed together; gate PASS; `/usr/local/bin/copilot` appears 0 times and **no hand patch
  remains**.
- **Dispatch A:** the agent step finds `copilot`.
- **Dispatch B:** the model is pinned (no `auto` in the log), the run **succeeds end to end**, and a
  `[digest]` PR opens with exactly the three expected `docs/` files.
- CLI-version pin decided and recorded.
- AIC for the successful run recorded (FAD-007 data point).
- After merge, the **next scheduled Monday run** succeeds on the new lock (observed, not assumed).

## Outcome

Status: In progress — fixed and proven by dispatch on 2026-10-05; awaiting merge + the next Monday run.
Commits (branch `chore/gh-aw-v0.89.21`): A `b762502`, B `f079eff`, C `d54b305`.

**It deviated from the plan, and the deviation is the finding.** The plan assumed the model was the
problem. Dispatch A (37386702875) confirmed the upgrade: `copilot` found, *"pre-flight: command is
accessible and executable"*, CLI **1.0.90** (still floating), and the harness now **refuses** an
unresolved `auto` instead of sending it. Dispatch B (37387169301), with the model pinned to
`claude-sonnet-5`, removed `auto` entirely and exposed the real failure: **`Authentication failed
with provider … (HTTP 403)`**, `failureClass=authentication_failed`. Every request to GitHub
Copilot inference was being refused. The `/models` 403 was the same refusal. That fits Copilot Pro
being stopped (policy v1.2, 2026-09-02): last success 09-07, first 403 09-14.

**Commit C (not in the original plan): DeepSeek via Copilot BYOK.** Chosen by the owner over
re-subscribing or switching engines. `engine.model: deepseek-v4-flash`, `engine.env`
`COPILOT_PROVIDER_BASE_URL=https://api.deepseek.com/anthropic`, `COPILOT_PROVIDER_TYPE=anthropic`,
`COPILOT_PROVIDER_API_KEY=${{ secrets.DEEPSEEK_API_KEY }}` (a dedicated key, added by the owner),
`api.deepseek.com` allowlisted. `gh aw compile` flagged the new secret in safe-update mode; reviewed
(used only as the provider key in the agent and detection jobs, sent only to the allowlisted host,
otherwise only in the log-redaction list) and approved with `--approve`. Dispatch C (37388750793)
**succeeded end to end** in ~8 min: agent 3m42s exit 0, detection passed, W41 digest PR #25 (15
stories, 11 MS/GitHub, three expected files).

**CLI version pin: not pinned, deliberately.** The CLI only runs the harness now; inference is
DeepSeek's, so a CLI drift no longer changes which model or account is billed. Revisit if a
runner-image change (Ubuntu 26 from 2026-10-19) breaks the harness.

**Found along the way:** `max-ai-credits` does not apply to BYOK (`AI credits: (none)`), recorded
under FAD-007; failure alerting raised as FAD-013.
