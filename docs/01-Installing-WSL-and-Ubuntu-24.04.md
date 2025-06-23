# 01 – Installing WSL and Ubuntu 24.04

## Overview

This guide explains how to install Windows Subsystem for Linux (WSL) and configure Ubuntu 24.04 as a development environment. It provides step-by-step instructions for setting up the base system required for Dev Containers.

---

## Installing WSL

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

Reboot if prompted.

Ensure WSL version 2 is set as default:

```powershell
wsl --set-default-version 2
```

---

## Installing Ubuntu 24.04

From the Microsoft Store, search for "Ubuntu 24.04" and install it.

After installation, launch Ubuntu 24.04 and create a new user when prompted.

Example:

```text
Enter new UNIX username: horvin
New password: ********
```

---

## Updating Ubuntu

Once Ubuntu is installed, update the system:

```bash
sudo apt update && sudo apt upgrade -y
```

---

## Installing Basic Tools

Install essential packages:

```bash
sudo apt install -y build-essential curl git unzip bash-completion
```

---

## User ID (UID) Fundamentals in WSL2

In WSL2, the default Linux user typically has UID 1000.

When using Docker Desktop, files bind-mounted into Dev Containers retain their original UID from the host system.

**Important:** Docker manages file ownership by numeric UID, not by username.

This means:

* The container user must have UID 1000 to properly access bind-mounted files created by the host user.
* Microsoft Dev Container base images provide the `vscode` user with UID 1000 specifically to align with this requirement.

> Always use the `vscode` user in Dev Containers to ensure permission consistency.

---

## Summary

You now have WSL2 and Ubuntu 24.04 configured and ready for Dev Container development. The next step is to install Docker Desktop and set up WSL2 integration.
