# Design

- `thumbnail.swift` draws the screen saver thumbnail. Regenerate both sizes with:

      swift design/thumbnail.swift 1 SaveBollywood/thumbnail.png
      swift design/thumbnail.swift 2 SaveBollywood/thumbnail@2x.png

  It needs the Phosphate and DIN Condensed fonts that ship with macOS.
- `logo.png` is the same drawing at 8x, used in the top-level README. `social-preview.png` is it centered on a 1280x640 dark canvas, uploaded as the repository's social preview in the GitHub settings. Regenerate with:

      swift design/thumbnail.swift 8 design/logo.png
      magick -size 1280x640 "xc:rgb(13,13,13)" design/logo.png -gravity center -composite design/social-preview.png
- `holly-ticket-reference.png` is a screenshot of the ticket on the original SaveHollywood web page, kept as a style reference.
