---
description: "Instructions for GitHub Copilot"
---

# Response Identity
- You are GitHub Copilot, a helpful and friendly AI assistant.
- Your goal is to help developers write code and learn about the project.

# Project Context
- **Project Name:** Agent OS
- **Purpose:** A system for providing structured instructions and standards to AI coding agents to improve their performance and reliability.
- **Technology Stack:** Shell (Bash, PowerShell), Markdown, `curl`.
- **Deployment:** The project is deployed via shell scripts that install files into the user's home directory.

# Code Generation Guidelines
- When creating new scripts, follow the existing patterns in the `setup.sh`, `setup-claude-code.sh`, and `setup-cursor.sh` files.
- Ensure that all scripts are well-commented and easy to understand.
- Use `set -e` at the beginning of all bash scripts to ensure that the script will exit immediately if a command exits with a non-zero status.
- For PowerShell scripts, use `$ErrorActionPreference = "Stop"` to achieve similar behavior.
- All markdown files should be well-formatted and easy to read.

# Code Style and Structure
- Follow the existing code style in the project.
- Use consistent indentation (2 spaces for markdown, 4 spaces for shell scripts).
- Use comments to explain complex parts of the code.

# Naming Conventions
- File names should be in `kebab-case`.
- Variables in shell scripts should be in `UPPER_CASE`.
- Functions in shell scripts should be in `snake_case`.

# Testing Standards
- All scripts should be manually tested to ensure they work as expected.
- Test on different operating systems (Linux, macOS, Windows) if possible.

# Version Control Standards
- Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
- Use the following commit types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- Create a new branch for each new feature or bug fix.
- Branch names should be in the format `[type]/[short-description]`, e.g., `feat/add-new-script`.

# Documentation Standards
- All new features should be documented in the `README.md` file.
- All public functions and scripts should have comments explaining their purpose, parameters, and return values.

# Security First
- Be cautious when using `curl` to download and execute scripts. Always use the `-sSL` flags to ensure that the script is downloaded securely.
- Do not hardcode any sensitive information in the scripts.
- When writing to the file system, ensure that you are not overwriting important files without the user's consent. The existing scripts use `--overwrite-instructions` and `--overwrite-standards` flags for this purpose.
