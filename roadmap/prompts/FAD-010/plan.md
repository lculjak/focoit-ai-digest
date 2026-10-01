# FAD-010 — Upgrade gh-aw v0.85.4 → v0.89.21 and retire the PR #5 hand patch — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-010](../../pending-improvements.md#fad-010)

## Why now

1. **The lock is not pure compiler output.** PR #5 hand-patched both Copilot harness invocations
   (`/usr/local/bin/copilot` → `copilot`) because that path does not exist on current runners: the
   ENOENT that failed the 2026-08-17 run, so **W34 is missing**. Any recompile with v0.85.4 silently
   reverts the patch, so **every workflow change is blocked** until it is re-applied by hand.
   [FAD-009](../FAD-009/plan.md) is the first item stuck on this.
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
| Copilot CLI (`engine_versions`) | 1.0.78 | **1.0.87** |
| `github/gh-aw-actions/setup` | v0.85.4 `2709137…` | v0.89.21 `924af5f…` |
| `gh-aw-mcpg` | v0.4.8 | v0.4.25 |
| `github-mcp-server` | v1.8.0 | v1.12.2 |
| Manifest secrets | includes `COPILOT_GITHUB_TOKEN` | drops it; **adds `GH_AW_DEFAULT_OTLP_ENDPOINT` / `_HEADERS`** |
| Lock diff | — | ~920 lines (576+ / 347−) |

`actions/*` pins are unchanged. **To check while executing:** whether the two new OTLP secrets are
optional (telemetry export, expected to be skipped when unset); none are set in this repo, and none
should be added for this item.

## Plan

1. **Branch** `chore/gh-aw-v0.89.21` off `main`. Do not touch the workflow `.md` body in this item:
   it is a pure toolchain upgrade, so a failure has one cause.
2. **Compile with an explicit version:** `gh aw version` must report **v0.89.21**; then
   `gh aw compile --no-check-update` must report 0 errors / 0 warnings. The "use ecosystem
   identifiers" hint is advisory; leave the network allowlist as it is.
3. **Review the lock diff** against the table above. Confirm the harness line, and confirm
   `/usr/local/bin/copilot` appears 0 times.
4. **Commit** `.md` (unchanged) + `.lock.yml` + `.github/aw/actions-lock.json` together; gate PASS.
5. **Prove it on a real run before merging:**
   `gh workflow run weekly-ai-digest.lock.yml --ref chore/gh-aw-v0.89.21`, then watch the run.
   The run's safe output opens a `[digest]` PR against `main`. Review it like any digest: merge it if
   it is good, or close it.
   - **Timing:** do not overlap the Monday ~11:00 UTC scheduled run, which still uses the old lock
     from `main`. Tuesday–Saturday is safe.
   - **Cost:** about one digest run (W33 baseline 125.7 + 12.4 AIC). Record the actual figure for
     FAD-007.
6. **Merge** the upgrade PR only after step 5 succeeds. The next scheduled Monday run is the second
   observation.
7. **Then** FAD-009 becomes a normal change: edit the `.md`, `gh aw compile` (v0.89.21), commit, and
   the lock diff is just the prompt hash.

**Rollback:** revert the merge commit. The old lock still carries PR #5's patch, so it runs as before.

## Scope

Files touched: `.github/workflows/weekly-ai-digest.lock.yml`, `.github/aw/actions-lock.json`.

Out of scope:
- Any change to the workflow instructions (that is FAD-009).
- Adding secrets (OTLP or otherwise).
- Switching the network allowlist to ecosystem identifiers.
- Pinning the *local* extension: gh-aw self-updates, so the committed lock (`compiler_version`) is the
  pin of record. Record the compiling version in the commit message.

## Acceptance recap

- Lock compiled by **v0.89.21**, `gh aw compile` 0/0; `.md` + `.lock.yml` + `actions-lock.json`
  committed together; gate PASS.
- `/usr/local/bin/copilot` appears 0 times, and **no hand patch remains** in the lock.
- A `workflow_dispatch` run from the branch **succeeds end to end**: the agent step finds `copilot`
  (no ENOENT), the detection step passes, and a `[digest]` PR opens with exactly the three expected
  `docs/` files.
- AIC for that run is recorded (FAD-007 data point).
- After merge, the **next scheduled Monday run** succeeds on the new lock (observed, not assumed).

## Outcome

Status: Open — specified 2026-09-30, not started.
Commit: —
