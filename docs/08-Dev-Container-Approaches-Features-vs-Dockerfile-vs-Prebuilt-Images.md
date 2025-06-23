# 08 – Dev Container Approaches: Features vs Dockerfile vs Prebuilt Images

## Overview

There are multiple strategies for building Dev Containers in Visual Studio Code. Each approach offers trade-offs in terms of complexity, flexibility, and portability. This guide explains the three primary approaches:

* Feature-based
* Dockerfile-based
* Prebuilt image-based

---

## 1. Feature-Based Approach

### Description

This is the recommended starting point. Microsoft provides a library of Dev Container Features that add specific capabilities to a container image without writing a Dockerfile.

### Key Characteristics

* Uses standard Microsoft Dev Container base images.
* Configuration is done entirely through `devcontainer.json`.
* No custom image building required.

### Example `devcontainer.json`

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

### Advantages

* Simple and portable
* Fast to build and rebuild
* Fully supported by Microsoft tooling
* Secure default configurations

---

## 2. Dockerfile-Based Approach

### Description

This approach provides more control over the container’s environment by allowing you to write a custom Dockerfile. This is useful if you need specific packages, versions, or system libraries.

### Key Characteristics

* Builds a custom image starting from a base image
* Requires explicit Dockerfile maintenance
* Supports adding Microsoft Features

### Example `devcontainer.json`

```json
{
  "name": "Dockerfile-Based Dev Container",
  "build": {
    "dockerfile": "Dockerfile"
  },
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

### Example `Dockerfile`

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

### Advantages

* Full control over the container environment
* Custom software installation supported

### Considerations

* Must align with Microsoft best practices
* Should use existing `vscode` user provided by the base image
* User management is unnecessary and may cause UID conflicts

---

## 3. Prebuilt Image Approach

### Description

This method uses a fully prebuilt container image, either created by your organization or provided by a third party.

### Key Characteristics

* Fastest build time (no build steps)
* Fully encapsulated image
* May have limited flexibility

### Example `devcontainer.json`

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

* Fastest startup
* Centralized image maintenance for teams

### Considerations

* Less customizable by end users
* Image updates require external build process

---

## Summary Comparison

| Approach         | Complexity | Flexibility | Portability | Build Time |
| ---------------- | ---------- | ----------- | ----------- | ---------- |
| Feature-Based    | Low        | Medium      | High        | Fast       |
| Dockerfile-Based | Medium     | High        | High        | Moderate   |
| Prebuilt Image   | Low        | Low         | High        | Fastest    |

---

## Recommendations

* Start with the **Feature-Based** approach unless you need complex customizations.
* Use the **Dockerfile-Based** approach if you require special packages or system libraries.
* Consider the **Prebuilt Image** approach for large teams with standardized images.

---

## Best Practices

* Always use the Microsoft `vscode` user provided by the base image.
* Do not create additional users with UID 1000 to avoid UID conflicts.
* Ensure that `.env` files are never committed to version control.
* Use `runArgs` to inject sensitive environment variables.

Microsoft Dev Container strategy is based on using the `vscode` user with UID 1000 to ensure seamless permission alignment between host and container.
