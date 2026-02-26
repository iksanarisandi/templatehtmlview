#!/bin/bash

# Catatan Simpel - Keystore Setup Script
# Script ini membantu generate keystore dan setup GitHub secrets

set -e

echo "=========================================="
echo "Catatan Simpel - Keystore Setup"
echo "=========================================="
echo ""

# Default values
KEYSTORE_FILE="catatan-simpel-release.jks"
KEY_ALIAS="catatankey"
KEYSTORE_PASSWORD="CatatanSimpel2025!"
KEY_PASSWORD="CatatanSimpel2025!"

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "Error: keytool not found. Please install JDK first."
    exit 1
fi

# Prompt for custom values
read -p "Keystore filename [$KEYSTORE_FILE]: " input
KEYSTORE_FILE=${input:-$KEYSTORE_FILE}

read -p "Key alias [$KEY_ALIAS]: " input
KEY_ALIAS=${input:-$KEY_ALIAS}

read -sp "Keystore password [$KEYSTORE_PASSWORD]: " input
echo ""
if [ -n "$input" ]; then
    KEYSTORE_PASSWORD=$input
fi

read -sp "Key password (same as keystore) [$KEY_PASSWORD]: " input
echo ""
if [ -n "$input" ]; then
    KEY_PASSWORD=$input
fi

echo ""
echo "Generating keystore..."
echo "=========================================="

# Generate keystore
keytool -genkeypair \
  -v \
  -storetype JKS \
  -keystore "$KEYSTORE_FILE" \
  -keyalg RSA \
  -keysize 2048 \
  -sigalg SHA256withRSA \
  -validity 10000 \
  -alias "$KEY_ALIAS" \
  -storepass "$KEYSTORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  -dname "CN=Catatan Simpel, O=MyCatatan, L=Jakarta, ST=DKI, C=ID"

echo ""
echo "=========================================="
echo "Keystore generated successfully!"
echo "=========================================="
echo ""
echo "File: $KEYSTORE_FILE"
echo "Alias: $KEY_ALIAS"
echo ""

# Check if gh CLI is available
if command -v gh &> /dev/null; then
    echo "Setting up GitHub Secrets..."
    echo "=========================================="

    # Encode keystore to base64
    BASE64_KEYSTORE=$(base64 -w 0 "$KEYSTORE_FILE")

    # Set secrets
    echo "$BASE64_KEYSTORE" | gh secret set KEYSTORE_BASE64
    echo "✓ KEYSTORE_BASE64 set"

    echo "$KEYSTORE_PASSWORD" | gh secret set KEYSTORE_PASSWORD
    echo "✓ KEYSTORE_PASSWORD set"

    echo "$KEY_ALIAS" | gh secret set KEY_ALIAS
    echo "✓ KEY_ALIAS set"

    echo "$KEY_PASSWORD" | gh secret set KEY_PASSWORD
    echo "✓ KEY_PASSWORD set"

    echo ""
    echo "=========================================="
    echo "GitHub Secrets configured successfully!"
    echo "=========================================="
else
    echo "Note: GitHub CLI not found."
    echo "Please set secrets manually:"
    echo ""
    echo "1. Encode keystore:"
    echo "   base64 -w 0 $KEYSTORE_FILE"
    echo ""
    echo "2. Set secrets on GitHub:"
    echo "   - KEYSTORE_BASE64 (output from above)"
    echo "   - KEYSTORE_PASSWORD: $KEYSTORE_PASSWORD"
    echo "   - KEY_ALIAS: $KEY_ALIAS"
    echo "   - KEY_PASSWORD: $KEY_PASSWORD"
fi

echo ""
echo "=========================================="
echo "IMPORTANT: Backup your keystore file!"
echo "=========================================="
echo "Location: $(pwd)/$KEYSTORE_FILE"
echo ""
echo "If you lose this file, you won't be able to"
echo "update your app on the Play Store!"
echo "=========================================="
