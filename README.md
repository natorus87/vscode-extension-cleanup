# 🧹 VSCode Extension Cleanup Scripts

Automated scripts to detect and remove compromised **Visual Studio Code extensions** related to the **GlassWorm malware campaign (October 2025)**.  
This repository includes cleanup tools for both **Windows (PowerShell)** and **Linux (Bash)** environments, designed for use in enterprise or managed setups (e.g., via Microsoft Intune, cron jobs, or Ansible).

---

## ⚠️ Background

In October 2025, several malicious extensions were discovered in the VS Code ecosystem — both in the Microsoft Marketplace and OpenVSX.  
These extensions contained self-propagating malware known as **GlassWorm**, capable of:

- Stealing authentication tokens (GitHub, npm, OpenVSX)  
- Using infected developer machines as SOCKS proxies  
- Spreading through compromised VS Code extensions  
- Injecting hidden Unicode control characters (e.g., *variation selectors*)  
- Hiding in otherwise legitimate-looking code updates  

### 🧨 Known compromised extensions (confirmed)

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

📄 **File:** [`scripts/Remove-Compromised-VSCodeExtensions.ps1`](scripts/Remove-Compromised-VSCodeExtensions.ps1)

**Features**
- Scans default and system VSCode extension directories  
- Removes all known compromised extensions  
- Generates a timestamped log file in `%TEMP%\VSCode_Extension_Cleanup.log`  
- Fully compatible with Microsoft Intune or manual execution  

**Usage**
```powershell
# Run manually
powershell.exe -ExecutionPolicy Bypass -File .\Remove-Compromised-VSCodeExtensions.ps1

# Example output:
# [2025-10-27 11:00:03] 🔍 Scanning C:\Users\Dev\.vscode\extensions
# [2025-10-27 11:00:04] ⚠️ Removing compromised extension: ginfuru.better-nunjucks
# [2025-10-27 11:00:07] ✅ Cleanup complete
```

**Intune Deployment**
1. Go to **Devices → Scripts → Windows 10 and later → Add PowerShell script**  
2. Upload the script  
3. Configuration:
   - *Run using logged-on credentials:* ✅ Yes  
   - *Run in 64-bit PowerShell host:* ✅ Yes  
   - *Enforce signature check:* ❌ No  
4. Assign to your device or user group  

---

### 🐧 **Linux / Ubuntu (Bash)**

📄 **File:** [`scripts/remove-compromised-vscode-extensions.sh`](scripts/remove-compromised-vscode-extensions.sh)

**Features**
- Scans all local user home directories for `.vscode/extensions` and `.vscode-insiders/extensions`  
- Cleans system-wide installations (e.g., `/usr/share/code/resources/app/extensions`)  
- Automatically removes compromised extensions  
- Logs all actions to `/var/log/vscode_extension_cleanup.log`  

**Usage**
```bash
# Make executable
sudo chmod +x scripts/remove-compromised-vscode-extensions.sh

# Run cleanup
sudo ./scripts/remove-compromised-vscode-extensions.sh
```

**Example output:**
```
[2025-10-27 12:34:15] 🔍 Scanning /home/dev/.vscode/extensions
[2025-10-27 12:34:15] ⚠️ Removing compromised extension: cline-ai-main.cline-ai-agent
[2025-10-27 12:34:18] ✅ Cleanup complete. Log saved to /var/log/vscode_extension_cleanup.log
```

**Optional (Automate via cron):**
```bash
sudo cp scripts/remove-compromised-vscode-extensions.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/remove-compromised-vscode-extensions.sh

# Schedule daily cleanup at 3 AM
sudo crontab -e
0 3 * * * /usr/local/bin/remove-compromised-vscode-extensions.sh >/dev/null 2>&1
```

---

## 🧩 Integration Tips

For **enterprise environments** (hybrid Windows/Linux):
- Deploy PowerShell via **Intune** (Windows clients)  
- Deploy Bash script via **configuration management** (Ansible, Puppet, or cron)  
- Consider disabling VS Code auto-updates temporarily  
- Rotate any developer API tokens (GitHub, npm, OpenVSX) used on affected machines  

---

## 🧠 Future Improvements
- Enforce VSCode policy (`extensions.allowed`) to whitelist trusted extensions only  
- Disable automatic marketplace access (`extensionsGallery.enabled = false`)  
- Integrate JSON policy enforcement for corporate environments  
- Optional telemetry to collect cleanup reports  

---

## 🪪 License
This project is released under the **MIT License** — you are free to use, modify, and distribute these scripts with attribution.

---

## 👤 Author
**Sebastian Broers**  
[ConbroIT Security Maintenance](https://www.conbroit.de)  
Munich, Germany – 2025
