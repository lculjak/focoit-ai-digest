# Focoit Weekly AI Digest

A self-updating, self-contained **static site** that curates ~15 AI/cloud stories each week through a
**Focoit lens** (Azure + AI architecture, with a GitHub/Copilot developer-tools slice), explains why
each matters to a solution architect in regulated industries, and publishes via a **human-gated pull
request**. As a byproduct it emits 3–5 LinkedIn post angles.

Built on **GitHub Agentic Workflows (`gh-aw`, `engine: claude`)** and hosted on **GitHub Pages**.

## How it works

```
schedule (weekly cron) ─► gh-aw agent ─► agent output ─► threat detection
   │                     (read-only, sandboxed,   │              │
manual dispatch           network allow-list)      │              ▼
                                                   │      safe-outputs: create-pull-request
                                                   ▼         (labels: digest, automated)
                                     docs/index.html + docs/data/*.json      │
                                                                             ▼
                                                              (optional) label-gated auto-merge
                                                                             │
                                                                             ▼
                                                              GitHub Pages deploy (main /docs)
```

- The agent job runs **read-only, containerized, firewalled** to an allow-list of sources.
- Secrets never enter the sandbox; the write-back happens via `safe-outputs`.
- A **threat-detection** job scans proposed output before it becomes a PR.
- The **PR is the integration boundary** — diff, labels, checks, and a place to stop automation.

## Layout

| Path | What |
|------|------|
| `.github/workflows/weekly-ai-digest.md` | gh-aw source (authored) |
| `.github/workflows/weekly-ai-digest.lock.yml` | `gh aw compile` output (committed) |
| `.github/workflows/auto-merge-digest.yml` | label-gated auto-merge (optional; manual first) |
| `.github/workflows/guardian.yml` | deterministic repo gate (structure + secrets) on push/PR |
| `docs/` | GitHub Pages root — `index.html` (generated), `data/*.json`, `assets/` |
| `policies/`, `roadmap/`, `scripts/` | adopted AI-engineering playbook layer (see below) |

## Run it

1. Add repo secret `ANTHROPIC_API_KEY` (Settings → Secrets → Actions).
2. Install the gh-aw extension (pin a version): `gh extension install githubnext/gh-aw`.
3. Compile the workflow: `gh aw compile` → commit the `.md` **and** the generated `.lock.yml`.
4. Enable Pages: **Settings → Pages → Deploy from branch → `main` / `docs`**.
5. Trigger a manual `workflow_dispatch`; review the `[digest]` PR; merge; confirm the Pages URL.

The build/adoption backlog and acceptance criteria live in
[roadmap/pending-improvements.md](roadmap/pending-improvements.md); the full design is in the draft
spec this repo was scaffolded from.

## Engineering practices

This repo adopted the **AI Engineering Playbook** framework (tiered model execution, a deterministic
Guardian quality gate, an auditable backlog + dogfooding loop). See
[CLAUDE.md](CLAUDE.md) and [policies/](policies/). It is classified **non-sensitive / personal**.
