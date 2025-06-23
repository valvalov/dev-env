# 06 – Customizing with Dotfiles and VS Code Settings

## Overview

Dev Containers support full user customization through dotfiles and VS Code-specific settings. These customizations are applied automatically when the container is built, enabling developers to maintain consistent environments across machines.

---

## Dotfiles Customization

### What Are Dotfiles?

Dotfiles are configuration files (such as `.bashrc`, `.gitconfig`, `.vimrc`) that define user-specific settings and behaviors for terminal environments, Git, and various CLI tools.

---

## Configuring Dotfiles in Dev Containers

You can configure VS Code to clone a public dotfiles repository automatically when building a Dev Container.

### Example Configuration in `devcontainer.json`

```json
"customizations": {
  "vscode": {
    "settings": {
      "dotfiles.repository": "https://github.com/your-user/your-dotfiles",
      "dotfiles.installCommand": "./install.sh",
      "dotfiles.targetPath": "~/.dotfiles"
    },
    "extensions": [
      "ms-azuretools.vscode-docker",
      "github.vscode-pull-request-github"
    ]
  }
}
```

---

### Notes

* The dotfiles repository must be **public**.
* The installation script must be executable and idempotent.
* The dotfiles will be applied to the `vscode` user, which is the default user in Microsoft Dev Container base images.

The Microsoft Dev Container strategy relies on using the `vscode` user to maintain correct UID alignment and permission consistency.

---

## Customizing VS Code Settings

You can pre-configure VS Code settings directly in `devcontainer.json`.

### Example

```json
"customizations": {
  "vscode": {
    "settings": {
      "terminal.integrated.defaultProfile.linux": "bash",
      "editor.tabSize": 4,
      "files.autoSave": "onWindowChange"
    },
    "extensions": [
      "ms-azuretools.vscode-docker",
      "github.vscode-pull-request-github"
    ]
  }
}
```

These settings will be automatically applied inside the container when opened in VS Code.

---

## Best Practices

* Use the Microsoft base image with the `vscode` user to ensure compatibility.
* Ensure dotfiles are public to allow automated cloning.
* Keep dotfiles installation scripts simple, repeatable, and non-destructive.
* Pre-install essential VS Code extensions via `customizations` for consistent tooling.
* Use `runArgs` to inject environment variables as needed.

---

## Summary

Dotfiles and VS Code settings can be fully integrated into the Dev Container workflow, providing developers with a consistent, portable, and personalized environment. Microsoft Dev Containers are optimized to apply dotfiles to the pre-configured `vscode` user, ensuring seamless compatibility across systems.
