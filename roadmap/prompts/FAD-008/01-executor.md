# FAD-008 — Owner action checklist (slice 1: `digest.focoit.com`)

> No Kiro execution for this item. Follow the steps **in order** — step 3 (merge) must come after
> step 2 (DNS), or the site goes dark. Tick each box as you go, then record the outcome in
> `responses/01-executor.md`.

---

## Step 1 — Verify `focoit.com` with GitHub Pages

Stops any other GitHub account from claiming a `focoit.com` subdomain on Pages.

1. Open **https://github.com/settings/pages** (your *account* settings, not the repo's).
2. **Add a domain** → enter `focoit.com` → **Add domain**.
3. GitHub shows a TXT record. In **Cloudflare → focoit.com → DNS → Records → Add record**:
   - Type: **TXT**
   - Name: `_github-pages-challenge-lculjak` (Cloudflare appends `.focoit.com`)
   - Content: the value GitHub shows
4. Check it has propagated (PowerShell):
   ```powershell
   Resolve-DnsName -Type TXT _github-pages-challenge-lculjak.focoit.com
   ```
5. Back on GitHub, click **Verify**. It should show `focoit.com` as **Verified**.

- [ ] `focoit.com` shows **Verified** at github.com/settings/pages

---

## Step 2 — Point `digest` at GitHub Pages

In **Cloudflare → focoit.com → DNS → Records → Add record**:

- Type: **CNAME**
- Name: `digest`
- Target: `lculjak.github.io` (no repo path, no `https://`)
- Proxy status: **DNS only** (grey cloud) — **not** proxied, or GitHub can't issue the certificate
- TTL: Auto

Check it (PowerShell):
```powershell
Resolve-DnsName digest.focoit.com
```
Expect a CNAME to `lculjak.github.io` and GitHub's `185.199.108–111.153` addresses.
Until step 3 merges, `http://digest.focoit.com` shows a GitHub 404 — that's expected.

- [ ] `digest.focoit.com` resolves to `lculjak.github.io` (grey cloud)

---

## Step 3 — Merge the PR

Merge [PR #16](https://github.com/lculjak/focoit-ai-digest/pull/16) (adds `docs/CNAME`).
Pages rebuilds in ~1 minute. Then open
**https://github.com/lculjak/focoit-ai-digest/settings/pages** — *Custom domain* should read
`digest.focoit.com` with a green **DNS check successful**.

- [ ] PR #16 merged; DNS check successful

---

## Step 4 — Enforce HTTPS

The certificate can take from a few minutes up to ~1 hour. On the same repo Pages settings page,
once the **Enforce HTTPS** checkbox becomes clickable, tick it.

- [ ] **Enforce HTTPS** ticked

(Or tell Claude "merged" — it can check the certificate and set this via the API.)

---

## Step 5 — Verify

```powershell
# 200, valid certificate
Invoke-WebRequest https://digest.focoit.com/ -Method Head | Select-Object StatusCode
# old URL now redirects (expect 301 → digest.focoit.com)
curl.exe -sI https://lculjak.github.io/focoit-ai-digest/ | Select-String 'HTTP/|location'
```
Open https://digest.focoit.com/ on desktop and phone: 15 cards, theme toggle, search, filters.

- [ ] `https://digest.focoit.com/` → 200, padlock valid
- [ ] old `github.io` URL → 301 to the custom domain

---

## Step 6 — Link it from focoit.com

In `focoitwebsite` (interactive `…\FocoIT\website` clone — **not** `website-reports`, which the
scheduled report publisher owns), add a "Weekly AI Digest" link → `https://digest.focoit.com/`,
via PR as usual. No cross-repo automation.

- [ ] Link live on https://focoit.com

---

## Step 7 — Confirm the CNAME survives a weekly run

After the **next** `[digest]` PR merges, confirm `docs/CNAME` still exists and
`https://digest.focoit.com/` serves the new week.

- [ ] `docs/CNAME` present after the next digest merge

---

## Done when

All boxes above are ticked, the outcome is recorded in `responses/01-executor.md`, and FAD-008 is
marked ✅ Done in `roadmap/pending-improvements.md` (with the date each check was observed).

## If something goes wrong

- **Site dark after merge** (github.io redirects, custom domain doesn't load): DNS isn't in yet —
  fix step 2, or revert PR #16 to restore the github.io URL.
- **"Enforce HTTPS" stays greyed out for hours:** the record is probably proxied (orange cloud) —
  switch to DNS only, then in repo Pages settings remove and re-save the custom domain.
- **Cloudflare SSL/TLS mode** doesn't matter while the record is grey-cloud (traffic bypasses Cloudflare).
