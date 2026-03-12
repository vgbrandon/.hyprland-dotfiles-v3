#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
LIB_DIR="$REPO_ROOT/install/lib"

log()  { printf "%s\n" "$*"; }
info() { log "INFO: $*"; }
ok()   { log "OK:   $*"; }
warn() { log "WARN: $*"; }
die()  { log "ERR:  $*"; exit 1; }

# shellcheck source=../lib/ui.sh
source "$LIB_DIR/ui.sh"

FISH_BIN="/usr/bin/fish"

check_fish() {
  if ! command -v fish >/dev/null 2>&1; then
    die "fish no está instalado."
  fi
  ok "fish encontrado: $(fish --version 2>&1)"
}

add_fish_to_shells() {
  if grep -qxF "$FISH_BIN" /etc/shells; then
    ok "fish ya está en /etc/shells."
    return 0
  fi

  info "Agregando $FISH_BIN a /etc/shells..."
  echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
  ok "fish agregado a /etc/shells."
}

set_default_shell() {
  local current_shell
  current_shell="$(getent passwd "$USER" | cut -d: -f7)"

  if [[ "$current_shell" == "$FISH_BIN" ]]; then
    ok "fish ya es el shell por defecto para $USER."
    return 0
  fi

  info "Cambiando shell por defecto de $USER a fish..."
  chsh -s "$FISH_BIN" || die "No se pudo cambiar el shell. Intenta manualmente: chsh -s $FISH_BIN"
  ok "Shell por defecto cambiado a fish. Efectivo en la próxima sesión."
}

main() {
  info "Configurando fish como shell por defecto..."

  check_fish
  add_fish_to_shells
  set_default_shell

  ok "Migración a fish completada."
}

main "$@"
