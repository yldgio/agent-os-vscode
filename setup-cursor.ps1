#Requires -Version 5.1
[CmdletBinding()]
param ()

Write-Host "🚀 Agent OS Cursor Setup"
Write-Host "========================"
Write-Host ""

# Check if Agent OS base installation is present
$agentOsPath = Join-Path -Path $env:USERPROFILE -ChildPath ".agent-os"
if (-not (Test-Path -Path (Join-Path -Path $agentOsPath -ChildPath "instructions")) -or -not (Test-Path -Path (Join-Path -Path $agentOsPath -ChildPath "standards"))) {
    Write-Host "⚠️  Agent OS base installation not found!"
    Write-Host ""
    Write-Host "Please install the Agent OS base installation first:"
    Write-Host ""
    Write-Host "Option 1 - Automatic installation:"
    Write-Host "  Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup.ps1)"
    Write-Host ""
    Write-Host "Option 2 - Manual installation:"
    Write-Host "  Follow instructions at https://buildermethods.com/agent-os"
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "📁 Creating .cursor/rules directory..."
$cursorRulesPath = Join-Path -Path $PSScriptRoot -ChildPath ".cursor/rules"
New-Item -Path $cursorRulesPath -ItemType Directory -Force | Out-Null

# Base URL for raw GitHub content
$baseUrl = "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main"

Write-Host ""
Write-Host "📥 Downloading and setting up Cursor command files..."

# Function to process a command file
function Invoke-ProcessCommandFile {
    param (
        [string]$Command
    )
    $tempFile = Join-Path -Path $env:TEMP -ChildPath "$Command.md"
    $targetFile = Join-Path -Path $cursorRulesPath -ChildPath "$Command.mdc"

    try {
        $url = "$baseUrl/commands/$Command.md"
        Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop

        $frontMatter = @"
---
alwaysApply: false
---

"@
        $content = Get-Content -Path $tempFile -Raw
        Set-Content -Path $targetFile -Value ($frontMatter + $content)

        Remove-Item -Path $tempFile

        Write-Host "  ✓ $targetFile"
    } catch {
        Write-Error "  ❌ Failed to download $Command.md`: $_"
        return 1
    }
    return 0
}

# Process each command file
$commands = @(
    "plan-product",
    "create-spec",
    "execute-tasks",
    "analyze-product"
)

foreach ($cmd in $commands) {
    Invoke-ProcessCommandFile -Command $cmd
}

Write-Host ""
Write-Host "✅ Agent OS Cursor setup complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   .cursor/rules/             - Cursor command rules"
Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "Use Agent OS commands in Cursor with @ prefix:"
Write-Host "  @plan-product    - Initiate Agent OS in a new product's codebase"
Write-Host "  @analyze-product - Initiate Agent OS in an existing product's codebase"
Write-Host "  @create-spec     - Initiate a new feature (or simply ask 'what's next?')"
Write-Host "  @execute-tasks    - Build and ship code"
Write-Host ""
Write-Host "Learn more at https://buildermethods.com/agent-os"
Write-Host ""
