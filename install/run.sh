#!/usr/bin/env bash
set -Eeuo pipefail

# run.sh vive en install/, así que repo root es ../
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="$REPO_ROOT/install"
TASKS_DIR="$INSTALL_DIR/tasks"

# -----------------------------
# Logging
# -----------------------------
log()  { printf "%s\n" "$*"; }
info() { log "INFO: $*"; }
ok()   { log "OK:   $*"; }
die()  { log "ERR:  $*"; exit 1; }

# -----------------------------
# Bienvenida
# -----------------------------
# shellcheck source=lib/ui.sh
source "$INSTALL_DIR/lib/ui.sh"
show_welcome

# -----------------------------
# Task runner
# -----------------------------
run_task() {
  local task="$1"
  [[ -f "$task" ]] || die "Task no encontrado: $task"
  [[ -x "$task" ]] || die "Task sin permisos de ejecución: $task"
  info "Ejecutando: ${task#$REPO_ROOT/}"
  REPO_ROOT="$REPO_ROOT" bash "$task"
  ok "Completado: ${task#$REPO_ROOT/}"
}

# -----------------------------
# Descubrir y ejecutar tasks
# -----------------------------
# TODO: se pueden añadir flags en el futuro (ej. --only-stow, --only-packages, --modules)

[[ -d "$TASKS_DIR" ]] || die "Directorio de tasks no encontrado: $TASKS_DIR"

mapfile -t TASKS < <(
  find "$TASKS_DIR" -maxdepth 1 -type f -name '*.sh' -printf '%p\n' | sort
)

((${#TASKS[@]} > 0)) || die "No se encontraron tasks en: $TASKS_DIR"

for t in "${TASKS[@]}"; do
  run_task "$t"
done
