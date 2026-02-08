import Cocoa

enum Theme {
    // MARK: - Colors
    static let czechBlue = NSColor(red: 0.30, green: 0.60, blue: 1.0, alpha: 1.0)
    static let czechRowBg = NSColor(red: 0.20, green: 0.50, blue: 1.0, alpha: 0.07)
    static let sectionBg = NSColor(white: 0.5, alpha: 0.04)
    static let sectionHoverBg = NSColor(white: 0.5, alpha: 0.10)
    static let eventRowHoverBg = NSColor(white: 0.5, alpha: 0.05)
    static let countBadgeBg = NSColor(white: 0.5, alpha: 0.08)
    static let liveBadgeBg = NSColor.systemRed
    static let filterActiveBg = NSColor(red: 0.30, green: 0.60, blue: 1.0, alpha: 0.15)
    static let filterActiveBorder = NSColor(red: 0.30, green: 0.60, blue: 1.0, alpha: 0.4)
    static let filterInactiveBg = NSColor(white: 0.5, alpha: 0.06)
    static let medalGold = NSColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
    static let liveRed = NSColor.systemRed

    // MARK: - Dimensions
    static let popoverWidth: CGFloat = 520
    static let popoverHeight: CGFloat = 600
    static let sectionHeaderHeight: CGFloat = 36
    static let eventRowCollapsed: CGFloat = 38
    static let cardCornerRadius: CGFloat = 8
    static let cardSpacing: CGFloat = 2
    static let sectionSpacing: CGFloat = 8

    // MARK: - Fonts
    static let titleFont = NSFont.systemFont(ofSize: 14, weight: .semibold)
    static let sportNameFont = NSFont.systemFont(ofSize: 12.5, weight: .semibold)
    static let eventFont = NSFont.systemFont(ofSize: 11.5)
    static let eventFontBold = NSFont.systemFont(ofSize: 11.5, weight: .semibold)
    static let timeFont = NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)
    static let scoreFont = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .bold)
    static let smallFont = NSFont.systemFont(ofSize: 10)
    static let badgeFont = NSFont.systemFont(ofSize: 9, weight: .bold)
    static let countFont = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .medium)
    static let emojiFont = NSFont.systemFont(ofSize: 14)
    static let filterPillFont = NSFont.systemFont(ofSize: 11, weight: .medium)
    static let counterFont = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .semibold)
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
    static let sectionEmojiFont = NSFont.systemFont(ofSize: 15)
}
