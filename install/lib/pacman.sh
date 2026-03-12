#!/usr/bin/env bash
# pacman.sh — funciones para instalación de paquetes con pacman

pacman_install_list() {
  local list_file="$1"

  [[ -f "$list_file" ]] || die "Lista de paquetes no encontrada: $list_file"

  mapfile -t packages < <(
    grep -v '^\s*#' "$list_file" | grep -v '^\s*$'
  )

  ((${#packages[@]} > 0)) || { warn "La lista de paquetes está vacía: $list_file"; return 0; }

  # Filtrar paquetes que ya están instalados y actualizados
  local to_install=()
  for pkg in "${packages[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
      : # ya instalado, omitir
    else
      to_install+=("$pkg")
    fi
  done

  local already=$(( ${#packages[@]} - ${#to_install[@]} ))
  (( already > 0 )) && info "$already packages already installed, skipping."

  if (( ${#to_install[@]} == 0 )); then
    ok "All pacman packages already installed."
    return 0
  fi

  local total="${#to_install[@]}"
  local log_file
  log_file="$(mktemp /tmp/dotfiles-pacman-XXXXXX.log)"

  info "Installing $total packages via pacman..."

  local i
  for (( i = 0; i < total; i++ )); do
    local pkg="${to_install[$i]}"
    info "[$(( i + 1 ))/$total] $pkg"

    if ! sudo pacman -S --needed --noconfirm "$pkg" >> "$log_file" 2>&1; then
      printf "ERR:  failed to install: %s\n" "$pkg"
      printf "ERR:  log: %s\n" "$log_file"
      die "Error al instalar paquete pacman: $pkg"
    fi
  done

  rm -f "$log_file"
  ok "All pacman packages installed."
}
