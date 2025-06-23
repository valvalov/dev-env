# 03 – Understanding Dev Containers

## Overview

Dev Containers enable fully isolated, reproducible development environments using container technology. They integrate seamlessly with Visual Studio Code and Docker Desktop, allowing each project to define its own tooling, dependencies, and runtime configuration.

---

## What Are Dev Containers?

A Dev Container is a Docker container specifically designed for development workflows. It allows you to:

* Use consistent development environments across machines
* Avoid "it works on my machine" issues
* Package dependencies, compilers, and runtime tools per project

---

## Key Components

| Component         | Purpose                                            |
| ----------------- | -------------------------------------------------- |
| Dockerfile        | Defines the base image and installed tools         |
| devcontainer.json | Configures the Dev Container and VS Code           |
| Features          | Adds modular capabilities to containers            |
| Setup scripts     | Provision user-specific configurations             |
| .env files        | Inject sensitive or environment-specific variables |

---

## Workspace Mounting and User Management

When using Docker with bind-mounted workspaces, file ownership is managed by UID, not by username. This is critical for ensuring proper file permissions inside the container.

In Microsoft Dev Container base images, the `vscode` user is pre-configured with UID 1000, which typically matches the host user UID in WSL2 setups. This alignment ensures that files created inside the container are fully accessible from the host system.

### Best Practice

* Always use the pre-configured `vscode` user in `devcontainer.json`:

```json
"remoteUser": "vscode"
```

* Do not create additional users with UID 1000. Doing so may cause UID conflicts.

The Microsoft Dev Container strategy relies on using the `vscode` user to maintain correct UID alignment and permission consistency.

---

## Supported Base Images

Microsoft provides a library of prebuilt base images that integrate seamlessly with VS Code:

* `mcr.microsoft.com/devcontainers/base:ubuntu`
* `mcr.microsoft.com/devcontainers/base:debian`
* `mcr.microsoft.com/devcontainers/base:alpine`

These images include the `vscode` user and are fully compatible with Dev Container Features.

---

## Benefits of Dev Containers

* Consistent development environments across teams
* Full control over installed software versions
* Secure injection of tokens and secrets via environment variables
* Easy onboarding for new developers
* Seamless integration with Docker Desktop and WSL2 on Windows 11

---

## Integration with Visual Studio Code

VS Code uses the Dev Containers extension to:

* Detect `.devcontainer/devcontainer.json`
* Build and launch the container
* Attach the workspace to the container
* Apply user-specific VS Code customizations

VS Code mounts the project folder into the container workspace at `/workspaces/<project-name>`, ensuring continuity across the host and the container.

---

## Feature Support

Dev Container Features are modular add-ons that can:

* Install specific development tools (Node.js, Python, Go)
* Enable GitHub CLI, SSH agents, AWS CLI
* Add debugging tools and language servers

Example configuration in `devcontainer.json`:

```json
"features": {
  "ghcr.io/devcontainers/features/github-cli:1": {},
  "ghcr.io/devcontainers/features/common-utils:1": {}
}
```

Features are resolved and installed automatically during container build.

---

## Summary

Dev Containers provide a reliable, isolated, and fully portable development workflow. By using Microsoft base images and adhering to user management best practices, you can avoid permission issues, achieve rapid onboarding, and maintain reproducible project setups.
