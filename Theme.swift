import Cocoa

enum Theme {
    // Colors
    static let czechBlue = NSColor(red: 0.45, green: 0.7, blue: 1.0, alpha: 1.0)
    static let czechRowBg = NSColor(red: 0.0, green: 0.3, blue: 0.8, alpha: 0.08)
    static let sectionBg = NSColor(white: 0.5, alpha: 0.06)
    static let sectionHoverBg = NSColor(white: 0.5, alpha: 0.12)
    static let eventRowHoverBg = NSColor(white: 0.5, alpha: 0.05)
    static let countBadgeBg = NSColor(white: 0.5, alpha: 0.1)
    static let liveBadgeBg = NSColor.systemRed
    static let alternatingRowBg = NSColor(white: 0.5, alpha: 0.02)

    // Dimensions
    static let popoverWidth: CGFloat = 480
    static let popoverHeight: CGFloat = 560
    static let sectionHeaderHeight: CGFloat = 30
    static let eventRowCollapsed: CGFloat = 32

    // Fonts
    static let titleFont = NSFont.systemFont(ofSize: 15, weight: .bold)
    static let sportNameFont = NSFont.systemFont(ofSize: 12, weight: .semibold)
    static let eventFont = NSFont.systemFont(ofSize: 12)
    static let eventFontBold = NSFont.systemFont(ofSize: 12, weight: .semibold)
    static let timeFont = NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .medium)
    static let scoreFont = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .bold)
    static let smallFont = NSFont.systemFont(ofSize: 10)
    static let badgeFont = NSFont.systemFont(ofSize: 9, weight: .bold)
    static let disclosureFont = NSFont.systemFont(ofSize: 9, weight: .medium)
    static let disclosureSmallFont = NSFont.systemFont(ofSize: 8, weight: .medium)
    static let countFont = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .medium)
    static let emojiFont = NSFont.systemFont(ofSize: 14)
    static let filterFont = NSFont.systemFont(ofSize: 11)
    static let statusFont = NSFont.systemFont(ofSize: 9, weight: .medium)
    static let headerDateFont = NSFont.systemFont(ofSize: 12, weight: .medium)
    static let navFont = NSFont.systemFont(ofSize: 14)
    static let datePickerFont = NSFont.systemFont(ofSize: 14, weight: .medium)
    static let emptyFont = NSFont.systemFont(ofSize: 13)
    static let resultFont = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .regular)
    static let resultFontBold = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .bold)
    static let statusInfoFont = NSFont.systemFont(ofSize: 11)
    static let flagFont = NSFont.systemFont(ofSize: 12)
    static let flagSmallFont = NSFont.systemFont(ofSize: 11)
    static let todayBtnFont = NSFont.systemFont(ofSize: 11, weight: .medium)
    static let countLabelFont = NSFont.systemFont(ofSize: 11, weight: .medium)
}
