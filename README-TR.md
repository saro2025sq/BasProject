# OpenCode AI - Windows 10 Kurulum Paketi

Bu paket, Windows 10 terminalinde çalışacak OpenCode AI aracının tam kurulum dosyalarını içerir.

## 📥 İndirme

### Release Dosyaları (GitHub)

| Dosya | Açıklama | İndirme Linki |
|-------|----------|---------------|
| `opencode.exe` | Windows x64 (Modern CPU) | [İndir](https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe) |
| `opencode-baseline.exe` | Windows x64 (Eski CPU) | [İndir](https://github.com/saro2025sq/BasProject/releases/download/v1.2.15-baseline/opencode-baseline.exe) |

## 📁 Paket İçeriği

```
BasProject/
├── install-opencode-windows.ps1    # PowerShell kurulum betiği (önerilen)
├── install-opencode-windows.bat    # CMD kurulum betiği (alternatif)
├── package/                        # npm paketi kaynak dosyaları
├── github-repo/                    # GitHub kaynak kodu
└── README-TR.md                    # Bu dosya

📁 Releases (GitHub):
├── v1.2.15/opencode.exe            # Windows x64 (Modern CPU - AVX destekli)
└── v1.2.15-baseline/opencode-baseline.exe  # Windows x64 (Eski CPU - SSE2)
```

## ⚙️ Gereksinimler

- **Windows 10** (64-bit)
- **PowerShell 5.1+** veya **CMD**
- Node.js isteğe bağlı (bazı özellikler için)

## 🚀 Hızlı Kurulum

### Yöntem 1: Doğrudan İndirme (En Kolay)

```powershell
# PowerShell'de çalıştırın
# Binary'yi indirin
Invoke-WebRequest -Uri "https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe" -OutFile "opencode.exe"

# İstenen klasöre taşıyın
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\opencode-ai"
Move-Item opencode.exe "$env:LOCALAPPDATA\opencode-ai\"

# PATH'e ekleyin
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$env:LOCALAPPDATA\opencode-ai", "User")
```

### Yöntem 2: PowerShell Kurulum Betiği

1. PowerShell'i **Yönetici olarak çalıştırın**
2. Bu klasöre gidin
3. Şu komutu çalıştırın:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\install-opencode-windows.ps1
```

### Yöntem 3: CMD (Batch)

1. CMD'yi **Yönetici olarak çalıştırın**
2. Bu klasöre gidin
3. Şu komutu çalıştırın:

```cmd
install-opencode-windows.bat
```

## 🔑 API Anahtarı Yapılandırması

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

## 🤖 Desteklenen AI Modelleri

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

## 📖 Kullanım

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

## ⌨️ Klavye Kısayolları

| Kısayol | Aksiyon |
|---------|---------|
| `Ctrl+C` | Çıkış |
| `Ctrl+K` | Komut dialogu |
| `Ctrl+O` | Model seçimi |
| `Ctrl+N` | Yeni session |
| `Ctrl+S` | Mesaj gönder |
| `i` | Editör modu |
| `?` | Yardım |

## 🔧 Sorun Giderme

### "opencode" komutu bulunamadı

1. Yeni bir terminal penceresi açın (PATH güncellemesi için)
2. PATH'i kontrol edin: `$env:PATH`
3. Manuel olarak ekleyin:
   ```powershell
   $env:PATH += ";$env:LOCALAPPDATA\opencode-ai"
   ```

### API Hatası

1. API anahtarınızın doğru olduğundan emin olun
2. API kotanızın dolu olmadığını kontrol edin
3. İnternet bağlantınızı kontrol edin

### Eski CPU'lar İçin

Eğer standart `opencode.exe` çalışmıyorsa, **baseline** versiyonunu kullanın:

```powershell
# Baseline versiyonunu indirin
Invoke-WebRequest -Uri "https://github.com/saro2025sq/BasProject/releases/download/v1.2.15-baseline/opencode-baseline.exe" -OutFile "opencode.exe"
```

**Baseline vs Standart:**
- **Standart**: AVX komut seti destekli modern CPU'lar
- **Baseline**: SSE2 destekli tüm x64 CPU'lar (eski sistemler için)

## 📚 Ek Kaynaklar

- **Resmi Site:** https://opencode.ai
- **GitHub:** https://github.com/opencode-ai/opencode
- **Dokümantasyon:** https://opencode.ai/docs

## 📌 Sürüm Bilgisi

- **Paket:** opencode-ai v1.2.15
- **Windows Binary:** opencode-windows-x64 v1.2.15

## 📄 Lisans

MIT License - Detaylar için LICENSE dosyasına bakın.

---

**Not:** Bu paket OpenCode projesinin resmi bir dağıtımı değildir. Yalnızca Windows 10 için çevrimdışı kurulum kolaylığı sağlamak amacıyla hazırlanmıştır.
