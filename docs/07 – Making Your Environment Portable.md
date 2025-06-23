# 07 – Making Your Environment Portable

## Overview

A key benefit of Dev Containers is that they encapsulate development environments into a portable, shareable form. When properly structured, any collaborator or system can reproduce the exact same environment with minimal setup. This guide explains how to achieve full portability of your environment.

---

## Repository Structure

Keep your project organized:

```text
my-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   ├── .env
│   └── setup.sh
├── README.md
└── (project files)
```

All configuration is committed to version control, except `.env`, which is listed in `.gitignore`.

---

## GitHub-First Workflow

### Step 1: Push Your Project

Push your full project, including the `.devcontainer/` folder, to GitHub:

```bash
git init
git add .
git commit -m "Initial devcontainer setup"
git remote add origin git@github.com:your-user/your-repo.git
git push -u origin main
```

### Step 2: Clone and Reuse Anywhere

On any new system with Docker and VS Code:

```bash
git clone git@github.com:your-user/your-repo.git
cd your-repo
code .
```

VS Code will prompt to **Reopen in Container**. No additional setup is needed.

---

## Using `postCreateCommand` and Environment Variables

To ensure required tooling is initialized automatically and secrets are injected securely, use a `setup.sh` provisioning script and the `runArgs` option to inject environment variables from `.env`.

### Configure `devcontainer.json`

```json
"runArgs": [
  "--env-file", ".devcontainer/.env"
],
"postCreateCommand": "bash .devcontainer/setup.sh"
```

This ensures that secrets like GitHub PATs are available to your scripts and tools.

---

## Defining `.env` for Secrets

Create `.devcontainer/.env` with content like:

```env
GITHUB_PAT=ghp_yourtokenhere
GITHUB_USER=your-github-username
GIT_EMAIL=your@email.com
```

Ensure no spaces around `=` and use LF line endings. Do not commit this file.

---

## Example `setup.sh`

Place this script in `.devcontainer/setup.sh`:

```bash
#!/bin/bash
set -e

echo "[INFO] Provisioning development tools..."

echo "[INFO] Setting Git identity..."
git config --global user.name "${GITHUB_USER}"
git config --global user.email "${GIT_EMAIL}"
git config --global init.defaultBranch main

echo "[INFO] Authenticating GitHub CLI..."
echo "${GITHUB_PAT}" | gh auth login --with-token

echo "[INFO] Setup complete."
```

Make it executable:

```bash
chmod +x .devcontainer/setup.sh
```

---

## Using Microsoft Dev Container Features

Microsoft Dev Container Features provide modular capabilities such as:

* Common utilities (git, curl, unzip)
* Node.js, Python, Go, Java
* SSH agent, GitHub CLI, AWS CLI

Add via `devcontainer.json`:

```json
"features": {
  "ghcr.io/devcontainers/features/github-cli:1": {},
  "ghcr.io/devcontainers/features/common-utils:1": {}
}
```

These features are automatically provisioned during container build.

---

## Remote Containers Cache

Container images are cached by Docker. To remove or rebuild:

```bash
docker compose down --volumes --remove-orphans
```

Or directly rebuild from VS Code:

* `F1 → Dev Containers: Rebuild Container Without Cache`

This guarantees that `.env` and provisioning scripts are reloaded properly.

---

## Sharing with a Team

* Store environment logic in `.devcontainer/`
* Use `runArgs` and `.env` for token injection
* Provide `README.md` with setup steps
* Avoid using host-specific paths or assumptions
* Document required tools (Docker Desktop, VS Code, Remote extensions)

---

## Recommended Tooling

| Tool           | Purpose                         |
| -------------- | ------------------------------- |
| Docker Desktop | Container engine                |
| VS Code        | Editor and container frontend   |
| GitHub         | Source control and repo hosting |
| Dev Containers | Isolated per-project dev setup  |

---

## Managing Sensitive Files with .gitignore

Maintain a `.gitignore` file at the project root to protect sensitive or environment-specific files.

### Recommended Entries

```gitignore
# Environment variables
.devcontainer/.env

# VS Code workspace settings (optional)
.vscode/

# Node dependencies or Python environments (if used)
node_modules/
venv/

# System files
.DS_Store
Thumbs.db
```

Always exclude files that contain tokens, passwords, or machine-specific configurations.

---

## Summary

By using Microsoft Dev Containers and structuring your project as shown, you achieve:

* Full reproducibility
* Seamless portability
* Minimal onboarding friction
* Clean separation between host and container environment

This completes the portability framework for resilient development environments using Windows 11, WSL2, Docker Desktop, and VS Code.
