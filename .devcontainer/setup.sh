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
