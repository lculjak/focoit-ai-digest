<#
.SYNOPSIS
    Install the Repository Guardian git hooks for this clone.

.DESCRIPTION
    Points git at the version-controlled .githooks/ directory so the deterministic
    pre-commit validation (scripts/validate-repository.ps1) runs on every commit.
    Run once per clone. Reusable across machines - no per-machine paths.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot = (& git rev-parse --show-toplevel 2>$null)
if (-not $repoRoot) { Write-Error 'Not inside a git repository.'; exit 1 }
Set-Location $repoRoot

& git config core.hooksPath .githooks

# Ensure the hook is executable where the filesystem tracks that bit (WSL/macOS/Linux).
if (Get-Command git -ErrorAction SilentlyContinue) {
    & git update-index --chmod=+x .githooks/pre-commit 2>$null | Out-Null
}

Write-Host '[guardian] Hooks installed: core.hooksPath -> .githooks' -ForegroundColor Green
Write-Host '           Pre-commit will run scripts/validate-repository.ps1 on each commit.'
Write-Host '           Optional: install gitleaks for full secret scanning.'
