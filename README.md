# Catatan Simpel - Android App

A simple Android WebView application that displays local HTML files with JavaScript enabled.

## Project Information

| Property | Value |
|----------|-------|
| **App Name** | Catatan Simpel |
| **Package Name** | com.mycatatan.simple1 |
| **Min SDK** | 24 (Android 7.0) |
| **Target SDK** | 35 (Android 15) |
| **Compile SDK** | 35 |
| **Version** | 1.0.0 (versionCode: 1) |

## Features

- JavaScript enabled
- Local HTML file loading from assets
- Touch optimized
- Material Design 3
- Edge-to-edge display
- Fullscreen immersive mode
- Zoom controls enabled

## Project Structure

```
htmlview/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/mycatatan/simple1/
│   │       │   └── MainActivity.kt
│   │       ├── res/
│   │       │   ├── values/
│   │       │   │   ├── strings.xml
│   │       │   │   ├── colors.xml
│   │       │   │   └── themes.xml
│   │       │   └── xml/
│   │       ├── assets/
│   │       │   └── index.html
│   │       └── AndroidManifest.xml
│   └── build.gradle.kts
├── .github/workflows/
│   └── build.yml
├── gradle/
│   └── wrapper/
├── build.gradle.kts
├── settings.gradle.kts
└── gradlew
```

## How to Build

### Using Android Studio

1. Open the project in Android Studio
2. Wait for Gradle sync to complete
3. Click Run > Run 'app' or press Shift+F10
4. Select an emulator or connected device

### Using Command Line

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Output locations:
# Debug: app/build/outputs/apk/debug/app-debug.apk
# Release: app/build/outputs/apk/release/app-release.apk
```

## Customizing Your HTML

Edit the HTML file at: `app/src/main/assets/index.html`

You can:
- Change the content
- Add your own CSS styles
- Include JavaScript code
- Add external resources (images, fonts, etc.)

## WebView Settings

The app is configured with:
- JavaScript enabled
- DOM storage enabled
- Database storage enabled
- File access enabled
- Zoom controls enabled
- Cache enabled

## Permissions

- `INTERNET` - Required for WebView functionality
- `ACCESS_NETWORK_STATE` - Check network connectivity

## Building with Signature

To build a signed release APK, set up these environment variables:

```bash
export KEYSTORE_PATH=release-keystore.jks
export KEYSTORE_PASSWORD=your_password
export KEY_ALIAS=your_key_alias
export KEY_PASSWORD=your_key_password
```

### Generate Keystore

```bash
keytool -genkeypair \
  -v \
  -storetype JKS \
  -keystore app-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -sigalg SHA256withRSA \
  -validity 10000 \
  -alias appkey \
  -storepass "YourPassword123!" \
  -keypass "YourPassword123!" \
  -dname "CN=Catatan Simpel, O=MyCatatan, L=City, ST=Province, C=ID"
```

## GitHub Actions

The project includes a GitHub Actions workflow for automatic builds:

- Triggers on push to main/master branch
- Builds both debug and release APKs
- Uploads artifacts with 90-day retention

## License

This project is open source and available for modification.
