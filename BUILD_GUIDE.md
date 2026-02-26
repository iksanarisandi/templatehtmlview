# Panduan Build Aplikasi Catatan Simpel

## Cara 1: Build di Android Studio (Local)

### Build Debug APK (Tanpa Tanda Tangan)

1. Buka project di Android Studio
2. Tunggu Gradle sync selesai
3. Klik **Build > Build Bundle(s) / APK(s) > Build APK(s)**
4. Hasil: `app/build/outputs/apk/debug/app-debug.apk`

### Build Release APK/AAB (Dengan Tanda Tangan)

1. Klik **Build > Generate Signed Bundle / APK**
2. Pilih **Android App Bundle** atau **APK**
3. Klik **Create new...** untuk membuat keystore baru

#### Generate Keystore Baru

Jalankan command ini di terminal:

```bash
keytool -genkeypair \
  -v \
  -storetype JKS \
  -keystore catatan-simpel-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -sigalg SHA256withRSA \
  -validity 10000 \
  -alias catatankey \
  -dname "CN=Catatan Simpel, O=MyCatatan, L=Jakarta, ST=DKI, C=ID"
```

Setelah membuat keystore:
- Masukkan password keystore
- Masukkan password key (biasanya sama dengan password keystore)
- APK akan dihasilkan di `app/build/outputs/apk/release/`

---

## Cara 2: GitHub Actions (Recommended untuk Release)

### Langkah 1: Generate Keystore

```bash
# Generate keystore file
keytool -genkeypair \
  -v \
  -storetype JKS \
  -keystore catatan-simpel-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -sigalg SHA256withRSA \
  -validity 10000 \
  -alias catatankey \
  -storepass "CatatanSimpel2025!" \
  -keypass "CatatanSimpel2025!" \
  -dname "CN=Catatan Simpel, O=MyCatatan, L=Jakarta, ST=DKI, C=ID"
```

### Langkah 2: Setup GitHub Secrets

Pastikan sudah install GitHub CLI (`gh`):

```bash
# Encode keystore ke base64
base64 -w 0 catatan-simpel-release.jks

# Atau menggunakan file
base64 -i catatan-simpel-release.jks > keystore.txt
cat keystore.txt
```

Set keystore secrets:

```bash
# Set keystore base64 (copy output dari command base64 di atas)
gh secret set KEYSTORE_BASE64

# Set password keystore
gh secret set KEYSTORE_PASSWORD
# Masukkan: CatatanSimpel2025!

# Set key alias
gh secret set KEY_ALIAS
# Masukkan: catatankey

# Set key password
gh secret set KEY_PASSWORD
# Masukkan: CatatanSimpel2025!
```

### Langkah 3: Push ke GitHub

```bash
# Initialize git jika belum
git init
git add .
git commit -m "Initial commit: Catatan Simpel Android App"

# Create repository di GitHub dulu, lalu:
git remote add origin https://github.com/USERNAME/catatan-simpel.git
git branch -M main
git push -u origin main
```

### Langkah 4: Trigger Build

#### Otomatis (Push/Tag)
```bash
# Build otomatis saat push ke main
git push origin main

# Atau buat tag untuk release
git tag v1.0.0
git push origin v1.0.0
```

#### Manual (Workflow Dispatch)
1. Buka repository di GitHub
2. Masuk ke **Actions** tab
3. Pilih **Build Signed APK & AAB**
4. Klik **Run workflow**
5. Pilih build type: `all`, `apk`, atau `aab`
6. Klik **Run workflow**

### Langkah 5: Download Hasil Build

1. Buka **Actions** tab di repository
2. Klik workflow run yang selesai
3. Scroll ke bagian **Artifacts**
4. Download file yang diinginkan:
   - `catatan-simpel-release-apk` - APK tertandatangani
   - `catatan-simpel-release-aab` - AAB untuk Play Store

---

## Perbedaan APK dan AAB

| Type | Deskripsi | Penggunaan |
|------|-----------|------------|
| **APK** | Android Package | Direct install, sideload |
| **AAB** | Android App Bundle | Upload ke Google Play Store |

---

## Verify Signature

Untuk memverifikasi APK tertandatangani dengan benar:

```bash
# Check APK signature
apksigner verify --print-certs app-release.apk

# Check certificate info
keytool -printcert -jarfile app-release.apk
```

---

## Troubleshooting

### Error: "Keystore file not found"
Pastikan file keystore sudah di-encode ke base64 dan disimpan sebagai `KEYSTORE_BASE64` secret.

### Error: "Incorrect key password"
Pastikan `KEY_PASSWORD` dan `KEYSTORE_PASSWORD` sesuai dengan yang dibuat saat generate keystore.

### Build gagal di GitHub Actions
1. Check logs di Actions tab
2. Pastikan semua secrets sudah di-set
3. Verify package name di build.gradle.kts

---

## Quick Commands Reference

```bash
# Local build debug
./gradlew assembleDebug

# Local build release (perlu keystore config)
./gradlew assembleRelease

# Local build AAB
./gradlew bundleRelease

# Install ke package manager
adb install app/build/outputs/apk/debug/app-debug.apk
```

---

## Catatan Keamanan

- **JANGAN** commit file `.jks` ke repository!
- **JANGAN** share password keystore ke orang lain!
- **GUNAKAN** password yang kuat (minimal 12 karakter)
- **BACKUP** file keystore di tempat aman!
- Kalau keystore hilang, tidak bisa update aplikasi di Play Store!
