# TODO

- About box: update the copyright text.
- Options sheet: every control looks disabled (greyed out) in System Settings on macOS 27, although they all work.
- Replace the thumbnail/icon. Idea: the ticket artwork from the original SaveHollywood web page (`design/holly-ticket-reference.png`, a screenshot, so low resolution), cropped or redrawn so the ticket reads "BOLLY" instead of "HOLLY". The current `thumbnail.png` is the same ticket style but says "CINEMA". Redrawing it as a vector is probably better than editing the screenshot: sharper at 2x, and it avoids reusing the original author's artwork, whose license is not stated.
- Homebrew: publish a release with a built `SaveBollywood.saver` zip and add a cask (own tap, e.g. `pvinis/homebrew-tap`) so others can `brew install --cask savebollywood`. An ad-hoc signed saver will hit Gatekeeper on other Macs, so this likely needs Developer ID signing and notarization first.
- Open an issue on packagesdev/savehollywood pointing to this fork (once it has been tested and has a release).
