#!/bin/sh
# Tag the current commit as v<version> and create a GitHub release with the zip
# produced by scripts/release.sh. Prints the sha256 to put in the Homebrew cask.
set -eu
cd "$(dirname "$0")/.."

VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" SaveBollywood/SaveBollywood-Info.plist)"
TAG="v$VERSION"
ZIP="build/SaveBollywood-$VERSION.zip"

[ -f "$ZIP" ] || { echo "$ZIP not found, run 'mise run release' first" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "working tree is not clean" >&2; exit 1; }

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
	echo "tag $TAG already exists" >&2
	exit 1
fi

echo "==> Tagging $TAG"
git tag -a "$TAG" -m "SaveBollywood $VERSION"
git push origin "$TAG"

echo "==> Creating release"
gh release create "$TAG" "$ZIP" --title "SaveBollywood $VERSION" --generate-notes

echo "==> Cask values"
echo "version \"$VERSION\""
echo "sha256 \"$(shasum -a 256 "$ZIP" | cut -d' ' -f1)\""
