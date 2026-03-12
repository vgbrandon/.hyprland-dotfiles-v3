#!/usr/bin/env bash
# aur.sh — funciones para selección e instalación de paquetes AUR

_install_aur_helper() {
  local helper="$1"
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local log_file
  log_file="$(mktemp /tmp/dotfiles-aur-helper-XXXXXX.log)"

  info "Cloning $helper from AUR..."
  git clone "https://aur.archlinux.org/${helper}.git" "$tmp_dir/$helper" \
    || {
      printf "ERR:  could not clone %s from AUR\n" "$helper"
      printf "ERR:  log: %s\n" "$log_file"
      die "No se pudo clonar $helper desde AUR."
    }

  info "Building $helper..."
  bash -c "cd '$tmp_dir/$helper' && makepkg -si --noconfirm >> '$log_file' 2>&1" \
    || {
      printf "ERR:  failed to build %s\n" "$helper"
      printf "ERR:  log: %s\n" "$log_file"
      die "Error al compilar/instalar $helper."
    }

  rm -rf "$tmp_dir"
  rm -f "$log_file"
}

aur_select_helper() {
  local -a opts=("paru" "yay" "other")

  ui_menu "Select AUR helper" opts
  local chosen="${opts[$UI_MENU_RESULT]}"

  if [[ "$chosen" == "other" ]]; then
    while true; do
      read -r -p "  Helper name: " chosen
      chosen="$(printf '%s' "$chosen" | tr -d '[:space:]')"

      if [[ -z "$chosen" ]]; then
        printf "  No name entered.\n"
        continue
      fi

      if ! curl -sf "https://aur.archlinux.org/rpc/v5/info?arg=${chosen}" \
          | grep -q '"resultcount":1'; then
        printf "  '%s' not found in AUR.\n" "$chosen"
        continue
      fi

      break
    done
  fi

  if command -v "$chosen" >/dev/null 2>&1; then
    info "$chosen is already installed."
  else
    _install_aur_helper "$chosen"
  fi

  AUR_HELPER="$chosen"
}

aur_install_list() {
  local list_file="$1"

  [[ -n "${AUR_HELPER:-}" ]] || die "AUR_HELPER no está definido."
  [[ -f "$list_file" ]] || die "Lista AUR no encontrada: $list_file"

  mapfile -t packages < <(
    grep -v '^\s*#' "$list_file" | grep -v '^\s*$'
  )

  ((${#packages[@]} > 0)) || { warn "La lista AUR está vacía: $list_file"; return 0; }

  # Filtrar paquetes que ya están instalados
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
    ok "All AUR packages already installed."
    return 0
  fi

  local total="${#to_install[@]}"
  local log_file
  log_file="$(mktemp /tmp/dotfiles-aur-XXXXXX.log)"

  info "Installing $total packages via $AUR_HELPER..."

  local i
  for (( i = 0; i < total; i++ )); do
    local pkg="${to_install[$i]}"
    info "[$(( i + 1 ))/$total] $pkg"

    if ! "$AUR_HELPER" -S --needed --noconfirm "$pkg" >> "$log_file" 2>&1; then
      printf "ERR:  failed to install: %s\n" "$pkg"
      printf "ERR:  log: %s\n" "$log_file"
      die "Error al instalar paquete AUR: $pkg"
    fi
  done

  rm -f "$log_file"
  ok "All AUR packages installed."
}
