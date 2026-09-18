SaveBollywood
=============

A video screen saver for macOS 26+. It plays your own movie files as a screen saver.

This is a fork of [SaveHollywood](https://github.com/packagesdev/savehollywood) by Stéphane Sudre, which is no longer maintained and only ships as an Intel binary. It builds on the fixes from [miikememe's PR #29](https://github.com/packagesdev/savehollywood/pull/29). It uses its own bundle identifier (`com.pvinis.SaveBollywood`) and class names, so it can be installed next to the original.

## Install

	brew install --cask pvinis/pvinis/savebollywood

Then pick SaveBollywood in System Settings > Wallpaper > Screen Saver. Or download `SaveBollywood-<version>.zip` from the [releases](https://github.com/pvinis/savebollywood/releases), unzip it and double-click the saver.

## Build from source

	mise run install

or build with `mise run build` and double-click `build/Release/SaveBollywood.saver`.

## Release

	mise run release
	mise run publish

`release` builds with Developer ID signing, notarizes and staples the saver and zips it into `build/`. `publish` tags `v<version>`, creates the GitHub release with the zip and prints the values for the cask in [pvinis/homebrew-pvinis](https://github.com/pvinis/homebrew-pvinis). The version comes from `CFBundleShortVersionString` in `SaveBollywood-Info.plist`.

## Where to put videos

macOS runs third-party screen savers in a sandboxed host (`legacyScreenSaver`) that can not show privacy prompts. Add videos with the + button or by dragging them into the list in Options: a security-scoped bookmark is stored for each entry so the saver can read it again later. If the saver shows "No readable videos", move the videos to `/Users/Shared` and add them again.

## Changes from SaveHollywood 2.6

- Universal build, macOS 26 minimum, notarized releases, no deprecated API left.
- Open panel, drag and drop, and closing the Options sheet work in System Settings again.
- The host process exits shortly after the saver is dismissed (`com.apple.screensaver.willstop` and `com.apple.screenIsUnlocked`), so audio no longer keeps playing in the background.
- Previews are always muted; main display detection and resume-where-left-off work with the modern host.
- Security-scoped bookmarks for the configured videos and folders.

The code still uses manual reference counting.

## Credits

- Pavlos Vinieratos: SaveBollywood.
- [Stéphane Sudre](http://s.sudre.free.fr/Software/SaveHollywood/about.html): the original SaveHollywood.
- [miikememe](https://github.com/miikememe): the fixes for current macOS from [PR #29](https://github.com/packagesdev/savehollywood/pull/29).

Licensed under the BSD 3-Clause license, see `LICENSE`.
