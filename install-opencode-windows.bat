@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: OpenCode AI - Windows 10 Kurulum Betiği (CMD)
:: Yönetici olarak çalıştırılmalıdır
:: ============================================================

title OpenCode AI Kurulumu

echo.
echo ========================================
echo    OpenCode AI - Windows 10 Kurulumu
echo ========================================
echo.

:: Yönetici kontrolü
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] Bu betik Yönetici olarak çalıştırılmalıdır!
    echo [INFO] CMD'yi sağ tıklayıp "Yönetici olarak çalıştır" seçeneğini kullanın.
    echo.
    pause
    exit /b 1
)

:: Node.js kontrolü
echo [INFO] Node.js kontrol ediliyor...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] Node.js yüklü değil!
    echo [INFO] Node.js indirmek için: https://nodejs.org/
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo [OK] Node.js bulundu: %NODE_VERSION%

:: npm kontrolü
echo [INFO] npm kontrol ediliyor...
for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo [OK] npm bulundu: %NPM_VERSION%

:: Kurulum dizini
set "INSTALL_PATH=%LOCALAPPDATA%\opencode-ai"

echo [INFO] Kurulum dizini: %INSTALL_PATH%

if exist "%INSTALL_PATH%" (
    echo [UYARI] Mevcut kurulum bulundu, kaldırılıyor...
    rmdir /s /q "%INSTALL_PATH%"
)

mkdir "%INSTALL_PATH%\bin" 2>nul
mkdir "%INSTALL_PATH%\config" 2>nul

echo [OK] Kurulum dizinleri oluşturuldu.

:: Binary dosyasını kopyala
if exist ".\platform-binaries\windows-x64\bin\opencode.exe" (
    copy ".\platform-binaries\windows-x64\bin\opencode.exe" "%INSTALL_PATH%\bin\opencode.exe" >nul
    echo [OK] opencode.exe kopyalandı.
) else (
    echo [HATA] opencode.exe bulunamadı!
    pause
    exit /b 1
)

:: PATH'e ekle
echo [INFO] PATH ortam değişkenine ekleniyor...
setx PATH "%PATH%;%INSTALL_PATH%\bin" >nul 2>&1
echo [OK] PATH güncellendi.

:: Örnek konfigürasyon
set "CONFIG_PATH=%USERPROFILE%\.opencode.json"
if not exist "%CONFIG_PATH%" (
    (
        echo {
        echo   "data": { "directory": ".opencode" },
        echo   "providers": {
        echo     "openai": { "apiKey": "", "disabled": false },
        echo     "anthropic": { "apiKey": "", "disabled": false },
        echo     "google": { "apiKey": "", "disabled": false }
        echo   },
        echo   "agents": {
        echo     "coder": { "model": "claude-3.7-sonnet", "maxTokens": 5000 },
        echo     "task": { "model": "claude-3.7-sonnet", "maxTokens": 5000 },
        echo     "title": { "model": "gpt-4o-mini", "maxTokens": 80 }
        echo   },
        echo   "debug": false,
        echo   "autoCompact": true
        echo }
    ) > "%CONFIG_PATH%"
    echo [OK] Örnek konfigürasyon dosyası oluşturuldu.
)

echo.
echo ========================================
echo    Kurulum Başarıyla Tamamlandı!
echo ========================================
echo.
echo Sonraki adımlar:
echo.
echo 1. Yeni bir CMD/PowerShell penceresi açın
echo 2. API anahtarlarınızı ayarlayın:
echo    set ANTHROPIC_API_KEY=your-key
echo    set OPENAI_API_KEY=your-key
echo    set GEMINI_API_KEY=your-key
echo.
echo 3. OpenCode'u başlatın:
echo    opencode
echo.
echo Yardım için: opencode --help
echo Konfigürasyon: %CONFIG_PATH%
echo.
pause
