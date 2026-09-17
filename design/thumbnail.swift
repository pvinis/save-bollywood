// Draws the SaveBollywood thumbnail (a cinema ticket reading "BOLLY").
// The stubs carry Euler's number (271828), an answer to the pi (314159) on the original SaveHollywood ticket.
// Usage: swift thumbnail.swift <scale> <output.png>

import AppKit
import CoreText

let args = CommandLine.arguments
let scale = args.count > 1 ? CGFloat(Double(args[1]) ?? 1) : 1
let output = args.count > 2 ? args[2] : "thumbnail.png"
let ticketNumber = "271828"

let size = CGSize(width: 90, height: 58)

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size.width * scale), pixelsHigh: Int(size.height * scale),
                           bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                           colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
rep.size = size
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let ctx = NSGraphicsContext.current!.cgContext

let black = CGColor(gray: 0.05, alpha: 1)
let white = CGColor(gray: 0.98, alpha: 1)

// Path of a string set in a font, centered on a point

func textPath(_ string: String, fontName: String, fontSize: CGFloat, tracking: CGFloat = 0) -> CGPath {
    let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
    let attributed = NSAttributedString(string: string, attributes: [.font: font, .kern: tracking])
    let line = CTLineCreateWithAttributedString(attributed)
    let path = CGMutablePath()
    for run in CTLineGetGlyphRuns(line) as! [CTRun] {
        let runFont = (CTRunGetAttributes(run) as NSDictionary)[kCTFontAttributeName as String] as! CTFont
        let count = CTRunGetGlyphCount(run)
        var glyphs = [CGGlyph](repeating: 0, count: count)
        var positions = [CGPoint](repeating: .zero, count: count)
        CTRunGetGlyphs(run, CFRange(location: 0, length: count), &glyphs)
        CTRunGetPositions(run, CFRange(location: 0, length: count), &positions)
        for i in 0..<count {
            if let glyphPath = CTFontCreatePathForGlyph(runFont, glyphs[i], nil) {
                path.addPath(glyphPath, transform: CGAffineTransform(translationX: positions[i].x, y: positions[i].y))
            }
        }
    }
    return path
}

func centered(_ path: CGPath, at center: CGPoint, maxWidth: CGFloat? = nil, rotation: CGFloat = 0) -> CGPath {
    let box = path.boundingBoxOfPath
    var factor: CGFloat = 1
    if let maxWidth = maxWidth, box.width > maxWidth { factor = maxWidth / box.width }
    var transform = CGAffineTransform(translationX: center.x, y: center.y)
        .rotated(by: rotation)
        .scaledBy(x: factor, y: factor)
        .translatedBy(x: -box.midX, y: -box.midY)
    return path.copy(using: &transform)!
}

func star(center: CGPoint, radius: CGFloat) -> CGPath {
    let path = CGMutablePath()
    for i in 0..<10 {
        let r = i % 2 == 0 ? radius : radius * 0.4
        let angle = CGFloat.pi / 2 + CGFloat(i) * CGFloat.pi / 5
        let point = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
        if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
    }
    path.closeSubpath()
    return path
}

// The card and the ticket keep the shape of the original SaveHollywood thumbnail

// Card, with a soft shadow and a thin light line inside

let card = CGRect(x: 2, y: 3, width: 86, height: 53)

ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -1 * scale), blur: 1.5 * scale, color: CGColor(gray: 0, alpha: 0.35))
ctx.addPath(CGPath(roundedRect: card, cornerWidth: 2.5, cornerHeight: 2.5, transform: nil))
ctx.setFillColor(black)
ctx.fillPath()
ctx.restoreGState()

ctx.addPath(CGPath(roundedRect: card.insetBy(dx: 1, dy: 1), cornerWidth: 1.8, cornerHeight: 1.8, transform: nil))
ctx.setStrokeColor(CGColor(gray: 0.6, alpha: 1))
ctx.setLineWidth(0.3)
ctx.strokePath()

// Ticket: concave corners, and small notches along the short sides

let ticket = CGRect(x: 8.5, y: 10.2, width: 73, height: 37.8)
let cornerRadius: CGFloat = 6

