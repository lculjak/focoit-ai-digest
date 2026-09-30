# FAD-008 — Owner response (slice 1: `digest.focoit.com`)

Date: 2026-09-30 (steps 1–6)
Status: IN PROGRESS — step 7 pending the next weekly digest merge

## Checklist

- [x] 1. `focoit.com` verified for GitHub Pages
- [x] 2. Cloudflare `digest` CNAME → `lculjak.github.io` (DNS only)
- [x] 3. PR #16 merged; Pages DNS check successful
- [x] 4. Enforce HTTPS on
- [x] 5. `https://digest.focoit.com/` 200 + old URL 301
- [x] 6. Link live on focoit.com
- [ ] 7. `docs/CNAME` survived the next digest merge (week: ____)

## Notes

All times UTC, 2026-09-30. Each line is what was **observed**, not what was done.

1. **Domain verification** — owner added the TXT record in Cloudflare and verified at
   github.com/settings/pages. Observed after the merge: `_github-pages-challenge-lculjak.focoit.com`
   resolves (via 1.1.1.1), and the Pages API reports `protected_domain_state: verified`.
2. **DNS** — owner added `digest` CNAME, DNS only. Observed: `digest.focoit.com` → CNAME
   `lculjak.github.io` → GitHub's `185.199.108–111.153` (A) and `2606:50c0:800x::153` (AAAA) — a
   proxied record would have returned Cloudflare IPs instead.
3. **Merge** — [PR #16](https://github.com/lculjak/focoit-ai-digest/pull/16) merged **23:24:05**;
   Pages build `built` 23:24:06. API: `cname: digest.focoit.com`. DNS was in place **before** the
   merge, so the github.io redirect never pointed at a dead host.
4. **HTTPS** — certificate `approved` at first check (Let's Encrypt `YR2`, CN `digest.focoit.com`,
   expires **2026-12-29**; GitHub renews it). **Enforce HTTPS set by Claude via the Pages API**
   (`PUT /repos/lculjak/focoit-ai-digest/pages https_enforced=true`), read back as `true`.
5. **Live** — `https://digest.focoit.com/` → **200**, TLS verifies, title *Focoit Weekly AI & Cloud
   Digest*. `http://digest.focoit.com/` → **301** → https. `https://lculjak.github.io/focoit-ai-digest/`
   → **301** → `https://digest.focoit.com/`.
6. **focoit.com link** — [lculjak/focoitwebsite#31](https://github.com/lculjak/focoitwebsite/pull/31)
   merged **23:32:17**; SWA deploy + Guardian succeeded. "AI Digest" → `https://digest.focoit.com/`
   after "Writing" in the primary nav. Observed in the **live** HTML of `/`, `/blog/`,
   `/blog/llm-agent-mcp/`, `/blog/enterprise-chat-on-azure/` (one link each). Pre-merge local check:
   one-line nav at 1280 px; at 375 px the item is visible in the toggled menu with no horizontal
   scroll. `/reports/` deliberately has no link.

## Step 7 — pending

Next weekly run: after its `[digest]` PR merges, confirm `docs/CNAME` still reads
`digest.focoit.com` and the custom domain serves the new week.
