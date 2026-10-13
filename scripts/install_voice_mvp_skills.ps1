param([string]$Destination = "$env:USERPROFILE\.agents\skills")
$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
New-Item -Path $Destination -ItemType Directory -Force | Out-Null
foreach ($skill in @("gd-roblox-kickoff", "roblox-mvp-builder")) {
  $from = Join-Path $root ("skills\" + $skill)
  $to = Join-Path $Destination $skill
  if (-not (Test-Path (Join-Path $from "SKILL.md"))) { throw "Skill not found: $from" }
  if (Test-Path $to) {
    $backup = "$to.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Move-Item -LiteralPath $to -Destination $backup
    Write-Host "Backup: $backup"
  }
  Copy-Item -LiteralPath $from -Destination $to -Recurse
  Write-Host "Installed $skill"
}
if (Get-Command git -ErrorAction SilentlyContinue) {
  $original = Join-Path $Destination "gd-doc-kickoff"
  if (-not (Test-Path $original)) {
    git clone https://github.com/VKSpaz/gd-doc-kickoff.git $original
    if ($LASTEXITCODE -ne 0) { Write-Warning "Original skill clone failed; Roblox skills installed." }
  }
  $sourceRef = Join-Path $original "references"
  $destinationRef = Join-Path $Destination "gd-roblox-kickoff\references\upstream"
  if (Test-Path $sourceRef) {
    New-Item -ItemType Directory -Force -Path $destinationRef | Out-Null
    Get-ChildItem $sourceRef -File | Copy-Item -Destination $destinationRef -Force
    Write-Host "Original GD interview reference texts installed."
  }
} else { Write-Warning "Git missing: original GD skill not copied; Roblox skills still installed." }
Write-Host "Restart Codex, then invoke $gd-roblox-kickoff followed by $roblox-mvp-builder."
