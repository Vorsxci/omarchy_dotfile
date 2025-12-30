#!/bin/bash

REPO_PATH="$HOME/omarchy_dotfile/"
CONFIG_DIR="$HOME/.config/"

# Check for required package
if ! command -v stow >/dev/null 2>&1; then
  echo "Stow could not be found"
  exit 1
fi

# 1) cd into REPO_PATH
if ! cd "$REPO_PATH"; then
  echo "Repo path does not exist: $REPO_PATH"
  exit 1
fi

# 2) Iterate all directory names in REPO_PATH
for name in */ ; do
  name="${name%/}" # strip trailing slash

  # Skip if not a directory (paranoia) or if glob didn't match
  [ -d "$name" ] || continue

  # 3) Check for matching directory name in CONFIG_DIR
  target="${CONFIG_DIR}${name}"
  if [ -d "$target" ]; then
    # Ensure .bak siblings exist for every file Stow will manage
    while IFS= read -r -d '' src; do
      rel="${src#"$name"/}"     # path relative to package
      dest="$target/$rel"       # corresponding path in target
      bak="$dest.bak"

      # Only back up if the destination exists (file or symlink)
      [ -e "$dest" ] || continue

      # If .bak doesn't exist OR it's a symlink, (re)create it as a REAL FILE backup
      if [ ! -e "$bak" ] || [ -L "$bak" ]; then
        # Resolve what we should copy from:
        # - if dest is a symlink, resolve to the real file path
        # - if dest is a regular file, use it directly
        if [ -L "$dest" ]; then
          resolved="$(readlink -f -- "$dest" 2>/dev/null || true)"
          copy_from="$resolved"
        else
          copy_from="$dest"
        fi

        # Only back up regular files (the repo scan is files/symlinks, so this matches intent)
        if [ -n "$copy_from" ] && [ -f "$copy_from" ]; then
          # Remove any existing .bak (especially if it's a symlink), then copy real contents
          rm -f -- "$bak"
          cp -a -- "$copy_from" "$bak"
          echo "Backed up: $dest -> $bak"
        fi
      fi
    done < <(find "$name" -mindepth 1 \( -type f -o -type l \) -print0)

    # 4) stow with ONLY target (-t). Package is the dir name (relative to REPO_PATH)
    echo "Symlinked files in $target/ ⟶ $name in repo"
    stow --adopt -t "$target" "$name"
  else
    echo "Skipping $name (no matching $target)"
  fi
done

echo "Done."


