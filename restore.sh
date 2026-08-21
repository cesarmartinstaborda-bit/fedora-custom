#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/fedora-custom-before-restore-$STAMP"

echo
echo "Fedora Custom Restore"
echo "Origem: $ROOT"
echo "Backup: $BACKUP"
echo

if [[ ! -f /etc/fedora-release ]]; then
    echo "ERRO: este restaurador foi preparado para Fedora."
    exit 1
fi

echo "Sistema detectado:"
cat /etc/fedora-release

if command -v gnome-shell >/dev/null 2>&1; then
    gnome-shell --version
else
    echo "ERRO: GNOME Shell não encontrado."
    exit 1
fi

echo
echo "Criando backup do estado atual..."

mkdir -p \
    "$BACKUP/dconf" \
    "$BACKUP/config" \
    "$BACKUP/themes" \
    "$BACKUP/icons" \
    "$BACKUP/extensions" \
    "$BACKUP/applications" \
    "$BACKUP/home"

dconf dump /org/gnome/ > "$BACKUP/dconf/org-gnome.ini" 2>/dev/null || true
dconf dump /org/gtk/ > "$BACKUP/dconf/org-gtk.ini" 2>/dev/null || true

[[ -e "$HOME/.config/gtk-3.0" ]] && cp -a "$HOME/.config/gtk-3.0" "$BACKUP/config/"
[[ -e "$HOME/.config/gtk-4.0" ]] && cp -a "$HOME/.config/gtk-4.0" "$BACKUP/config/"
[[ -e "$HOME/.config/background" ]] && cp -a "$HOME/.config/background" "$BACKUP/config/"
[[ -e "$HOME/.zshrc" ]] && cp -a "$HOME/.zshrc" "$BACKUP/home/"
[[ -e "$HOME/.config/user-dirs.dirs" ]] && cp -a "$HOME/.config/user-dirs.dirs" "$BACKUP/home/"

