#!/bash/sh

#!/usr/bin/env bash
set -euo pipefail

# =========================
# Omarchy install script
# - Installs required packages (Arch/pacman)
# - Runs post-install scripts
# =========================

# ---- Packages to ensure are installed ----
PACKAGES=(
  swaync
  stow
  mpv
  mpvpaper
  fcitx5-qt
  fcitx5-mozc
  fcitx5-gtk
  fcitx5-configtool
  fcitx5
  inxi
  imagemagick
  sof
  sof-firmware
  ttf-cascadia-code-nerd
  ttf-zen-maru-gothic
  zotero
  alsa-utils
  downgrade


  # add more here...
  # wl-clip-persist (example)
)

# ---- Scripts to run after packages install ----
# Use absolute paths (recommended)
SCRIPTS=(
  "./dotfile-update-from-git.sh"
  # add more here...
)

log() { printf "\n\033[1m==>\033[0m %s\n" "$*"; }
die() { printf "\n\033[31mERROR:\033[0m %s\n" "$*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

# ---- Preflight ----
need_cmd pacman
need_cmd sudo

# ---- Install packages (only missing ones) ----
log "Checking packages…"
missing=()
for pkg in "${PACKAGES[@]}"; do
  if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
    missing+=("$pkg")
  fi
done

if ((${#missing[@]} > 0)); then
  log "Installing missing packages: ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
else
  log "All packages already installed."
fi

# ---- Run scripts ----
log "Running post-install scripts…"
for s in "${SCRIPTS[@]}"; do
  if [[ ! -e "$s" ]]; then
    die "Script not found: $s"
  fi
  if [[ ! -x "$s" ]]; then
    log "Making script executable: $s"
    chmod +x "$s"
  fi

  log "Running: $s"
  "$s"
done

log "Done."

