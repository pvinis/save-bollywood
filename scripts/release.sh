#!/bin/sh
# Build a Developer ID signed, notarized, stapled SaveBollywood.saver and zip it
# into build/SaveBollywood-<version>.zip.
#
# One-time setup:
#   - A "Developer ID Application" certificate for the team below in the keychain.
#   - xcrun notarytool store-credentials "$NOTARY_PROFILE" --apple-id <id> --team-id "$TEAM_ID" --password <app-specific password>
set -eu
cd "$(dirname "$0")/.."

TEAM_ID="${TEAM_ID:-CAG2W9M777}"
NOTARY_PROFILE="${NOTARY_PROFILE:-savebollywood}"

VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" SaveBollywood/SaveBollywood-Info.plist)"
SAVER="build/Release/SaveBollywood.saver"
ZIP="build/SaveBollywood-$VERSION.zip"

echo "==> Building $VERSION"
xcodebuild -project SaveBollywood.xcodeproj -target SaveBollywood -configuration Release \
	SYMROOT="$PWD/build" OBJROOT="$PWD/build/obj" \
	CODE_SIGN_STYLE=Manual \
	CODE_SIGN_IDENTITY="Developer ID Application" \
	DEVELOPMENT_TEAM="$TEAM_ID" \
	OTHER_CODE_SIGN_FLAGS="--timestamp" \
	build -quiet

codesign --verify --deep --strict "$SAVER"

echo "==> Notarizing"
rm -f "$ZIP"
ditto -c -k --keepParent "$SAVER" "$ZIP"
xcrun notarytool submit "$ZIP" --keychain-profile "$NOTARY_PROFILE" --wait

echo "==> Stapling"
xcrun stapler staple "$SAVER"
xcrun stapler validate "$SAVER"

# The zip must contain the stapled bundle.
rm -f "$ZIP"
ditto -c -k --keepParent "$SAVER" "$ZIP"

echo "==> $ZIP"
shasum -a 256 "$ZIP"
