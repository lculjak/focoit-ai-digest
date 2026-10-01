# FAD-009 — Render story text as text, not HTML — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-009](../../pending-improvements.md#fad-009)

## The defect

`docs/index.html` builds each card with:

```js
tldr.innerHTML = '<strong>TL;DR:</strong> ' + s.tldr;
why.innerHTML  = '<strong>Why it matters:</strong> ' + s.why;
a.href = s.url;
```

The agent writes `tldr`, `why` and `url` from **external feed content**. If a feed smuggles markup
into them and the agent copies it through, it is parsed as HTML on `digest.focoit.com`:
`<img src=x onerror=…>` runs script, and a `javascript:` URL runs on click. Every other field (title,
source, date, tags) already uses `textContent`. Found 2026-09-30 while explaining the *TL;DR:* label.

**Exposure is low**, hence Low priority: a static page with no login, cookies or forms, and every
digest goes through a human-reviewed PR. But the page sits on a Focoit domain, and the guarantee
should not rest on a reviewer reading story text for markup.

## The fix — written and tested 2026-09-30, not committed

### 1. `docs/index.html` (closes it now)

```diff
-      a.href = s.url; a.textContent = s.title; a.target = '_blank'; a.rel = 'noopener';
+      if (/^https?:\/\//i.test(s.url)) a.href = s.url;
+      a.textContent = s.title; a.target = '_blank'; a.rel = 'noopener';
@@
       const tldr = document.createElement('p');
-      tldr.innerHTML = '<strong>TL;DR:</strong> ' + s.tldr;
+      const tldrLabel = document.createElement('strong');
+      tldrLabel.textContent = 'TL;DR:';
+      tldr.append(tldrLabel, ' ' + s.tldr);
       card.appendChild(tldr);
@@
       why.className = 'why';
-      why.innerHTML = '<strong>Why it matters:</strong> ' + s.why;
+      const whyLabel = document.createElement('strong');
+      whyLabel.textContent = 'Why it matters:';
+      why.append(whyLabel, ' ' + s.why);
       card.appendChild(why);
```

**Tested** on a local server with the W37 data. It renders identically: bold labels, *10 of 15* on
load. With an injected `<img src=x onerror=…>` in a TL;DR and a `javascript:` URL, the tag shows as
literal text, no `<img>` is created, the handler never fires, and the bad link gets no `href`.

### 2. `.github/workflows/weekly-ai-digest.md` (keeps it closed)

`docs/` is regenerated every Monday, so the page fix alone lasts only until the next run. The agent's
instructions must require it:

```diff
 - A footer noting: generated weekly by an agentic workflow; last-updated timestamp.
+- **Story text is data, never markup.** Every story field comes from external feeds, so the
+  script must render title, source, TL;DR, why-it-matters, tags and date with `textContent` /
+  `append()` — never `innerHTML`, `insertAdjacentHTML`, `outerHTML` or `document.write`. Build
+  labels such as **TL;DR:** and **Why it matters:** as their own `<strong>` elements. Set a card's
+  `href` only when the URL starts with `http://` or `https://`.
@@ ## 5. Preflight (self-check before output)
-highlights block uses only allowed sources; every card has all required fields. If a rule
+highlights block uses only allowed sources; every card has all required fields; the page
+script puts no story field through `innerHTML` or any other HTML sink. If a rule
```

Shipping (1) without (2) is allowed but temporary: Monday's run may reintroduce `innerHTML`.

## Blockers — why this did not ship

Changing the workflow `.md` changes its `body_hash`, so `.lock.yml` must be recompiled
(CLAUDE.md workflow gate). Recompiling is where it stuck.

### B1 — A clean recompile reintroduces the W34 failure

The committed lock is **not** pure compiler output. PR #5 (2026-08-20) hand-patched both harness
invocations in `.lock.yml` (around lines 807 and 1413):

```
copilot_harness.cjs /usr/local/bin/copilot …   ->   copilot_harness.cjs copilot …
```

The reason: `/usr/local/bin/copilot` does not exist on current runners, because the CLI is installed
into the toolcache and put on `PATH`. That ENOENT failed the 2026-08-17 run, which is why **W34 is
missing**. Recompiling with the pinned **v0.85.4** emits `/usr/local/bin/copilot` again. With the
patch re-applied, the lock diff would be exactly one line (`body_hash`).

**Re-applying the patch was blocked** by Claude Code's auto-mode safety check as a CI bypass
(hand-editing a `DO NOT EDIT` generated file). That is a reasonable flag, so the call belongs to the
owner, not an agent.

### B2 — The toolchain is not actually pinned on this machine

CLAUDE.md says to pin gh-aw. Locally:

- The installed extension was **v0.86.2**, not v0.85.4. Compiling with it rewrites ~250 lock lines
  (setup action, Copilot CLI 1.0.79, GitHub MCP server 1.9, prompt assembly), which is an upgrade,
  not a fix.
- `gh extension install github/gh-aw --pin v0.85.4 --force` **did not pin**: gh-aw upgraded itself to
  **v0.89.21** (~900 lock lines on compile). The installed extension is still v0.89.21.
- A matching compile was only possible with the v0.85.4 release binary (checksum-verified), run
  directly from the session scratchpad.

## Options to unblock

| # | Path | Lock diff | Trade-off |
|---|------|-----------|-----------|
| A | Owner recompiles with v0.85.4 and re-applies PR #5's two-line patch | 1 line | Keeps a hand patch in a generated file; it must be re-applied on every recompile |
| B | Upgrade gh-aw (v0.89.21 or later) **if** it emits a PATH-resolved `copilot` natively | large | Removes the hand patch for good; a toolchain upgrade to review and prove with a `workflow_dispatch` run. **Unverified**, so check first |
| C | Ship the `docs/index.html` fix alone now, and the workflow change later with A or B | none | Closes it today; may regress on the next Monday run |

**Recommended:** check B first. If the newer compiler resolves `copilot` itself, do the upgrade as its
own item (with a dispatch run as proof) and fold this fix into it. That removes B1 permanently.
Otherwise use A.

## Scope

Files touched: `docs/index.html`, `.github/workflows/weekly-ai-digest.md`,
`.github/workflows/weekly-ai-digest.lock.yml`, and `.github/aw/actions-lock.json` (only if upgrading).

Out of scope, noted while here:

- **Embedded JSON break-out.** Story data is inlined in `<script type="application/json">`, so a
  field containing `</script>` would end the block early. Worth one more instruction line (escape `<`
  as `<` in the inlined JSON), but there is no evidence of it happening.
- **Highlights block.** It is static HTML the agent writes directly, not built by the script, so
  escaping there depends on the agent. Same class of issue, lower risk, not covered by this fix.

## Acceptance recap

- `docs/index.html` renders story fields with `textContent`/`append()`; links only for `http(s)`.
- The workflow instructions require it, and the preflight checks it.
- Lock recompiled and committed with the `.md` (+ `actions-lock.json` if it changed);
  `gh aw compile` 0 errors / 0 warnings.
- The harness invocation still resolves `copilot` via `PATH`, and **a `workflow_dispatch` run
  succeeds**.
- The **next weekly page** still has no `innerHTML` on story fields (observed, not assumed).

## Outcome

Status: Open — fix written and tested, blocked on B1/B2. The working-tree changes were reverted; the
diffs above are the record.
Commit: —
