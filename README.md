# Dev Environment with WSL2, Docker Desktop, and Visual Studio Code

## Project Overview

This repository provides a fully portable, reproducible, and Microsoft-aligned development environment for Windows 11 using WSL2, Docker Desktop, and Visual Studio Code with Dev Containers.

The project strictly follows Microsoft Dev Container standards and is designed to support secure, scalable, and team-oriented workflows with a GitHub-first approach.

---

## Key Features

* Native WSL2 and Ubuntu 24.04 integration
* Docker Desktop configuration for Windows 11
* Secure GitHub authentication using Personal Access Tokens (PATs)
* Fully portable and shareable development environment
* Feature-based Dev Container strategy using Microsoft base images
* Customizable dotfiles and VS Code settings
* Comprehensive troubleshooting and diagnostics guide

---

## Project Structure

```text
dev-env/
├── .devcontainer/
│   ├── devcontainer.json       # Core Dev Container configuration
│   ├── Dockerfile              # Optional base image customization
│   ├── setup.sh                # Provisioning and GitHub authentication script
│   └── .env                    # Environment variables (excluded from Git)
├── docs/                       # Step-by-step technical documentation
│   ├── 01-Installing-WSL-and-Ubuntu-24.04.md
│   ├── 02-Setting-up-Docker-Desktop-with-WSL2.md
│   ├── 03-Understanding-Dev-Containers.md
│   ├── 04-Creating-a-Dev-Container-Project.md
│   ├── 05-Authenticating-with-GitHub-inside-Dev-Containers.md
│   ├── 06-Customizing-with-Dotfiles-and-VS-Code-Settings.md
│   ├── 07-Making-Your-Environment-Portable.md
│   ├── 08-Dev-Container-Approaches-Features-vs-Dockerfile-vs-Prebuilt-Images.md
│   ├── 09-Templates-and-Starters.md
│   └── 10-Troubleshooting-Dev-Containers.md   
├── README.md                   # Project introduction and documentation map
├── .gitignore                  # Git exclusions for sensitive files
└── (project-specific files)
```

---

## Authentication Quick Check

Inside the Dev Container, verify GitHub authentication and Git configuration:

```bash
git config --get user.name
git config --get user.email
gh auth status
gh auth token
```

Confirm that:

* GitHub CLI is authenticated.
* Git is configured with the correct user.
* The active Personal Access Token is valid.

To validate repository access:

```bash
gh repo view <organization-or-user>/<repository-name> --json name,visibility,viewerPermission
```

Expected `viewerPermission` should be `WRITE` or `ADMIN`.

Test push permissions safely:

```bash
git push --dry-run origin main
```

---

## Quick Start Guide

There are two primary scenarios when working with this project:

### Case 1: Cloning an Existing Repository

#### 1. Clone the Repository

```bash
git clone https://github.com/your-repository.git
cd your-repository
code .
```

#### 2. Prepare the `.env` File

Inside `.devcontainer/.env` (create if missing):

```env
GITHUB_PAT=your-personal-access-token
GITHUB_USER=your-github-username
GIT_EMAIL=your-email@example.com
```

> Do not commit the `.env` file. It must be excluded via `.gitignore`.

#### 3. Launch the Dev Container

When prompted by Visual Studio Code:

* Select **Reopen in Container**

Or manually run:

```bash
F1 → Dev Containers: Rebuild Container Without Cache
```

#### 4. Validate the Setup

Inside the Dev Container, execute:

```bash
echo $GITHUB_USER
gh auth status
git config --get user.name
whoami
```

Expected Results:

* GitHub user is correctly loaded.
* GitHub CLI authentication is successful.
* User identity inside the container is `vscode`.

---

### Case 2: Initializing a New GitHub Repository

Follow these steps to create and push a new GitHub repository from the Dev Container:

#### 1. Initialize Local Repository

```bash
git init
```

#### 2. Configure Remote Repository

```bash
git remote add origin https://github.com/<organization-or-user>/<repository-name>.git
```

#### 3. Stage Project Files

```bash
git add .
```

#### 4. Create Initial Commit

```bash
git commit -m "Initial project setup with devcontainer configuration"
```

#### 5. Push to Remote Repository

```bash
git branch -M main
git push -u origin main
```

#### 6. Verify Remote Configuration

```bash
git remote -v
```

Ensure the remote URL uses HTTPS.

#### 7. Final Authentication Validation

```bash
git pull origin main
git push origin main
```

Confirm that GitHub authentication and push access are working correctly.

---

## Dev Container Design Strategy

* **Base Image:** Microsoft `mcr.microsoft.com/devcontainers/base:ubuntu`
* **User:** `vscode` (UID 1000) for permission consistency
* **Feature-Based Additions:**

  * GitHub CLI
  * Common utilities
* **Secure Authentication:** Secrets injected via environment variables
* **Portable Configuration:** Docker Desktop with WSL2 integration
* **Dotfiles Support:** Optional public dotfiles repository

---

## Documentation

Detailed step-by-step guides are available in the `docs/` folder.

| #  | Title                                                               | Purpose                                                 |
| -- | ------------------------------------------------------------------- | ------------------------------------------------------- |
| 01 | Installing WSL and Ubuntu 24.04                                     | WSL and Ubuntu installation                             |
| 02 | Setting up Docker Desktop with WSL2                                 | Docker Desktop configuration                            |
| 03 | Understanding Dev Containers                                        | Dev Container core concepts                             |
| 04 | Creating a Dev Container Project                                    | Full project build process                              |
| 05 | Authenticating with GitHub inside Dev Containers                    | Secure GitHub authentication                            |
| 06 | Customizing with Dotfiles and VS Code Settings                      | Personalizing the container environment                 |
| 07 | Making Your Environment Portable                                    | Portability, reproducibility, and GitHub-first workflow |
| 08 | Dev Container Approaches: Features vs Dockerfile vs Prebuilt Images | Dev Container strategies comparison                     |
| 09 | Templates and Starters                                              | Ready-to-use project scaffolding                        |
| 10 | Troubleshooting Dev Containers                                      | Problem-solving and diagnostics                         |

---

## Security Considerations

* Personal Access Tokens must **never** be committed to version control.
* `.devcontainer/.env` must always be listed in `.gitignore`.
* The project uses `runArgs` to securely inject environment variables.

---

## Recommended Tooling

| Tool           | Purpose                        |
| -------------- | ------------------------------ |
| Docker Desktop | Container runtime              |
| VS Code        | Container interface and editor |
| WSL2           | Linux compatibility layer      |
| GitHub CLI     | Secure GitHub authentication   |

---

## Best Practices

* Always use the pre-configured `vscode` user.
* Prefer feature-based configurations over complex Dockerfiles.
* Avoid creating new users inside the container.
* Keep `.devcontainer/.env` protected and excluded.
* Document project-specific dependencies in `README.md`.

---

## License

This project is provided under the **MIT License**.
