# Vireo Runner — manages the .runner task lifecycle
# Usage (from Cursor terminal, project root):
#   powershell -File .runner/runner.ps1          # watch loop
#   powershell -File .runner/runner.ps1 -Once    # process one task then exit
# Then tell the Cursor chat: "run next" — the agent reads CURRENT_TASK.md and works.

param([switch]$Once)

$runnerDir = $PSScriptRoot
$inbox   = Join-Path $runnerDir 'inbox'
$running = Join-Path $runnerDir 'running'
$done    = Join-Path $runnerDir 'done'
$current = Join-Path $running 'CURRENT_TASK.md'

foreach ($d in @($inbox, $running, $done)) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null }
}

Write-Host "Vireo Runner watching: $inbox" -ForegroundColor Cyan

while ($true) {
    # Skip if a task is already in progress (CURRENT_TASK.md exists)
    if (Test-Path $current) {
        $active = Get-Content $current -Raw
        Write-Host "[waiting] task in progress: $active" -ForegroundColor Yellow
    } else {
        $task = Get-ChildItem $inbox -Filter 'P*.json' | Sort-Object Name | Select-Object -First 1
        if ($task) {
            $dest = Join-Path $running $task.Name
            Move-Item $task.FullName $dest -Force
            $json = Get-Content $dest -Raw | ConvertFrom-Json
            Set-Content $current "# CURRENT TASK`n`nFile: .runner/running/$($task.Name)`nID: $($json.id)`nTitle: $($json.title)`n`nRead the JSON, execute the steps, run the gates, then write .runner/done/$($json.id)_report.md per AGENTS.md."
            Write-Host "[READY] $($json.id): $($json.title)" -ForegroundColor Green
            Write-Host "        -> tell Cursor: 'run next'" -ForegroundColor Green
            if ($Once) { exit 0 }
        }
    }
    Start-Sleep -Seconds 5
}
