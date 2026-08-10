---
on:
  schedule:
    - cron: '0 11 * * MON'   # Mondays 11:00 UTC (~08:00 ART) — fresh for the week
  workflow_dispatch:          # manual re-run from the Actions tab

permissions:
  contents: read
  pull-requests: read

engine: copilot               # requires COPILOT_GITHUB_TOKEN (fine-grained PAT; Copilot Requests: read)

# Cost controls (tune after first runs)
timeout-minutes: 20
max-ai-credits: 60

# Firewall allowlist — the agent can reach ONLY these
network:
  allowed:
    - defaults
    # Azure / Microsoft
    - "azure.microsoft.com"
    - "techcommunity.microsoft.com"
    - "devblogs.microsoft.com"
    - "azurecomcdn.azureedge.net"
    # GitHub / Copilot developer platform
    - "github.blog"
    - "github.githubassets.com"
    # AI labs
    - "www.anthropic.com"
    - "openai.com"
    # Industry signal (capped in curation)
    - "techcrunch.com"
    - "www.technologyreview.com"
    - "arstechnica.com"
    - "www.theverge.com"
    - "venturebeat.com"
    - "news.ycombinator.com"

safe-outputs:
  create-pull-request:
    title-prefix: "[digest] "
    labels: [digest, automated]
    base: main
    draft: false
    max: 1
---

# Weekly Focoit AI & Cloud Digest

You are curating a weekly digest for **Leonardo Culjak / Focoit**, an **Azure & AI
Solution Architect** serving **regulated industries (healthcare, finance)**. The reader
is a technical decision-maker who ships production systems. The lens is **Azure + AI
architecture first, with a GitHub/Copilot developer-tools slice** — NOT a general
consumer-AI newsfeed.

## 1. Research
Read the RSS/Atom feeds below for entries published in the **last 14 days**. For each,
capture: title, URL, source, publication date, plain-text excerpt.

Feeds:
- Azure updates / Azure blog        (azure.microsoft.com)
- Microsoft Tech Community — AI/Azure (techcommunity.microsoft.com)
- Microsoft DevBlogs                 (devblogs.microsoft.com)
- GitHub Blog / Changelog            (github.blog)
- Anthropic news                     (www.anthropic.com)
- OpenAI blog                        (openai.com)
- TechCrunch AI                      (techcrunch.com)
- MIT Technology Review              (www.technologyreview.com)
- Ars Technica                       (arstechnica.com)
- The Verge                          (www.theverge.com)
- VentureBeat AI                     (venturebeat.com)
- Hacker News (front page)           (news.ycombinator.com)

Deduplicate stories that appear across feeds; prefer the primary/official source URL.

## 2. Curate — HYBRID allocation (hard rules)
Select **exactly 15** stories:
- **>= 8** from the **Azure/Microsoft + GitHub/Copilot developer-platform** sources
  combined (the first four feeds), when that many qualifying entries exist.
- **<= 3** stories from any single other source.
- Rank each **High / Medium / Low** by *impact on a solution architect shipping on Azure*.
- Tag each with 2–5 tags from this controlled taxonomy:
  `azure, ai-platform, foundation-models, copilot, dev-tools, security, data,
   agents, mlops, governance, regulated-industry, open-source`.
- For each story write: **TL;DR** (1–2 sentences) and **Why it matters** (architect's
  angle — build-vs-buy, production/security/compliance-*aware* implications). Do not
  claim regulatory authority; frame compliance impact as *considerations*, not advice.

Then produce a **5-item "Azure & Developer Highlights"** block. Those 5 bullets may use
**only** Azure/Microsoft/GitHub sources (preserve provenance — no cross-source blending).

## 3. Generate the page — docs/index.html
One self-contained HTML5 file. No framework, no CDN, no build step. Include:
- System / light / dark theme (persisted); clean, brand-light Focoit look (navy/blue).
- Source filter chips (Azure/Microsoft + GitHub selected by default), tag filters,
  importance filter.
- Full-text search over title, source, TL;DR, why-it-matters, tags.
- Live "Showing X of 15 stories" counter; responsive cards (desktop + phone).
- Accessible labels; each card links out to the original source.
- A footer noting: generated weekly by an agentic workflow; last-updated timestamp.

## 4. Also write data + content ideas
- Write the machine-readable digest to `docs/data/digest-YYYY-Www.json`
  (array of {title,url,source,date,tldr,why,importance,tags}).
- Write `docs/data/post-ideas.json`: **3–5 LinkedIn post angles** derived from the top
  stories, in Leonardo's advisory-first, Azure/AI-architecture voice. Each: {hook,
  angle, which_story_urls, suggested_track: "azure"|"copilot"|"healthcare-ai"}.
  These are seeds for `focoit-post-writer`, not finished posts.

## 5. Preflight (self-check before output)
Verify: exactly 15 stories; all URLs unique and reachable-looking; allocation rules met;
highlights block uses only allowed sources; every card has all required fields. If a rule
cannot be met (e.g. too few Azure/MS entries this week), relax the >=8 floor to the max
available and note it in the PR body.
