# SaveHollywood — macOS 26/27 modernization

Changes made against `packagesdev/savehollywood` master (v2.6, last upstream activity 2018)
to make the screen saver build and run correctly on macOS 27 with Xcode 27.
Tested on macOS 27.0 beta (25A5388g), Xcode 27.0 beta (27A5228h), Apple Silicon.

A machine-readable diff of every change is in `macos27-changes.patch` (`diff -ru` against
upstream master).

---

## 1. Build configuration (`SaveHollywood.xcodeproj/project.pbxproj`)

| Setting | Before | After | Why |
|---|---|---|---|
| `SDKROOT` (project level) | `macosx10.9` | `macosx` | The 10.9 SDK no longer exists; pinned SDK breaks the build immediately. |
| `MACOSX_DEPLOYMENT_TARGET` | `10.9` | `12.0` | Xcode 27 rejects deployment targets below 12.0. |
| `ARCHS` | `$(ARCHS_STANDARD_64_BIT)` | `$(ARCHS_STANDARD)` | Produces arm64. macOS 27 dropped Intel support; an x86_64-only `.saver` will not load. |
| Framework file references | absolute paths into `MacOSX10.14.sdk` | SDK-relative (`sourceTree = SDKROOT`) | The 10.14 SDK paths are stale; SDK-relative references track the active SDK. |
| `OTHER_LDFLAGS` | — | `-framework UniformTypeIdentifiers` | Needed for the `UTType`-based open-panel filter (see §3.1). |

## 2. Deprecated API modernization (mechanical, no behavior change)

* `NSOnState` / `NSOffState` → `NSControlStateValueOn` / `NSControlStateValueOff`
* `NSCompositeSourceOver` → `NSCompositingOperationSourceOver`
* `NSCenterTextAlignment` → `NSTextAlignmentCenter`
* `NSRegularControlSize` → `NSControlSizeRegular`
* `NSOKButton` / `NSFileHandlingPanelOKButton` → `NSModalResponseOK`
* `NSCalendarDate`/`yearOfCommonEra` → `NSCalendar component:fromDate:` (`SHAboutBoxWindowController.m`)
* `colorUsingColorSpaceName:` → `colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]` (`NSColor+String.m`)

## 3. Functional fixes for modern macOS

### 3.1 Folder selection broken in the open panel (`SHConfigurationWindowController.m`)

`-[NSOpenPanel setAllowedFileTypes:]` with `[AVURLAsset audiovisualTypes]` now disables
directories in the panel even with `canChooseDirectories = YES` (older macOS ignored the
filter for folders). Replaced with `allowedContentTypes` built from `UTType` objects and
explicitly including `UTTypeFolder`. This is why the UniformTypeIdentifiers framework is
now linked.

### 3.2 Drag & drop onto the assets table (`SHConfigurationWindowController.m`)

`NSFilenamesPboardType` (deprecated 10.14) replaced with `NSPasteboardTypeFileURL`.
The two `propertyListForType:` reads were replaced with
`readObjectsForClasses:@[[NSURL class]]` + `NSPasteboardURLReadingFileURLsOnlyKey`,
mapped back to paths, so the downstream path-based logic is unchanged.

### 3.3 Configure sheet would not dismiss (System Settings had to be force-quit)

`[NSApp endSheet:]` no longer dismisses a configure sheet hosted by System Settings.
`closeDialog:` now uses `[self.window.sheetParent endSheet:returnCode:]` when a sheet
parent exists, falling back to the legacy call otherwise.

### 3.4 Saver never stops after unlock (macOS 14+ `legacyScreenSaver` bug)

On macOS 14 and later the system frequently never calls `stopAnimation` on legacy screen
savers after the user unlocks; `legacyScreenSaver` keeps running and audio keeps playing
indefinitely. Workaround (same approach the Aerial project uses): on `startAnimation`
(non-preview only) subscribe to the distributed notification `com.apple.screenIsUnlocked`;
on receipt, run `stopAnimation` (which also persists the resume position) and `exit(0)`
the host process. The system respawns `legacyScreenSaver` on demand.

### 3.5 Preview instances play audio and stack up (`SaveHollywoodView.m`)

The modern host can pass `isPreview == NO` for the small System Settings preview, and it
instantiates a new saver view per settings-pane visit without stopping the old one. Result:
multiple simultaneous audio streams. Two defenses:

* Preview detection no longer trusts the flag alone: a frame ≤ 400×400 pt is treated as a
  preview. Previews are always muted and never touch persisted state.
* `viewDidMoveToWindow` pauses the player whenever the view is detached from its window,
  so leaked instances go silent even if the host never stops them.

### 3.6 Resume-from-last-position broken (`SaveHollywoodView.m`)

`screenIndex` required the saver window to be exactly contained in a screen frame
(`NSContainsRect`). The modern host's window does not match screen bounds exactly, so the
lookup returned `NSNotFound` and the resume position was silently neither saved nor
restored. The lookup now falls back to the screen with the largest intersection area, then
to screen 0.

### 3.7 Insecure/deprecated archiving of resume data (`SaveHollywoodView.m`)

* Removed the `Gestalt()` runtime version check and the `_useKeyedArchiverForLeftOffData`
  flag: with a 12.0 floor the keyed-archiver path is always available, so the
  `NSArchiver`/`NSUnarchiver` fallbacks (deprecated, insecure) were deleted along with the
  legacy `screen#` defaults key.
* Writing: `archivedDataWithRootObject:requiringSecureCoding:YES error:` — failures are
  now logged.
* Reading: `unarchivedObjectOfClasses:fromData:error:` with an allow-list of
  `NSDictionary`, `NSString`, `NSValue`, `NSURL`.
* Old keyed data written by 2.6 remains readable; pre-10.12 `NSArchiver` data is dropped
  (the resume position is transient, losing it once is harmless).

### 3.8 Preview audio (`SaveHollywoodView.m`)

Volume is now only applied when `_preview == NO`; preview playback is always muted.

## 4. Known remaining deprecation warnings (functional, left as-is)

* `-[AVAsset naturalSize]` (`SaveHollywoodView.m`) — the suggested replacement
  (`tracksWithMediaType:`) is itself deprecated in favor of the async load API; migrating
  means restructuring the (synchronous) layout path.
* `-[AVAsset loadValuesAsynchronouslyForKeys:completionHandler:]` — same situation.
* `-[NSWorkspace typeOfFile:error:]` (three sites) — replacement is
  `NSURL getResourceValue:forKey:` with `NSURLContentTypeKey`; straightforward but was out
  of scope for this pass.
* Project-file cruft reported by Xcode: duplicate xib entries in the Copy Bundle Resources
  phase, a legacy Rez build phase, and `CFBundleIdentifier` vs. empty
  `PRODUCT_BUNDLE_IDENTIFIER`.

## 5. Verification performed

* Release build succeeds with Xcode 27.0 beta / macOS 27 SDK, arm64, zero errors.
* Folder picking, drag & drop, sheet dismissal, playback, unlock shutdown, muted preview,
  and resume-from-last-position exercised manually on macOS 27.0 beta.
* Secure-coding round-trip of the resume dictionary (`NSValue`+`CMTime`, `NSURL`)
  verified with a standalone test program.
