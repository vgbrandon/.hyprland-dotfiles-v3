#!/usr/bin/env bash
# ui.sh — bienvenida e input de usuario

show_welcome() {
  cat <<'EOF'

  --------------------------------
  dotfiles // hyprland installer
  --------------------------------

EOF
  read -r -p "  Press Enter to start, Ctrl+C to exit... "
  printf "\n"
}

# Menú de selección simple numerado
# Uso: ui_menu "título" OPCIONES_ARRAY
# Retorna el índice en UI_MENU_RESULT
ui_menu() {
  local title="$1"
  shift
  local -n _opts="$1"

  while true; do
    printf "\n  %s\n\n" "$title"
    local i
    for i in "${!_opts[@]}"; do
      printf "  %d) %s\n" "$(( i + 1 ))" "${_opts[$i]}"
    done
    printf "\n"

    local choice
    read -r -p "  Choose [1-${#_opts[@]}]: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] \
        && (( choice >= 1 && choice <= ${#_opts[@]} )); then
      UI_MENU_RESULT=$(( choice - 1 ))
      return 0
    fi

    printf "  Invalid choice.\n"
  done
}
