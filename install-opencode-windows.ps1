# ============================================================
# OpenCode AI - Windows 10 Kurulum Betiği
# PowerShell Yönetici olarak çalıştırılmalıdır
# ============================================================

param(
    [switch]$Offline,
    [string]$InstallPath = "$env:LOCALAPPDATA\opencode-ai"
)

$ErrorActionPreference = "Stop"

# Renkli çıktı fonksiyonları
function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Cyan }
function Write-Success { Write-Host "[OK] $args" -ForegroundColor Green }
function Write-Warning { Write-Host "[UYARI] $args" -ForegroundColor Yellow }
function Write-Error { Write-Host "[HATA] $args" -ForegroundColor Red }

# Başlık
Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   OpenCode AI - Windows 10 Kurulumu" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Yönetici kontrolü
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "Bu betik Yönetici olarak çalıştırılmalıdır!"
    Write-Info "PowerShell'i sağ tıklayıp 'Yönetici olarak çalıştır' seçeneğini kullanın."
    Write-Host ""
    Write-Host "Alternatif olarak, kullanıcı bazlı kurulum için:" -ForegroundColor Yellow
    Write-Host "  .\install-opencode-windows.ps1 -Offline" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Node.js kontrolü
Write-Info "Node.js kontrol ediliyor..."
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "Node.js yüklü değil!"
    Write-Info "Node.js indirmek için: https://nodejs.org/"
    Write-Info "veya: winget install OpenJS.NodeJS.LTS"
    exit 1
}
$nodeVersion = node --version
Write-Success "Node.js bulundu: $nodeVersion"

# npm kontrolü
Write-Info "npm kontrol ediliyor..."
$npmVersion = npm --version
Write-Success "npm bulundu: $npmVersion"

# Kurulum dizini
Write-Info "Kurulum dizini: $InstallPath"

if (Test-Path $InstallPath) {
    Write-Warning "Mevcut kurulum bulundu, kaldırılıyor..."
    Remove-Item -Recurse -Force $InstallPath
}

New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
New-Item -ItemType Directory -Path "$InstallPath\bin" -Force | Out-Null
New-Item -ItemType Directory -Path "$InstallPath\config" -Force | Out-Null

Write-Success "Kurulum dizinleri oluşturuldu."

# Binary dosyasını kopyala
$binarySource = ".\platform-binaries\windows-x64\bin\opencode.exe"
if (Test-Path $binarySource) {
    Copy-Item $binarySource "$InstallPath\bin\opencode.exe" -Force
    Write-Success "opencode.exe kopyalandı."
} else {
    Write-Error "opencode.exe bulunamadı! Paketi doğru çıkardığınızdan emin olun."
    exit 1
}

# PATH'e ekle
Write-Info "PATH ortam değişkenine ekleniyor..."
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$InstallPath\bin*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$InstallPath\bin", "User")
    Write-Success "PATH güncellendi."
} else {
    Write-Info "PATH zaten doğru yapılandırılmış."
}

# Örnek konfigürasyon dosyası oluştur
$configContent = @'
{
  "data": {
    "directory": ".opencode"
  },
  "providers": {
    "openai": {
      "apiKey": "",
      "disabled": false
    },
    "anthropic": {
      "apiKey": "",
      "disabled": false
    },
    "google": {
      "apiKey": "",
      "disabled": false
    }
  },
  "agents": {
    "coder": {
      "model": "claude-3.7-sonnet",
      "maxTokens": 5000
    },
    "task": {
      "model": "claude-3.7-sonnet",
      "maxTokens": 5000
    },
    "title": {
      "model": "gpt-4o-mini",
      "maxTokens": 80
    }
  },
  "debug": false,
  "autoCompact": true
}
'@

$configPath = "$env:USERPROFILE\.opencode.json"
if (-not (Test-Path $configPath)) {
    $configContent | Out-File -FilePath $configPath -Encoding UTF8
    Write-Success "Örnek konfigürasyon dosyası oluşturuldu: $configPath"
} else {
    Write-Info "Mevcut konfigürasyon dosyası korundu."
}

# Dokümantasyon kopyala
if (Test-Path ".\docs") {
    Copy-Item -Recurse ".\docs" "$InstallPath\docs" -Force
    Write-Success "Dokümantasyon kopyalandı."
}

# Kurulum tamamlandı
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Kurulum Başarıyla Tamamlandı!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Sonraki adımlar:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Yeni bir PowerShell/CMD penceresi açın" -ForegroundColor White
Write-Host "2. API anahtarlarınızı ayarlayın:" -ForegroundColor White
Write-Host "   - Anthropic: `$env:ANTHROPIC_API_KEY = 'your-key'" -ForegroundColor Gray
Write-Host "   - OpenAI:    `$env:OPENAI_API_KEY = 'your-key'" -ForegroundColor Gray
Write-Host "   - Google:    `$env:GEMINI_API_KEY = 'your-key'" -ForegroundColor Gray
Write-Host ""
Write-Host "3. OpenCode'u başlatın:" -ForegroundColor White
Write-Host "   opencode" -ForegroundColor Yellow
Write-Host ""
Write-Host "Yardım için: opencode --help" -ForegroundColor Gray
Write-Host "Konfigürasyon: $configPath" -ForegroundColor Gray
Write-Host ""
