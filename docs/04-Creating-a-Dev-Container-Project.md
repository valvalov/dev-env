# 04 – Creating a Dev Container Project

## Overview

This guide provides a step-by-step process to create your first Dev Container project using Visual Studio Code and Docker. It covers directory structure, base image selection, environment provisioning, and GitHub authentication via environment variables.

The project follows the **feature-based strategy** with a Microsoft Dev Container base image, which is fully compatible with VS Code and Docker Desktop. It uses the pre-configured `vscode` user provided by the base image.

---

## Step 1: Create a New Project Directory

In your WSL terminal:

```bash
mkdir -p ~/projects/dev-env
cd ~/projects/dev-env
```

---

## Step 2: Add the `.devcontainer` Directory

Inside the project root, create:

```bash
mkdir .devcontainer
```

Add the following files:

* `.devcontainer/devcontainer.json`
* `.devcontainer/.env`
* `.devcontainer/setup.sh`

> Note: The `setup.sh` file must be located inside the `.devcontainer` directory.

---

## Step 3: Create the `.env` File

At `.devcontainer/.env`, define:

```env
GITHUB_PAT=ghp_yourtokenhere
GITHUB_USER=your-github-username
GIT_EMAIL=your@email.com
```

> Ensure there are no spaces around `=` and use Unix line endings. Add `.devcontainer/.env` to `.gitignore`.

---

## Step 4: Write `devcontainer.json`

```json
{
  "name": "Ubuntu Dev Container",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "remoteUser": "vscode",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:1": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
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

---

## Step 5: Define `Dockerfile`

```Dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        unzip \
        build-essential && \
    rm -rf /var/lib/apt/lists/*
```

> The Microsoft base image already includes the `vscode` user with UID 1000. No additional user creation is required.

---

## Step 6: Add `setup.sh`

In the `.devcontainer` directory:

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

---

## Step 7: Open in VS Code and Build

From the project root:

```bash
code .
```

When prompted:

* Click **Reopen in Container**
* Or run:

  > F1 → Dev Containers: Rebuild Container Without Cache

---

## Step 8: Validate the Environment

Inside the Dev Container, execute:

```bash
echo $GITHUB_USER
gh auth status
git config --get user.name
whoami
```

Expected results:

* GitHub token is active
* Git identity is correctly configured
* You are logged in as `vscode`

---

## Notes

* The Microsoft Dev Container base image fully supports VS Code integration and includes common development tools.
* No user management is required. The `vscode` user with UID 1000 is provided by default.
* Ensure `.devcontainer/.env` is properly excluded from version control.

---

## Next Steps

* Proceed to [05 – Authenticating with GitHub Inside Dev Containers](./05%20%E2%80%93%20Authenticating%20with%20GitHub%20Inside%20Dev%20Containers.md) to configure secure GitHub access.
* Explore [09 – Templates and Starters](./09%20–%20Templates%20and%20Starters.md) to scaffold new environments.
* For an overview of container strategies, see [08 – Dev Container Approaches](./08%20–%20Dev%20Container%20Approaches%20Features%20vs%20Dockerfile%20vs%20Prebuilt%20Images.md).
