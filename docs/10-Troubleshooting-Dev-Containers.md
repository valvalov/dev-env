# 10 – Troubleshooting Dev Containers

## Overview

This guide provides a structured approach to diagnosing and resolving common issues encountered when working with Dev Containers in Visual Studio Code.

---

## Common Issues and Resolutions

### 1. File Permission Problems

**Symptoms:**

* Cannot create, modify, or delete files in the workspace.

**Cause:**

* UID mismatches between the container user and the bind-mounted workspace files.

**Resolution:**

* Always use Microsoft Dev Container base images, which include the `vscode` user with UID 1000.
* In `devcontainer.json`:

```json
"remoteUser": "vscode"
```

* Align container user and host user UIDs to maintain permission consistency.

---

### 2. GitHub Authentication Failures

**Symptoms:**

* Git operations fail due to missing authentication.
* GitHub CLI is not recognized or not authenticated.

**Resolution:**

* Ensure the `.env` file is correctly configured with `GITHUB_PAT`, `GITHUB_USER`, and `GIT_EMAIL`.
* Use `runArgs` in `devcontainer.json` to pass the `.env` file into the container.
* Ensure the provisioning script (`setup.sh`) correctly configures Git and authenticates the GitHub CLI.
* Run `gh auth status` inside the container to validate authentication.

---

### 3. Container Build Failures

**Symptoms:**

* Dev Container fails to build or start.

**Resolution:**

* Ensure `Dockerfile` is correctly located inside `.devcontainer` if referenced directly.
* Use Microsoft Dev Container base images to minimize configuration overhead.
* Always validate `devcontainer.json` structure and paths.
* Rebuild with cache cleared:

```bash
F1 → Dev Containers: Rebuild Container Without Cache
```

---

### 4. Environment Variables Not Injected

**Symptoms:**

* Provisioning scripts do not receive expected variables.

**Resolution:**

* Confirm `--env-file` is properly configured in `devcontainer.json`.
* Validate the correct path to the `.env` file.
* Ensure no syntax errors (e.g., spaces around `=`) in the `.env` file.
* Validate that the `.env` file is excluded in `.gitignore`.

---

### 5. Workspace Not Recognized Properly

**Symptoms:**

* VS Code fails to mount the workspace correctly.

**Resolution:**

* Confirm that the workspace is mounted at `/workspaces/<project-name>`.
* Ensure project files are placed correctly relative to `.devcontainer`.
* Use absolute paths in `postCreateCommand` to avoid path resolution errors.

---

### 6. Feature Installation Failures

**Symptoms:**

* Dev Container Features fail to install or configure.

**Resolution:**

* Validate internet connectivity to GitHub container registries.
* Confirm the correct syntax in the `features` block of `devcontainer.json`.
* Rebuild without cache to ensure fresh feature resolution.

---

## Diagnostic Checklist

| Checkpoint                           | Status |
| ------------------------------------ | ------ |
| `.env` file correctly formatted      |        |
| `remoteUser` set to `vscode`         |        |
| Correct Docker base image used       |        |
| Features properly defined            |        |
| GitHub CLI properly authenticated    |        |
| Workspace mounted at `/workspaces`   |        |
| Setup script has correct permissions |        |

---

## Summary

Troubleshooting Dev Containers requires careful attention to workspace mounting, user permissions, environment variable injection, and feature configuration. By consistently using Microsoft Dev Container base images and the `vscode` user, most issues related to file permissions and authentication can be proactively avoided.
