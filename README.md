# 🧹 VSCode Extension Cleanup Scripts

Automated scripts to detect and remove compromised **Visual Studio Code extensions** related to the **GlassWorm malware campaign (October 2025)**.  
This repository includes cleanup tools for both **Windows (PowerShell)** and **Linux (Bash)** environments, designed for use in enterprise or managed environments (e.g., via Microsoft Intune or cron jobs).

---

## ⚠️ Background

In October 2025, multiple malicious extensions were discovered in the VS Code ecosystem — both on the Microsoft Marketplace and OpenVSX.  
These extensions contained hidden, self-propagating malware known as **GlassWorm**, capable of stealing tokens, spreading via developer accounts, and injecting hidden Unicode characters in code.

### Known compromised extensions (confirmed)
| Publisher.Extension ID | Status |
|-------------------------|--------|
| `codejoy.codejoy-vscode-extension` | 🧨 infected |
| `l-igh-t.vscode-theme-seti-folder` | 🧨 infected |
| `kleinesfilmroellchen.serenity-dsl-syntaxhighlight` | 🧨 infected |
| `JScearcy.rust-doc-viewer` | 🧨 infected |
| `SIRILMP.dark-theme-sm` | 🧨 infected |
| `CodeInKlingon.git-worktree-menu` | 🧨 infected |
| `ginfuru.better-nunjucks` | 🧨 infected |
| `ellacrity.recoil` | 🧨 infected |
| `grrrck.positron-plus-1-e` | 🧨 infected |
| `jeronimoekerdt.color-picker-universal` | 🧨 infected |
| `srcery-colors.srcery-colors` | 🧨 infected |
| `cline-ai-main.cline-ai-agent` | 🧨 infected |

---

## 🧰 Included Scripts

### 🪟 **Windows (PowerShell)**
File: [`scripts/Remove-Compromised-VSCodeExtensions.ps1`](scripts/Remove-Compromised-VSCodeExtensions.ps1)

**Features**
- Scans default and system VSCode extension directories  
- Removes all known compromised extensions  
- Generates a timestamped log file in `%TEMP%\VSCode_Extension_Cleanup.log`  
- Fully compatible with Microsoft Intune deployment  

**Usage**
```powershell
# Run manually
powershell.exe -ExecutionPolicy Bypass -File .\Remove-Compromised-VSCodeExtensions.ps1

# or deploy via Intune:
# - Run script using logged-on credentials: Yes
# - Run script in 64-bit PowerShell host: Yes
