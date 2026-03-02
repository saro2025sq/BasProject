# Platform Binaries

Bu klasör OpenCode AI binary dosyalarını içerir.

## ⚠️ GitHub Limiti Nedeniyle Bu Klasör Boş

Binary dosyaları 100 MB üzeri olduğu için GitHub'a yüklenemez.

**Bu dosyaları GitHub Releases'ten indirebilirsiniz:**

| Dosya | Boyut | İndirme Linki |
|-------|-------|---------------|
| opencode.exe | ~160 MB | [v1.2.15](https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe) |
| opencode-baseline.exe | ~160 MB | [v1.2.15-baseline](https://github.com/saro2025sq/BasProject/releases/download/v1.2.15-baseline/opencode-baseline.exe) |

## İndirme Komutları

### PowerShell

```powershell
# Modern CPU için
Invoke-WebRequest -Uri "https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe" -OutFile "opencode.exe"

# Eski CPU için (baseline)
Invoke-WebRequest -Uri "https://github.com/saro2025sq/BasProject/releases/download/v1.2.15-baseline/opencode-baseline.exe" -OutFile "opencode-baseline.exe"
```

### curl

```bash
# Modern CPU için
curl -L -o opencode.exe https://github.com/saro2025sq/BasProject/releases/download/v1.2.15/opencode.exe

# Eski CPU için (baseline)
curl -L -o opencode-baseline.exe https://github.com/saro2025sq/BasProject/releases/download/v1.2.15-baseline/opencode-baseline.exe
```

## Versiyonlar Arasındaki Fark

| Versiyon | CPU Gereksinimi | Açıklama |
|----------|-----------------|----------|
| opencode.exe | AVX destekli | Modern CPU'lar (2011+) |
| opencode-baseline.exe | SSE2 destekli | Tüm x64 CPU'lar |

## npm ile İndirme

Alternatif olarak npm paketini indirebilirsiniz:

```bash
# Modern CPU
npm pack opencode-windows-x64

# Eski CPU
npm pack opencode-windows-x64-baseline
```
