<img width="1280" height="640" alt="agent-os-og" src="https://github.com/user-attachments/assets/e897628e-7063-4bab-a69a-7bb6d7ac8403" />

## Your system for spec-driven agentic development.

[Agent OS](https://buildermethods.com/agent-os) transforms AI coding agents from confused interns into productive developers. With structured workflows that capture your standards, your stack, and the unique details of your codebase, Agent OS gives your agents the specs they need to ship quality code on the first try—not the fifth.

Use it with:

✅ Claude Code, Cursor, or any other AI coding tool.

✅ New products or established codebases.

✅ Big features, small fixes, or anything in between.

✅ Any language or framework.

---

## Install Agent OS on Windows

### Prerequisites

- Windows PowerShell 5.1 or later (or PowerShell 7+)
- Internet connection for downloading files

### 1. Base Installation

Open PowerShell as Administrator and run the following one-liner to install Agent OS:

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup.ps1" -UseBasicParsing).Content
```

**What this does:**

- Creates `~/.agent-os/` directory structure in your user profile
- Downloads your development standards files
- Downloads Agent OS instruction files
- Sets up the foundation for AI coding agents

**Optional flags:**

```powershell
# Overwrite existing instruction files
Invoke-Expression "& { $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup.ps1' -UseBasicParsing).Content } -OverwriteInstructions"

# Overwrite existing standards files  
Invoke-Expression "& { $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup.ps1' -UseBasicParsing).Content } -OverwriteStandards"
```

### 2. Customize Your Standards

⚠️ **Important:** After installation, customize the standards files in `%USERPROFILE%\.agent-os\standards\` to match your preferences:

- `tech-stack.md` - Your default frameworks, libraries, and tools
- `code-style.md` - Your formatting rules and naming conventions  
- `best-practices.md` - Your development philosophy and patterns

### 3. Tool-Specific Setup

Choose your AI coding tool:

#### For Claude Code

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup-claude-code.ps1" -UseBasicParsing).Content
```

Then use these commands in Claude Code:

- `/plan-product` - Initialize a new product
- `/analyze-product` - Add Agent OS to existing codebase
- `/create-spec` - Plan a new feature
- `/execute-tasks` - Build and ship code

#### For Cursor

Navigate to your project root directory in PowerShell, then run:

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup-cursor.ps1" -UseBasicParsing).Content
```

Then use these commands in Cursor:

- `@plan-product` - Initialize a new product
- `@analyze-product` - Add Agent OS to existing codebase
- `@create-spec` - Plan a new feature
- `@execute-tasks` - Build and ship code

#### For VS Code

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup-vscode.ps1" -UseBasicParsing).Content
```

The script will ask you:

1. **VS Code version**: Choose between VS Code (stable) or VS Code Insiders
2. **File prefix**: Optional prefix for organizing files (e.g., 'g-', 'u-', 'agent-')

This creates prompt and instruction files in your VS Code user directory:

- **Commands → Prompts**: `plan-product.prompt.md`, `create-spec.prompt.md`, etc.
- **Standards → Instructions**: `tech-stack.instructions.md`, `code-style.instructions.md`, etc.

Then use these files in VS Code:

- Press `Ctrl+Shift+P` and search for "Prompts"
- Select your Agent OS prompts and instructions:
  - `plan-product.prompt.md` - Initialize a new product
  - `analyze-product.prompt.md` - Add Agent OS to existing codebase
  - `create-spec.prompt.md` - Plan a new feature
  - `execute-tasks.prompt.md` - Build and ship code
  - `tech-stack.instructions.md` - Your tech stack standards
  - `code-style.instructions.md` - Your code style standards
  - `best-practices.instructions.md` - Your development practices

### Alternative Installation Methods

**Download and run locally:**

```powershell
# Download the setup script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yldgio/agent-os-vscode/main/setup.ps1" -OutFile "setup.ps1"

# Run with parameters
.\setup.ps1 -OverwriteInstructions -OverwriteStandards
```

---

### Documentation & Installation (Non-Windows)

For Linux, macOS, and detailed documentation 👉 [buildermethods.com/agent-os](https://buildermethods.com/agent-os)

---

### Created by Brian Casel @ Builder Methods

Created by Brian Casel, the creator of [Builder Methods](https://buildermethods.com), where Brian helps professional software developers and teams build with AI.

Get Brian's free resources on building with AI:

- [Builder Briefing newsletter](https://buildermethods.com)
- [YouTube](https://youtube.com/@briancasel)

