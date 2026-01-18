#!/bin/bash
set -e

echo "=========================================="
echo " Flutter CI / CD & Deployment Script"
echo "=========================================="

# 1) Install dependencies
flutter pub get

# 2) Clean previous builds
flutter clean

# 3) Run tests
echo "Running all tests..."
flutter test

# 4) Build APK (Staging & Production)
echo "Building Staging APK..."
flutter build apk --flavor staging -t lib/main.dart --debug

echo "Building Production APK..."
flutter build apk --flavor prod -t lib/main.dart --release

# 5) Build App Bundle (AAB)
echo "Building Android App Bundle..."
flutter build appbundle --release --flavor prod -t lib/main.dart

# 6) iOS Integration (if macOS runner)
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building iOS..."
  flutter build ios --release
fi

echo "=========================================="
echo " CI/CD Script Completed Successfully"
echo "=========================================="