func ticketPath(inset d: CGFloat, notches: [CGFloat], notchRadius r: CGFloat) -> CGPath {
    let x0 = ticket.minX, x1 = ticket.maxX, y0 = ticket.minY, y1 = ticket.maxY
    let rho = d == 0 ? cornerRadius : cornerRadius + d * 0.8
    let a = d == 0 ? 0 : asin(d / rho)
    let reach = (rho * rho - d * d).squareRoot()
    let path = CGMutablePath()

    path.move(to: CGPoint(x: x0 + reach, y: y1 - d))
    path.addLine(to: CGPoint(x: x1 - reach, y: y1 - d))
    path.addArc(center: CGPoint(x: x1, y: y1), radius: rho, startAngle: .pi + a, endAngle: 1.5 * .pi - a, clockwise: false)
    for y in notches.sorted(by: >) {
        path.addLine(to: CGPoint(x: x1 - d, y: y + r))
        path.addArc(center: CGPoint(x: x1 - d, y: y), radius: r, startAngle: 0.5 * .pi, endAngle: 1.5 * .pi, clockwise: false)
    }
    path.addLine(to: CGPoint(x: x1 - d, y: y0 + reach))
    path.addArc(center: CGPoint(x: x1, y: y0), radius: rho, startAngle: 0.5 * .pi + a, endAngle: .pi - a, clockwise: false)
    path.addLine(to: CGPoint(x: x0 + reach, y: y0 + d))
    path.addArc(center: CGPoint(x: x0, y: y0), radius: rho, startAngle: a, endAngle: 0.5 * .pi - a, clockwise: false)
    for y in notches.sorted(by: <) {
        path.addLine(to: CGPoint(x: x0 + d, y: y - r))
        path.addArc(center: CGPoint(x: x0 + d, y: y), radius: r, startAngle: 1.5 * .pi, endAngle: 2.5 * .pi, clockwise: false)
    }
    path.addLine(to: CGPoint(x: x0 + d, y: y1 - reach))
    path.addArc(center: CGPoint(x: x0, y: y1), radius: rho, startAngle: 1.5 * .pi + a, endAngle: 2 * .pi - a, clockwise: false)
    path.closeSubpath()
    return path
}

ctx.addPath(ticketPath(inset: 0, notches: [ticket.midY - 7, ticket.midY, ticket.midY + 7], notchRadius: 1))
ctx.setFillColor(white)
ctx.fillPath()

ctx.addPath(ticketPath(inset: 1.8, notches: [], notchRadius: 0))
ctx.setStrokeColor(black)
ctx.setLineWidth(0.45)
ctx.strokePath()

// Perforations: two columns of grey dots

let perforationOffset: CGFloat = 11
ctx.setFillColor(CGColor(gray: 0.5, alpha: 1))
for x in [ticket.minX + perforationOffset, ticket.maxX - perforationOffset] {
    var y = ticket.minY + 3.6
    while y <= ticket.maxY - 3.6 {
        ctx.fill(CGRect(x: x - 0.4, y: y - 0.4, width: 0.8, height: 0.8))
        y += 2
    }
}

// Ticket number on both stubs, the top of the digits towards the middle

ctx.setFillColor(black)
ctx.addPath(centered(textPath(ticketNumber, fontName: "DINCondensed-Bold", fontSize: 5.2, tracking: 0.3),
                     at: CGPoint(x: ticket.minX + 6.6, y: ticket.midY), rotation: -.pi / 2))
ctx.addPath(centered(textPath(ticketNumber, fontName: "DINCondensed-Bold", fontSize: 5.2, tracking: 0.3),
                     at: CGPoint(x: ticket.maxX - 6.6, y: ticket.midY), rotation: .pi / 2))
ctx.fillPath()

// Stars

for row in [ticket.midY + 10.8, ticket.midY - 10.8] {
    for i in 0..<4 {
        ctx.addPath(star(center: CGPoint(x: ticket.midX + (CGFloat(i) - 1.5) * 8.1, y: row), radius: 3.1))
    }
}
ctx.fillPath()

// BOLLY

let word = centered(textPath("BOLLY", fontName: "Phosphate-Inline", fontSize: 15, tracking: 0.4), at: CGPoint(x: ticket.midX, y: ticket.midY), maxWidth: 40)
ctx.addPath(word)
ctx.fillPath()

NSGraphicsContext.current = nil
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: output))