for src in "$ROOT/themes"/*; do
    name="$(basename "$src")"
    [[ -e "$HOME/.themes/$name" ]] && cp -a "$HOME/.themes/$name" "$BACKUP/themes/"
done

for src in "$ROOT/icons"/*; do
    name="$(basename "$src")"
    [[ -e "$HOME/.local/share/icons/$name" ]] && cp -a "$HOME/.local/share/icons/$name" "$BACKUP/icons/"
done

for src in "$ROOT/extensions/user"/*; do
    name="$(basename "$src")"
    [[ -e "$HOME/.local/share/gnome-shell/extensions/$name" ]] && \
        cp -a "$HOME/.local/share/gnome-shell/extensions/$name" "$BACKUP/extensions/"
done

[[ -e "$HOME/.local/share/applications/org.mozilla.firefox.desktop" ]] && \
    cp -a "$HOME/.local/share/applications/org.mozilla.firefox.desktop" "$BACKUP/applications/"

echo
echo "Instalando dependências..."

mapfile -t PACKAGES < <(grep -Ev '^[[:space:]]*(#|$)' "$ROOT/packages/required.txt")

if ((${#PACKAGES[@]})); then
    sudo dnf install -y "${PACKAGES[@]}"
fi

echo
echo "Restaurando temas..."

mkdir -p "$HOME/.themes"

for src in "$ROOT/themes"/*; do
    name="$(basename "$src")"
    rm -rf "$HOME/.themes/$name"
    cp -a "$src" "$HOME/.themes/$name"
done

echo "Restaurando ícones e cursor..."

mkdir -p "$HOME/.local/share/icons"

for src in "$ROOT/icons"/*; do
    name="$(basename "$src")"
    dest="$HOME/.local/share/icons/$name"

    if [[ "$name" == "hicolor" ]]; then
        mkdir -p "$dest"
        cp -a "$src/." "$dest/"
    else
        rm -rf "$dest"
        cp -a "$src" "$dest"
    fi
done

echo "Restaurando GTK..."

mkdir -p "$HOME/.config"

rm -rf "$HOME/.config/gtk-3.0"
rm -rf "$HOME/.config/gtk-4.0"

cp -a "$ROOT/gtk/gtk-3.0" "$HOME/.config/gtk-3.0"
cp -a "$ROOT/gtk/gtk-4.0" "$HOME/.config/gtk-4.0"

rm -f "$HOME/.config/gtk-4.0/gtk.css"
rm -f "$HOME/.config/gtk-4.0/gtk-dark.css"

ln -s "gtk-Dark.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -s "gtk-Dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"

echo "Restaurando extensões locais..."

mkdir -p "$HOME/.local/share/gnome-shell/extensions"

for src in "$ROOT/extensions/user"/*; do
    name="$(basename "$src")"
    dest="$HOME/.local/share/gnome-shell/extensions/$name"

    rm -rf "$dest"
    cp -a "$src" "$dest"

    if [[ -d "$dest/schemas" ]]; then
        glib-compile-schemas "$dest/schemas" 2>/dev/null || true
    fi
done

echo "Restaurando launcher do Firefox..."

mkdir -p "$HOME/.local/share/applications"

cp -a \
    "$ROOT/applications/org.mozilla.firefox.desktop" \
    "$HOME/.local/share/applications/org.mozilla.firefox.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" || true
fi

echo "Restaurando arquivos do usuário..."

cp -a "$ROOT/home/.zshrc" "$HOME/.zshrc"

if [[ -e "$ROOT/home/user-dirs.dirs" ]]; then
    cp -a "$ROOT/home/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
fi

if [[ -e "$HOME/.config/gtk-3.0/bookmarks" ]]; then
    sed -i "s#/home/csh#$HOME#g" "$HOME/.config/gtk-3.0/bookmarks"
fi

echo "Restaurando wallpaper..."

WALLPAPER_DIR="$HOME/Imagens/Wallpapers/Apple"
WALLPAPER_FILE="$WALLPAPER_DIR/iClarified-MacBook-Pro-2023-M3-Pro-Black.jpg"

mkdir -p "$WALLPAPER_DIR"
cp -a "$ROOT/wallpaper/background.jpg" "$WALLPAPER_FILE"
cp -a "$ROOT/wallpaper/background.jpg" "$HOME/.config/background"

echo "Restaurando dconf..."

TMP_GNOME="$(mktemp)"
trap 'rm -f "$TMP_GNOME"' EXIT

awk '
BEGIN {
    skip = 0
}
/^\[/ {
    skip = ($0 == "[login-screen]")
}
!skip {
    print
}
' "$ROOT/dconf/org-gnome.ini" | sed "s#/home/csh#$HOME#g" > "$TMP_GNOME"

dconf load /org/gnome/ < "$TMP_GNOME"

sed "s#/home/csh#$HOME#g" "$ROOT/dconf/org-gtk.ini" | dconf load /org/gtk/

echo "Aplicando wallpaper portátil..."

gsettings set \
    org.gnome.desktop.background \
    picture-uri \
    "'file://$HOME/.config/background'"

gsettings set \
    org.gnome.desktop.background \
    picture-uri-dark \
    "'file://$HOME/.config/background'"

gsettings set \
    org.gnome.desktop.screensaver \
    picture-uri \
    "'file://$HOME/.config/background'" 2>/dev/null || true

echo "Fixando exatamente as extensões aprovadas..."

ENABLED_VARIANT="[$(
    sed "s/^/'/; s/$/'/" "$ROOT/extensions/enabled.txt" |
    paste -sd, -
)]"

gsettings set org.gnome.shell enabled-extensions "$ENABLED_VARIANT"

while IFS= read -r uuid; do
    [[ -z "$uuid" ]] && continue
    gnome-extensions enable "$uuid" 2>/dev/null || true
done < "$ROOT/extensions/enabled.txt"

echo "Atualizando cache de fontes..."

fc-cache -f

echo
echo "========================================"
echo "RESTAURAÇÃO CONCLUÍDA"
echo "========================================"
echo
echo "Backup anterior salvo em:"
echo "$BACKUP"
echo
echo "Faça logout e login novamente."
echo "Não é necessário reiniciar o computador."
echo
