#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

APP_NAME="CzechOlympicSchedule"
APP_BUNDLE="${APP_NAME}.app"

echo "🏔️  Building Czech Olympic Schedule..."

# Compile Swift
swiftc *.swift -o "$APP_NAME" -framework Cocoa -O -swift-version 5

# Create .app bundle structure
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Move binary
mv "$APP_NAME" "$APP_BUNDLE/Contents/MacOS/"

# Copy menu bar icon assets
cp menubar-icon.png "$APP_BUNDLE/Contents/Resources/"
cp menubar-icon@2x.png "$APP_BUNDLE/Contents/Resources/"

# Copy app icon
cp AppIcon.icns "$APP_BUNDLE/Contents/Resources/"

# Create Info.plist (LSUIElement=true hides from Dock)
cat > "$APP_BUNDLE/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>CzechOlympicSchedule</string>
    <key>CFBundleIdentifier</key>
    <string>com.czech-olympic-schedule.menubar</string>
    <key>CFBundleName</key>
    <string>Czech Olympic Schedule</string>
    <key>CFBundleDisplayName</key>
    <string>Czech Olympic Schedule – Milano Cortina 2026</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo "✅ Build complete: $APP_BUNDLE"
echo "   Run with: open $APP_BUNDLE"
