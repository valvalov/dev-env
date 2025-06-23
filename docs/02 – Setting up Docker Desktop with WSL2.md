# 02 – Setting up Docker Desktop with WSL2

## Overview

This guide explains how to install Docker Desktop and configure it to work with WSL2 on Windows 11. Docker Desktop is required to build and run Dev Containers.

---

## Installing Docker Desktop

Download Docker Desktop for Windows from the official website:

[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

Follow the installation instructions and complete the setup.

---

## Enabling WSL2 Integration

Open Docker Desktop and navigate to:

**Settings → Resources → WSL Integration**

Ensure the following are enabled:

* Enable integration with my default WSL distro
* Ubuntu-24.04 (or your installed WSL distribution)

Apply the changes.

---

## Verifying Docker Installation

Open your WSL terminal and run:

```bash
docker --version
docker info
```

You should see Docker running and correctly integrated with WSL2.

Test with:

```bash
docker run hello-world
```

This should confirm that Docker is working properly.

---

## User ID (UID) and File Ownership Considerations

When using Docker Desktop with WSL2, files bind-mounted into Dev Containers retain the UID of the host user.

**Important:** Docker manages file ownership strictly by numeric UID, not by username.

* The default WSL user typically has UID 1000.
* Microsoft Dev Container base images use the `vscode` user with UID 1000 to ensure proper file ownership alignment.

### Best Practice

* Always set the following in `devcontainer.json`:

```json
"remoteUser": "vscode"
```

* Never create additional users with UID 1000 inside the container.

---

## Summary

Docker Desktop is now installed and properly integrated with WSL2. You are ready to create and build Dev Containers with consistent user ID alignment and workspace permissions.
