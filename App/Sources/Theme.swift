import SwiftUI

/// Centralized color, typography, and spacing tokens for The Standard.
///
/// On-brand for coaching: warm off-white "paper", deep court navy ink, and a
/// bold basketball-orange accent.
enum Theme {
    // MARK: Colors
    static let accent = Color(hex: 0xE8643C)        // basketball orange
    static let accentDeep = Color(hex: 0xC24A26)
    static let ink = Color(hex: 0x14213D)           // court navy
    static let inkSoft = Color(hex: 0x3A4661)
    static let paper = Color(hex: 0xF7F4EF)         // warm off-white
    static let card = Color.white
    static let hairline = Color(hex: 0xE3DDD3)

    // MARK: Spacing
    static let pagePadding: CGFloat = 20
    static let cardRadius: CGFloat = 18
    static let cardSpacing: CGFloat = 16
}

extension Color {
    /// Convenience initializer from a 24-bit RGB hex literal (e.g. `0xE8643C`).
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}
