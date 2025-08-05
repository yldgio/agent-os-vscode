#Requires -Version 5.1
[CmdletBinding()]
param ()

Write-Host "🚀 Agent OS Claude Code Setup"
Write-Host "============================="
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

# Base URL for raw GitHub content
$baseUrl = "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main"

# Create directories
Write-Host "📁 Creating directories..."
$claudePath = Join-Path -Path $env:USERPROFILE -ChildPath ".claude"
$commandsPath = Join-Path -Path $claudePath -ChildPath "commands"
$agentsPath = Join-Path -Path $claudePath -ChildPath "agents"

New-Item -Path $commandsPath -ItemType Directory -Force | Out-Null
New-Item -Path $agentsPath -ItemType Directory -Force | Out-Null

# Function to download files
function Invoke-DownloadFile {
    param (
        [string]$Url,
        [string]$OutputPath
    )

    $FileName = Split-Path -Path $OutputPath -Leaf

    if (Test-Path -Path $OutputPath) {
        Write-Host "  ⚠️  $OutputPath already exists - skipping"
    } else {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $OutputPath -ErrorAction Stop
            Write-Host "  ✓ $OutputPath"
        } catch {
            Write-Error "  ❌ Failed to download $FileName`: $_"
        }
    }
}

# Download command files for Claude Code
Write-Host ""
Write-Host "📥 Downloading Claude Code command files to $commandsPath"

$commandFiles = @(
    "plan-product.md",
    "create-spec.md",
    "execute-tasks.md",
    "analyze-product.md"
)

foreach ($file in $commandFiles) {
    $url = "$baseUrl/commands/$file"
    $path = Join-Path -Path $commandsPath -ChildPath $file
    Invoke-DownloadFile -Url $url -OutputPath $path
}

# Download Claude Code agents
Write-Host ""
Write-Host "📥 Downloading Claude Code subagents to $agentsPath"

$agentFiles = @(
    "test-runner.md",
    "context-fetcher.md",
    "git-workflow.md",
    "file-creator.md",
    "date-checker.md"
)

foreach ($file in $agentFiles) {
    $url = "$baseUrl/claude-code/agents/$file"
    $path = Join-Path -Path $agentsPath -ChildPath $file
    Invoke-DownloadFile -Url $url -OutputPath $path
}

Write-Host ""
Write-Host "✅ Agent OS Claude Code installation complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   $commandsPath        - Claude Code commands"
Write-Host "   $agentsPath          - Claude Code specialized subagents"
Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "Initiate Agent OS in a new product's codebase with:"
Write-Host "  /plan-product"
Write-Host ""
Write-Host "Initiate Agent OS in an existing product's codebase with:"
Write-Host "  /analyze-product"
Write-Host ""
Write-Host "Initiate a new feature with:"
Write-Host "  /create-spec (or simply ask 'what's next?')"
Write-Host ""
Write-Host "Build and ship code with:"
Write-Host "  /execute-task"
Write-Host ""
Write-Host "Learn more at https://buildermethods.com/agent-os"
Write-Host ""
