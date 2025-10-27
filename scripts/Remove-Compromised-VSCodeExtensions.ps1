<#
.SYNOPSIS
  Entfernt kompromittierte Visual Studio Code Erweiterungen (GlassWorm-Kampagne, Okt 2025).

.DESCRIPTION
  Dieses Skript durchsucht das VS Code Extensions-Verzeichnis im Benutzerprofil
  und löscht alle bekannten bösartigen Erweiterungen basierend auf ihren Publisher-IDs.
  Es erstellt zudem ein Logfile im Temp-Ordner des Systems.

.AUTHOR
  Sebastian / ConbroIT Security Maintenance
  Version 1.1 – 2025-10-27
#>

# --- Konfiguration ---
$LogFile = "$env:TEMP\VSCode_Extension_Cleanup.log"
$Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

$CompromisedExtensions = @(
    "codejoy.codejoy-vscode-extension",
    "l-igh-t.vscode-theme-seti-folder",
    "kleinesfilmroellchen.serenity-dsl-syntaxhighlight",
    "JScearcy.rust-doc-viewer",
    "SIRILMP.dark-theme-sm",
    "CodeInKlingon.git-worktree-menu",
    "ginfuru.better-nunjucks",
    "ellacrity.recoil",
    "grrrck.positron-plus-1-e",
    "jeronimoekerdt.color-picker-universal",
    "srcery-colors.srcery-colors",
    "cline-ai-main.cline-ai-agent"
)

# --- Funktionen ---
function Write-Log {
    param([string]$Message)
    $entry = "[$Timestamp] $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry
}

function Remove-CompromisedExtensions {
    param([string]$ExtDir)
    if (-not (Test-Path $ExtDir)) {
        Write-Log "❌ Kein VSCode-Erweiterungsverzeichnis gefunden unter: $ExtDir"
        return
    }

    Write-Log "🔍 Scanne Erweiterungsverzeichnis: $ExtDir"

    foreach ($ext in $CompromisedExtensions) {
        $matches = Get-ChildItem -Path $ExtDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "$ext*" }
        foreach ($m in $matches) {
            try {
                Write-Log "⚠️ Entferne kompromittierte Erweiterung: $($m.Name)"
                Remove-Item -Path $m.FullName -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Log "❗ Fehler beim Entfernen von $($m.Name): $_"
            }
        }
    }
}

# --- Hauptlogik ---
Write-Log "============================================="
Write-Log "🧹 Start der Bereinigung kompromittierter VS Code Erweiterungen"
Write-Log "============================================="

# Standardverzeichnisse für Benutzerinstallationen
$UserDirs = @(
    "$env:USERPROFILE\.vscode\extensions",
    "$env:USERPROFILE\.vscode-insiders\extensions"
)

foreach ($dir in $UserDirs) {
    Remove-CompromisedExtensions -ExtDir $dir
}

# Systemweite Installationen (z. B. auf gemeinsam genutzten Maschinen)
$SystemDirs = @(
    "C:\Program Files\Microsoft VS Code\resources\app\extensions",
    "C:\Program Files (x86)\Microsoft VS Code\resources\app\extensions"
)
foreach ($dir in $SystemDirs) {
    Remove-CompromisedExtensions -ExtDir $dir
}

Write-Log "✅ Bereinigung abgeschlossen. Logdatei: $LogFile"