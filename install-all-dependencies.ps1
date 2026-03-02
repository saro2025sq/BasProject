# OpenCode AI - Windows Kurulum Script'i
# Tüm bağımlılıkları otomatik kurar

param(
    [switch]$SkipGit,
    [switch]$SkipNode,
    [switch]$SkipTerminal,
    [string]$ApiKey = "",
    [string]$Provider = "anthropic"
)

$ErrorActionPreference = "Stop"

function Write-Status { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "[UYARI] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[HATA] $msg" -ForegroundColor Red }

# Başlık
Clear-Host
Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   OpenCode AI - Windows Kurulumu" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Yönetici kontrolü
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "Yönetici olarak çalıştırılması önerilir!"
    Write-Host "Bazı kurulumlar başarısız olabilir." -ForegroundColor Yellow
    Write-Host ""
}

# 1. Git Kurulumu
if (-not $SkipGit) {
    Write-Status "Git kontrol ediliyor..."
    if (Get-Command git -ErrorAction SilentlyContinue) {
        Write-Success "Git zaten kurulu: $(git --version)"
    } else {
        Write-Status "Git kurulumu yapılıyor..."
        try {
            winget install Git.Git --accept-source-agreements --accept-package-agreements --silent
            Write-Success "Git kuruldu"
        } catch {
            Write-Err "Git kurulumu başarısız: $_"
        }
    }
}

# 2. Node.js Kurulumu
if (-not $SkipNode) {
    Write-Status "Node.js kontrol ediliyor..."
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-Success "Node.js zaten kurulu: $(node --version)"
    } else {
        Write-Status "Node.js kurulumu yapılıyor..."
        try {
            winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements --silent
            Write-Success "Node.js kuruldu"
        } catch {
            Write-Warning "Node.js kurulumu başarısız (opsiyonel): $_"
        }
    }
}

# 3. Windows Terminal
if (-not $SkipTerminal) {
    Write-Status "Windows Terminal kontrol ediliyor..."
    $wt = Get-Command wt -ErrorAction SilentlyContinue
    if ($wt) {
        Write-Success "Windows Terminal zaten kurulu"
    } else {
        Write-Status "Windows Terminal kurulumu yapılıyor..."
        try {
            winget install Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements --silent
            Write-Success "Windows Terminal kuruldu"
        } catch {
            Write-Warning "Windows Terminal kurulumu başarısız (opsiyonel): $_"
        }
    }
}

# 4. OpenCode Binary
Write-Status "OpenCode binary kontrol ediliyor..."
$installPath = "$env:LOCALAPPDATA\opencode-ai"
$binaryPath = "$installPath\opencode.exe"

if (Test-Path $binaryPath) {
    Write-Success "OpenCode zaten kurulu: $binaryPath"
} else {
    Write-Status "OpenCode indiriliyor..."
    try {
        New-Item -ItemType Directory -Force -Path $installPath | Out-Null
        
        $downloadUrl = "https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $binaryPath -UseBasicParsing
        Write-Success "OpenCode indirildi: $binaryPath"
    } catch {
        Write-Err "OpenCode indirme hatası: $_"
        Write-Host "Manuel indirme: https://github.com/saro2025sq/BasProject/releases" -ForegroundColor Yellow
    }
}

# 5. PATH güncelleme
Write-Status "PATH kontrol ediliyor..."
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$installPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$installPath", "User")
    Write-Success "PATH güncellendi"
} else {
    Write-Success "PATH zaten doğru"
}

# 6. API Anahtarı
if ($ApiKey -ne "") {
    Write-Status "API anahtarı ayarlanıyor..."
    $envKey = switch ($Provider.ToLower()) {
        "anthropic" { "ANTHROPIC_API_KEY" }
        "openai" { "OPENAI_API_KEY" }
        "google" { "GEMINI_API_KEY" }
        "groq" { "GROQ_API_KEY" }
        default { "ANTHROPIC_API_KEY" }
    }
    
    [Environment]::SetEnvironmentVariable($envKey, $ApiKey, "User")
    Write-Success "$envKey ayarlandı"
}

# 7. Konfigürasyon dosyası
$configPath = "$env:USERPROFILE\.opencode.json"
if (-not (Test-Path $configPath)) {
    Write-Status "Konfigürasyon dosyası oluşturuluyor..."
    $config = @{
        data = @{ directory = ".opencode" }
        providers = @{
            anthropic = @{ apiKey = ""; disabled = $false }
            openai = @{ apiKey = ""; disabled = $false }
            google = @{ apiKey = ""; disabled = $false }
        }
        agents = @{
            coder = @{ model = "claude-3.7-sonnet"; maxTokens = 5000 }
            task = @{ model = "claude-3.7-sonnet"; maxTokens = 5000 }
            title = @{ model = "gpt-4o-mini"; maxTokens = 80 }
        }
        autoCompact = $true
    }
    
    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
    Write-Success "Konfigürasyon dosyası oluşturuldu: $configPath"
}

# Özet
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Kurulum Tamamlandı!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Sonraki adımlar:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Terminali yeniden açın" -ForegroundColor White
Write-Host "2. API anahtarınızı ayarlayın:" -ForegroundColor White
Write-Host "   `$env:ANTHROPIC_API_KEY = 'your-key'" -ForegroundColor Gray
Write-Host ""
Write-Host "3. OpenCode'u başlatın:" -ForegroundColor White
Write-Host "   opencode" -ForegroundColor Yellow
Write-Host ""

# Doğrulama
Write-Host "Kurulum doğrulaması:" -ForegroundColor Cyan
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Git" -ForegroundColor Green
} else {
    Write-Host "  [--] Git" -ForegroundColor Yellow
}

if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Node.js" -ForegroundColor Green
} else {
    Write-Host "  [--] Node.js (opsiyonel)" -ForegroundColor Yellow
}

if (Test-Path $binaryPath) {
    Write-Host "  [OK] OpenCode" -ForegroundColor Green
} else {
    Write-Host "  [!!] OpenCode" -ForegroundColor Red
}

Write-Host ""
Write-Host "Konfigürasyon: $configPath" -ForegroundColor Gray
Write-Host "Binary: $binaryPath" -ForegroundColor Gray
Write-Host ""
