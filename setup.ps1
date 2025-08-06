#Requires -Version 5.1
[CmdletBinding()]
param (
    [Switch]$OverwriteInstructions,
    [Switch]$OverwriteStandards
)

Write-Host "🚀 Agent OS Setup Script"
Write-Host "========================"
Write-Host ""

# Base URL for raw GitHub content
$baseUrl = "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main"

# Home directory
$agentOsPath = Join-Path -Path $env:USERPROFILE -ChildPath ".agent-os"

# Create directories
Write-Host "📁 Creating directories..."
$standardsPath = Join-Path -Path $agentOsPath -ChildPath "standards"
$codeStylePath = Join-Path -Path $standardsPath -ChildPath "code-style"
$instructionsPath = Join-Path -Path $agentOsPath -ChildPath "instructions"
$coreInstructionsPath = Join-Path -Path $instructionsPath -ChildPath "core"
$metaInstructionsPath = Join-Path -Path $instructionsPath -ChildPath "meta"

New-Item -Path $standardsPath -ItemType Directory -Force | Out-Null
New-Item -Path $codeStylePath -ItemType Directory -Force | Out-Null
New-Item -Path $coreInstructionsPath -ItemType Directory -Force | Out-Null
New-Item -Path $metaInstructionsPath -ItemType Directory -Force | Out-Null

# Function to download files
function Download-File {
    param (
        [string]$Url,
        [string]$OutputPath,
        [switch]$Overwrite
    )

    $FileName = Split-Path -Path $OutputPath -Leaf

    if ((Test-Path -Path $OutputPath) -and -not $Overwrite) {
        Write-Host "  ⚠️  $OutputPath already exists - skipping"
    } else {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $OutputPath -ErrorAction Stop
            if ($Overwrite) {
                Write-Host "  ✓ $OutputPath (overwritten)"
            } else {
                Write-Host "  ✓ $OutputPath"
            }
        } catch {
            Write-Error "  ❌ Failed to download $FileName`: $_"
        }
    }
}

# Download standards files
Write-Host ""
Write-Host "📥 Downloading standards files to $standardsPath"

$standardsFiles = @(
    "tech-stack.md",
    "code-style.md",
    "best-practices.md"
)

foreach ($file in $standardsFiles) {
    $url = "$baseUrl/standards/$file"
    $path = Join-Path -Path $standardsPath -ChildPath $file
    Download-File -Url $url -OutputPath $path -Overwrite:$OverwriteStandards
}

# Download code-style subdirectory files
Write-Host ""
Write-Host "📥 Downloading code style files to $codeStylePath"

$codeStyleFiles = @(
    "css-style.md",
    "html-style.md",
    "javascript-style.md"
)

foreach ($file in $codeStyleFiles) {
    $url = "$baseUrl/standards/code-style/$file"
    $path = Join-Path -Path $codeStylePath -ChildPath $file
    Download-File -Url $url -OutputPath $path -Overwrite:$OverwriteStandards
}

# Download instruction files
Write-Host ""
Write-Host "📥 Downloading instruction files to $instructionsPath"

# Core instruction files
Write-Host "  📂 Core instructions:"
$coreInstructionFiles = @(
    "plan-product.md",
    "create-spec.md",
    "execute-tasks.md",
    "execute-task.md",
    "analyze-product.md"
)

foreach ($file in $coreInstructionFiles) {
    $url = "$baseUrl/instructions/core/$file"
    $path = Join-Path -Path $coreInstructionsPath -ChildPath $file
    Download-File -Url $url -OutputPath $path -Overwrite:$OverwriteInstructions
}

# Meta instruction files
Write-Host ""
Write-Host "  📂 Meta instructions:"
$metaInstructionFiles = @(
    "pre-flight.md"
)

foreach ($file in $metaInstructionFiles) {
    $url = "$baseUrl/instructions/meta/$file"
    $path = Join-Path -Path $metaInstructionsPath -ChildPath $file
    Download-File -Url $url -OutputPath $path -Overwrite:$OverwriteInstructions
}

Write-Host ""
Write-Host "✅ Agent OS base installation complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   $standardsPath     - Your development standards"
Write-Host "   $instructionsPath  - Agent OS instructions"
Write-Host ""

if (-not $OverwriteInstructions -and -not $OverwriteStandards) {
    Write-Host "💡 Note: Existing files were skipped to preserve your customizations"
    Write-Host "   Use -OverwriteInstructions or -OverwriteStandards to update specific files"
} else {
    Write-Host "💡 Note: Some files were overwritten based on your flags"
    if (-not $OverwriteInstructions) {
        Write-Host "   Existing instruction files were preserved"
    }
    if (-not $OverwriteStandards) {
        Write-Host "   Existing standards files were preserved"
    }
}

Write-Host ""
Write-Host "Next steps:"
Write-Host ""
Write-Host "1. Customize your coding standards in $standardsPath"
Write-Host ""
Write-Host "2. Install commands for your AI coding assistant(s):"
Write-Host ""
Write-Host "   - Using Claude Code? Install the Claude Code commands with:"
Write-Host "     Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup-claude-code.ps1)"
Write-Host ""
Write-Host "   - Using Cursor? Install the Cursor commands with:"
Write-Host "     Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup-cursor.ps1)"
Write-Host ""
Write-Host "   - Using VS Code? Install the VS Code commands with:"
Write-Host "     Invoke-Expression (Invoke-WebRequest -Uri https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup-vscode.ps1)"
Write-Host ""
Write-Host "   - Using something else? See instructions at https://buildermethods.com/agent-os"
Write-Host ""
Write-Host "Learn more at https://buildermethods.com/agent-os"
Write-Host ""
