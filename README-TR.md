# OpenCode AI - Windows 10 Kurulum Paketi

Bu paket, Windows 10 terminalinde çalışacak OpenCode AI aracının tam kurulum dosyalarını içerir.

## İçindekiler

```
opencode-ai-package/
├── install-opencode-windows.ps1    # PowerShell kurulum betiği (önerilen)
├── install-opencode-windows.bat    # CMD kurulum betiği (alternatif)
├── platform-binaries/              # Platform binary dosyaları
│   ├── windows-x64/                # Windows 64-bit binary
│   │   └── bin/opencode.exe        # Ana çalıştırılabilir dosya
│   └── windows-x64-baseline/       # Eski CPU'lar için binary
├── package/                        # npm paketi kaynak dosyaları
├── github-repo/                    # GitHub kaynak kodu
└── README-TR.md                    # Bu dosya
```

## Gereksinimler

- **Windows 10** (64-bit)
- **Node.js 18+** (npm ile birlikte)
- **PowerShell 5.1+** veya **CMD**

## Hızlı Kurulum

### Yöntem 1: PowerShell (Önerilen)

1. PowerShell'i **Yönetici olarak çalıştırın**
2. Bu klasöre gidin
3. Şu komutu çalıştırın:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\install-opencode-windows.ps1
```

### Yöntem 2: CMD (Batch)

1. CMD'yi **Yönetici olarak çalıştırın**
2. Bu klasöre gidin
3. Şu komutu çalıştırın:

```cmd
install-opencode-windows.bat
```

### Yöntem 3: Manuel Kurulum

```powershell
# Binary'yi kopyala
Copy-Item ".\platform-binaries\windows-x64\bin\opencode.exe" "C:\Tools\opencode.exe"

# PATH'e ekle (PowerShell)
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Tools", "User")
```

## API Anahtarı Yapılandırması

OpenCode'u kullanmak için en az bir AI sağlayıcısının API anahtarına ihtiyacınız var:

### PowerShell'de Ayarlama

```powershell
# Anthropic (Claude)
$env:ANTHROPIC_API_KEY = "sk-ant-api03-..."

# OpenAI (GPT-4)
$env:OPENAI_API_KEY = "sk-..."

# Google (Gemini)
$env:GEMINI_API_KEY = "AIza..."

# Kalıcı ayarlamak için:
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-key", "User")
```

### CMD'de Ayarlama

```cmd
set ANTHROPIC_API_KEY=sk-ant-api03-...
set OPENAI_API_KEY=sk-...
set GEMINI_API_KEY=AIza...

:: Kalıcı ayarlamak için:
setx ANTHROPIC_API_KEY "your-key"
```

### Konfigürasyon Dosyası

`%USERPROFILE%\.opencode.json` dosyasını düzenleyerek de ayarlayabilirsiniz:

```json
{
  "providers": {
    "anthropic": {
      "apiKey": "sk-ant-api03-...",
      "disabled": false
    },
    "openai": {
      "apiKey": "sk-...",
      "disabled": false
    },
    "google": {
      "apiKey": "AIza...",
      "disabled": false
    }
  },
  "agents": {
    "coder": {
      "model": "claude-3.7-sonnet",
      "maxTokens": 5000
    }
  }
}
```

## Desteklenen AI Modelleri

### Anthropic (Claude)
- Claude 4 Sonnet
- Claude 4 Opus
- Claude 3.7 Sonnet
- Claude 3.5 Sonnet/Haiku

### OpenAI
- GPT-4.1, GPT-4.1-mini, GPT-4.1-nano
- GPT-4o, GPT-4o-mini
- O1, O1-mini, O3-mini

### Google (Gemini)
- Gemini 2.5 Pro
- Gemini 2.5 Flash
- Gemini 2.0 Flash

### Diğer Sağlayıcılar
- GitHub Copilot
- Groq
- AWS Bedrock
- Azure OpenAI
- OpenRouter

## Kullanım

```powershell
# OpenCode'u başlat
opencode

# Non-interactive mod
opencode -p "Kodumu açıkla"

# Debug modu
opencode -d

# Belirli dizinde
opencode -c C:\projelerim\uygulama
```

## Klavye Kısayolları

| Kısayol | Aksiyon |
|---------|---------|
| `Ctrl+C` | Çıkış |
| `Ctrl+K` | Komut dialogu |
| `Ctrl+O` | Model seçimi |
| `Ctrl+N` | Yeni session |
| `Ctrl+S` | Mesaj gönder |
| `i` | Editör modu |
| `?` | Yardım |

## Sorun Giderme

### "opencode" komutu bulunamadı

1. Yeni bir terminal penceresi açın (PATH güncellemesi için)
2. PATH'i kontrol edin: `$env:PATH`
3. Manuel olarak ekleyin:
   ```powershell
   $env:PATH += ";$env:LOCALAPPDATA\opencode-ai\bin"
   ```

### API Hatası

1. API anahtarınızın doğru olduğundan emin olun
2. API kotanızın dolu olmadığını kontrol edin
3. İnternet bağlantınızı kontrol edin

### Eski CPU'lar İçin

Eğer `opencode.exe` çalışmıyorsa, baseline versiyonunu kullanın:

```powershell
Copy-Item ".\platform-binaries\windows-x64-baseline\bin\opencode.exe" "$env:LOCALAPPDATA\opencode-ai\bin\opencode.exe"
```

## Ek Kaynaklar

- **Resmi Site:** https://opencode.ai
- **GitHub:** https://github.com/opencode-ai/opencode
- **Dokümantasyon:** https://opencode.ai/docs

## Sürüm Bilgisi

- **Paket:** opencode-ai v1.2.15
- **Windows Binary:** opencode-windows-x64 v1.2.15

## Lisans

MIT License - Detaylar için LICENSE dosyasına bakın.

---

**Not:** Bu paket OpenCode projesinin resmi bir dağıtımı değildir. Yalnızca Windows 10 için çevrimdışı kurulum kolaylığı sağlamak amacıyla hazırlanmıştır.
