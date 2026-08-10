# Execution prompt logs — focoit-ai-digest

Provenance for each backlog item executed through the four-tier loop (Kiro execute → Copilot Pro
review → gate). See [../../CLAUDE.md](../../CLAUDE.md) for the loop.

## Folder layout (one folder per item)

```
FAD-<id>/
  plan.md          design notes + frozen outcome (provenance; NEVER pasted into a tool)
  01-executor.md   ONLY the executor prompt — paste into Kiro
  02-reviewer.md   ONLY the reviewer prompt — paste into Copilot Pro
  03-revision.md   revision prompt (only if review flags issues)
  responses/
    01-executor.md   Kiro's completion summary
    02-reviewer.md   Copilot's PASS/FAIL report
    03-revision.md   revision summary (if a cycle happens)
```

## Conventions

- **Split prompts** so each file contains only the prompt (no surrounding prose) — cheaper to copy.
- **Responses are committed** alongside prompts as provenance (item → prompts → responses → commit).
- Scaffold a new item from [`_template/`](_template/).
- If a tool can't write files, paste its output into the response file manually before committing.
- The `plan.md` records design decisions and the frozen outcome; it is never pasted into any tool.
