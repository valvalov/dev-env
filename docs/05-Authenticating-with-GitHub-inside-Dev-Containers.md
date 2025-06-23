# 05 – Authenticating with GitHub Inside Dev Containers

## Overview

This guide explains how to configure GitHub authentication inside Dev Containers using secure environment variables and the GitHub CLI. The approach ensures that personal access tokens (PATs) are safely injected into the container without being committed to version control.

---

## Why Use Environment Variables?

* Environment variables allow you to pass sensitive data such as GitHub Personal Access Tokens (PATs) into the container securely.
* They prevent accidental exposure of credentials in version control.
* The `.env` file containing secrets is excluded via `.gitignore`.

---

## Creating the `.env` File

Inside `.devcontainer/`, create a file named `.env` with the following format:

```env
GITHUB_PAT=ghp_yourtokenhere
GITHUB_USER=your-github-username
GIT_EMAIL=your@email.com
```

> Notes:
>
> * Do not include spaces around `=`.
> * Use LF (Unix) line endings.
> * Never commit this file to version control.

---

## Configuring `devcontainer.json`

Add `runArgs` to inject the `.env` file into the container:

```json
"runArgs": [
  "--env-file", ".devcontainer/.env"
]
```

Set the appropriate user:

```json
"remoteUser": "vscode"
```

This ensures the container uses the Microsoft-provided `vscode` user with correct UID alignment.

---

## Using GitHub CLI for Authentication

The recommended way to authenticate is via the GitHub CLI (`gh`), which can be automatically provisioned using the following Dev Container Feature:

```json
"features": {
  "ghcr.io/devcontainers/features/github-cli:1": {}
}
```

The GitHub CLI will respect the provided PAT when configured via the `setup.sh` provisioning script.

---

## Example `setup.sh`

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

## Validating Authentication

Inside the container, run:

```bash
gh auth status
```

You should see confirmation that you are logged into GitHub as the expected user.

Validate Git identity:

```bash
git config --get user.name
git config --get user.email
```

---

## Best Practices

* Always use the `vscode` user provided by Microsoft base images.
* Inject secrets using the `--env-file` option.
* Do not hard-code tokens into scripts or configuration files.
* Protect `.devcontainer/.env` by adding it to `.gitignore`.

---

## Summary

GitHub authentication inside Dev Containers should always be handled securely via environment variables and the GitHub CLI. Using the Microsoft base image with the `vscode` user ensures seamless integration, correct UID alignment, and proper file permissions.
