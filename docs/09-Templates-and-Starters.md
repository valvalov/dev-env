# 09 – Templates and Starters

## Overview

This document provides reusable templates and starter configurations to accelerate the setup of new Dev Container projects. Templates are aligned with the Microsoft Dev Container ecosystem and follow the established best practices for user management, environment configuration, and workspace portability.

---

## Template 1: Feature-Based Dev Container (Recommended)

### Folder Structure

```text
my-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── .env
│   └── setup.sh
├── README.md
└── (project files)
```

### `devcontainer.json`

```json
{
  "name": "Feature-Based Dev Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "remoteUser": "vscode",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/common-utils:1": {}
  },
  "runArgs": [
    "--env-file", ".devcontainer/.env"
  ],
  "postCreateCommand": "bash .devcontainer/setup.sh",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-azuretools.vscode-docker",
        "github.vscode-pull-request-github"
      ]
    }
  }
}
```

### `setup.sh`

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

Make the script executable:

```bash
chmod +x .devcontainer/setup.sh
```

### Advantages

* Fast to build and rebuild
* Fully compatible with Microsoft tooling
* Uses prebuilt `vscode` user with correct UID alignment

---

## Template 2: Prebuilt Image Dev Container

### Folder Structure

```text
my-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── .env
│   └── setup.sh
├── README.md
└── (project files)
```

### `devcontainer.json`

```json
{
  "name": "Prebuilt Image Dev Container",
  "image": "ghcr.io/your-org/your-prebuilt-image",
  "remoteUser": "vscode",
  "runArgs": [
    "--env-file", ".devcontainer/.env"
  ],
  "postCreateCommand": "bash .devcontainer/setup.sh",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-azuretools.vscode-docker",
        "github.vscode-pull-request-github"
      ]
    }
  }
}
```

### Advantages

* Fastest startup time
* Suitable for centralized team-managed images

---

## Notes on Deprecated Dockerfile Templates

Previous versions of this documentation provided Dockerfile templates with custom user creation. This practice is no longer recommended.

### Key Reason

* Microsoft Dev Container base images already include the `vscode` user with UID 1000, which matches the typical host user UID in WSL2 setups.
* Creating additional users can cause UID conflicts.

### Updated Best Practice

* Use Microsoft base images directly.
* Do not create additional users.
* Always use the existing `vscode` user by specifying:

```json
"remoteUser": "vscode"
```

---

## Summary

| Template                    | Recommended For                      |
| --------------------------- | ------------------------------------ |
| Feature-Based Dev Container | Most projects, fast builds           |
| Prebuilt Image              | Enterprise teams, centralized builds |

Feature-based Dev Containers are the preferred method for modern development environments, providing flexibility, simplicity, and full compatibility with VS Code and Docker Desktop.
