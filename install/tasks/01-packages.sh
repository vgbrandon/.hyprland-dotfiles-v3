#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
LIB_DIR="$REPO_ROOT/install/lib"
LISTS_DIR="$REPO_ROOT/install/lists"

log()  { printf "%s\n" "$*"; }
info() { log "INFO: $*"; }
ok()   { log "OK:   $*"; }
warn() { log "WARN: $*"; }
die()  { log "ERR:  $*"; exit 1; }

# shellcheck source=../lib/ui.sh
source "$LIB_DIR/ui.sh"
# shellcheck source=../lib/pacman.sh
source "$LIB_DIR/pacman.sh"
# shellcheck source=../lib/aur.sh
source "$LIB_DIR/aur.sh"

main() {
  info "Checking sudo credentials..."
  sudo -v || die "sudo credentials failed."

  info "Updating system..."
  sudo pacman -Syu --noconfirm || die "No se pudo actualizar el sistema."

  pacman_install_list "$LISTS_DIR/pacman.txt"

  aur_select_helper

  aur_install_list "$LISTS_DIR/aur.txt"
}

main "$@"
