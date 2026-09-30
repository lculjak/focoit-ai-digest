# FAD-008 — Surface the digest under focoit.com — Plan

> Frozen provenance. Do NOT paste this file into any tool.

## Item

Backlog ref: [FAD-008](../../pending-improvements.md#fad-008)

## Slice 1 — `digest.focoit.com` on GitHub Pages

### Options considered (2026-09-30)

| Option | Effort | Verdict |
| --- | --- | --- |
| Link on focoit.com → `lculjak.github.io/focoit-ai-digest/` | one edit | Still wanted — becomes step 4 below, pointing at the custom domain |
| **`digest.focoit.com` → GitHub Pages** (`docs/CNAME` + Cloudflare CNAME) | minutes, no code | **Chosen** |
| Serve at `focoit.com/digest/` via a publisher in `focoitwebsite` (like `/reports/`) | script + CSP change | Deferred — see below |

**Why not `focoit.com/digest/` yet:** `focoitwebsite`'s `globalHeaders` CSP is `script-src 'self'`,
`style-src 'self'`. `docs/index.html` is one self-contained file with 2 inline `<script>` blocks (data
+ logic) and 1 inline `<style>`, so under focoit.com it would load **blank**. The fix is either a
per-route `'unsafe-inline'` for `/digest/*` (hashes don't work — the page changes weekly) or
externalising the template's JS/CSS (which the agent prompt must then be taught to preserve). Also
needs a canonical/duplicate-content decision. Worth it only once curation is proven (FAD-006/007).

### Design decisions

- `docs/CNAME` = `digest.focoit.com`, committed via PR (not via the Settings UI, which would commit
  straight to `main`).
- **No workflow change / recompile:** the agent writes only `docs/index.html` and `docs/data/*.json`,
  so the CNAME survives weekly runs. *Confirmed by observation on the next digest PR, not assumed.*
- **Ordering trap:** the moment the CNAME is live, `lculjak.github.io/focoit-ai-digest/` **redirects**
  to `digest.focoit.com`. DNS must exist **before** the PR merges or the site goes dark.
- **Domain verification first** (account-level, TXT record): once `digest` points at
  `lculjak.github.io`, verification guarantees no other GitHub account can claim a `focoit.com`
  subdomain on Pages.
- Cloudflare record **DNS only (grey cloud)**: a proxied record hides the CNAME target from GitHub and
  blocks Let's Encrypt certificate issuance.

## Scope

Files touched: `docs/CNAME`, `roadmap/pending-improvements.md`, this folder.
Owner actions: GitHub domain verification, Cloudflare DNS, merge, Enforce HTTPS, focoit.com link.

Out of scope: any change to `focoitwebsite` other than the link; `/digest/` on focoit.com.

## Outcome

Status: In progress — PR #16 open, awaiting owner steps 1–2 before merge.
