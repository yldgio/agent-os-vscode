#Requires -Version 5.1
[CmdletBinding()]
param ()

Write-Host "🚀 Agent OS VS Code Setup"
Write-Host "========================="
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

# Ask user for VS Code version
Write-Host "Which VS Code version are you using?"
Write-Host "1. VS Code (stable)"
Write-Host "2. VS Code Insiders"
Write-Host ""
do {
    $codeChoice = Read-Host "Enter your choice (1 or 2)"
} while ($codeChoice -notin @("1", "2"))

# Determine VS Code user path
if ($codeChoice -eq "1") {
    $vscodeUserPath = Join-Path -Path $env:APPDATA -ChildPath "Code\User"
    $vscodeVersion = "VS Code"
} else {
    $vscodeUserPath = Join-Path -Path $env:APPDATA -ChildPath "Code - Insiders\User"
    $vscodeVersion = "VS Code Insiders"
}

# Check if VS Code user directory exists
if (-not (Test-Path -Path $vscodeUserPath)) {
    Write-Host "❌ $vscodeVersion user directory not found at: $vscodeUserPath"
    Write-Host ""
    Write-Host "Please make sure $vscodeVersion is installed and has been run at least once."
    exit 1
}

Write-Host ""
Write-Host "✅ Found $vscodeVersion user directory: $vscodeUserPath"
Write-Host ""

# Ask user for prefix
Write-Host "Do you want to add a prefix to the prompt and instruction files?"
Write-Host "This can help organize your files (e.g., 'g-', 'u-', 'agent-')"
Write-Host ""
$prefix = Read-Host "Enter prefix (leave empty for no prefix)"
if ($prefix -and -not $prefix.EndsWith("-")) {
    $prefix += "-"
}

# Create directories
Write-Host "📁 Creating directories..."
$promptsPath = Join-Path -Path $vscodeUserPath -ChildPath "prompts"
New-Item -Path $promptsPath -ItemType Directory -Force | Out-Null

# Base URL for raw GitHub content
$baseUrl = "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main"

Write-Host ""
Write-Host "📥 Downloading and setting up $vscodeVersion files..."

# Function to process a command file as prompt
function Invoke-ProcessPromptFile {
    param (
        [string]$Command
    )
    $tempFile = Join-Path -Path $env:TEMP -ChildPath "$Command.md"
    $targetFile = Join-Path -Path $promptsPath -ChildPath "$prefix$Command.prompt.md"

    try {
        $url = "$baseUrl/commands/$Command.md"
        Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop

        $frontMatter = @"
---
description: "Agent OS $Command command"
---

"@
        $content = Get-Content -Path $tempFile -Raw
        Set-Content -Path $targetFile -Value ($frontMatter + $content)

        Remove-Item -Path $tempFile

        Write-Host "  ✓ $targetFile"
    } catch {
        Write-Error "  ❌ Failed to download $Command.md: $_"
        return 1
    }
    return 0
}

# Function to process standards files as instructions
function Invoke-ProcessInstructionFile {
    param (
        [string]$FileName,
        [string]$SourcePath
    )
    $tempFile = Join-Path -Path $env:TEMP -ChildPath $FileName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $targetFile = Join-Path -Path $promptsPath -ChildPath "$prefix$baseName.instructions.md"

    try {
        $url = "$baseUrl/$SourcePath/$FileName"
        Invoke-WebRequest -Uri $url -OutFile $tempFile -ErrorAction Stop

        $frontMatter = @"
---
description: "Agent OS $baseName standards"
---

"@
        $content = Get-Content -Path $tempFile -Raw
        Set-Content -Path $targetFile -Value ($frontMatter + $content)

        Remove-Item -Path $tempFile

        Write-Host "  ✓ $targetFile"
    } catch {
        Write-Error "  ❌ Failed to download $FileName`: $($_)"
        return 1
    }
    return 0
}

# Process command files as prompts
Write-Host ""
Write-Host "📋 Processing command files as prompts:"
$commands = @(
    "plan-product",
    "create-spec",
    "execute-tasks",
    "analyze-product"
)

foreach ($cmd in $commands) {
    Invoke-ProcessPromptFile -Command $cmd
}

# Process standards files as instructions
Write-Host ""
Write-Host "📖 Processing standards files as instructions:"
$standardsFiles = @(
    @{ Name = "tech-stack.md"; Path = "standards" },
    @{ Name = "code-style.md"; Path = "standards" },
    @{ Name = "best-practices.md"; Path = "standards" },
    @{ Name = "css-style.md"; Path = "standards/code-style" },
    @{ Name = "html-style.md"; Path = "standards/code-style" },
    @{ Name = "javascript-style.md"; Path = "standards/code-style" }
)

foreach ($file in $standardsFiles) {
    Invoke-ProcessInstructionFile -FileName $file.Name -SourcePath $file.Path
}

Write-Host ""
Write-Host "✅ Agent OS $vscodeVersion setup complete!"
Write-Host ""
Write-Host "📍 Files installed to:"
Write-Host "   $promptsPath"
Write-Host ""

if ($prefix) {
    Write-Host "📝 Files created with prefix '$prefix':"
    Write-Host "   Prompts: $prefix[name].prompt.md"
    Write-Host "   Instructions: $prefix[name].instructions.md"
    Write-Host ""
}

Write-Host "Next steps:"
Write-Host ""
Write-Host "1. Open $vscodeVersion"
Write-Host "2. Use Ctrl+Shift+P and search for 'Prompts'"
Write-Host "3. Select your Agent OS prompts and instructions:"

if ($prefix) {
    Write-Host "   • $prefix" + "plan-product.prompt.md - Initialize a new product"
    Write-Host "   • $prefix" + "analyze-product.prompt.md - Add Agent OS to existing codebase"
    Write-Host "   • $prefix" + "create-spec.prompt.md - Plan a new feature"
    Write-Host "   • $prefix" + "execute-tasks.prompt.md - Build and ship code"
    Write-Host "   • $prefix" + "tech-stack.instructions.md - Your tech stack standards"
    Write-Host "   • $prefix" + "code-style.instructions.md - Your code style standards"
    Write-Host "   • $prefix" + "best-practices.instructions.md - Your development practices"
} else {
    Write-Host "   • plan-product.prompt.md - Initialize a new product"
    Write-Host "   • analyze-product.prompt.md - Add Agent OS to existing codebase"
    Write-Host "   • create-spec.prompt.md - Plan a new feature"
    Write-Host "   • execute-tasks.prompt.md - Build and ship code"
    Write-Host "   • tech-stack.instructions.md - Your tech stack standards"
    Write-Host "   • code-style.instructions.md - Your code style standards"
    Write-Host "   • best-practices.instructions.md - Your development practices"
}

Write-Host ""
Write-Host "Learn more at https://buildermethods.com/agent-os"
Write-Host ""
