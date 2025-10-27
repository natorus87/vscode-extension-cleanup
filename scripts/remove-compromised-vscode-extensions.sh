#!/usr/bin/env bash
# ==============================================================================
# Entfernt kompromittierte Visual Studio Code Erweiterungen (GlassWorm-Kampagne, Okt 2025)
# ==============================================================================
# Dieses Skript sucht nach infizierten Erweiterungen in allen Benutzerverzeichnissen
# und entfernt sie. Außerdem wird ein Logfile in /var/log erstellt.
#
# Autor: Sebastian Broers
# Version: 1.1 – 2025-10-27
# ==============================================================================

LOGFILE="/var/log/vscode_extension_cleanup.log"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# --- Liste kompromittierter Erweiterungen ---
COMPROMISED_EXTENSIONS=(
  "codejoy.codejoy-vscode-extension"
  "l-igh-t.vscode-theme-seti-folder"
  "kleinesfilmroellchen.serenity-dsl-syntaxhighlight"
  "JScearcy.rust-doc-viewer"
  "SIRILMP.dark-theme-sm"
  "CodeInKlingon.git-worktree-menu"
  "ginfuru.better-nunjucks"
  "ellacrity.recoil"
  "grrrck.positron-plus-1-e"
  "jeronimoekerdt.color-picker-universal"
  "srcery-colors.srcery-colors"
  "cline-ai-main.cline-ai-agent"
)

# --- Hilfsfunktion fürs Logging ---
log() {
  echo "[$TIMESTAMP] $1" | tee -a "$LOGFILE"
}

# --- Funktion: Erweiterungen in gegebenem Pfad prüfen ---
remove_compromised_extensions() {
  local ext_dir="$1"
  if [[ ! -d "$ext_dir" ]]; then
    log "❌ Kein VSCode-Erweiterungsverzeichnis gefunden: $ext_dir"
    return
  fi

  log "🔍 Scanne Erweiterungsverzeichnis: $ext_dir"
  for ext in "${COMPROMISED_EXTENSIONS[@]}"; do
    local matches
    matches=$(find "$ext_dir" -maxdepth 1 -type d -iname "${ext}*" 2>/dev/null)
    if [[ -n "$matches" ]]; then
      while IFS= read -r dir; do
        log "⚠️ Entferne kompromittierte Erweiterung: $(basename "$dir")"
        rm -rf "$dir"
      done <<< "$matches"
    fi
  done
}

# --- Hauptprogramm ---
log "============================================================"
log "🧹 Starte Bereinigung kompromittierter VSCode-Erweiterungen"
log "============================================================"

# --- Benutzerverzeichnisse prüfen ---
for user_home in /home/*; do
  [[ -d "$user_home" ]] || continue
  remove_compromised_extensions "$user_home/.vscode/extensions"
  remove_compromised_extensions "$user_home/.vscode-insiders/extensions"
done

# --- Systemweite Installationen prüfen (falls VSCode global installiert ist) ---
SYSTEM_DIRS=(
  "/usr/share/code/resources/app/extensions"
  "/usr/lib/code/resources/app/extensions"
  "/opt/visual-studio-code/resources/app/extensions"
)
for dir in "${SYSTEM_DIRS[@]}"; do
  remove_compromised_extensions "$dir"
done

log "✅ Bereinigung abgeschlossen. Logdatei: $LOGFILE"
exit 0