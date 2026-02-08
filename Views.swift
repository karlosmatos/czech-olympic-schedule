import Cocoa

// MARK: - NSView Hover Tracking Extension

extension NSView {
    func setupHoverTracking() {
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeInActiveApp],
            owner: self,
            userInfo: nil
        ))
    }
}

// MARK: - Flipped Clip View (top-aligned content)

class FlippedClipView: NSClipView {
    override var isFlipped: Bool { true }
}

// MARK: - Sport Section Header View (Accordion)

class SportSectionHeaderView: NSView {
    var onToggle: (() -> Void)?
    var onToggleAll: ((Bool) -> Void)?  // Option-click: expand/collapse all
    private var isExpanded: Bool
    private let disclosureLabel: NSTextField

    init(section: SportSection, width: CGFloat) {
        self.isExpanded = section.isExpanded
        self.disclosureLabel = NSTextField(labelWithString: isExpanded ? "▾" : "▸")

        super.init(frame: NSRect(x: 0, y: 0, width: width, height: Theme.sectionHeaderHeight))

        wantsLayer = true
        layer?.backgroundColor = Theme.sectionBg.cgColor
        layer?.cornerRadius = Theme.cardCornerRadius

        disclosureLabel.font = NSFont.systemFont(ofSize: 10, weight: .medium)
        disclosureLabel.textColor = .tertiaryLabelColor
        disclosureLabel.frame = NSRect(x: 12, y: 9, width: 14, height: 18)
        addSubview(disclosureLabel)

        let emojiLabel = NSTextField(labelWithString: section.emoji)
        emojiLabel.font = Theme.sectionEmojiFont
        emojiLabel.frame = NSRect(x: 28, y: 7, width: 22, height: 22)
        addSubview(emojiLabel)

        let nameLabel = NSTextField(labelWithString: section.name)
        nameLabel.font = Theme.sportNameFont
        nameLabel.textColor = section.hasCzech ? Theme.czechBlue : .labelColor
        nameLabel.frame = NSRect(x: 54, y: 9, width: 200, height: 18)
        addSubview(nameLabel)

        // Right-side badges: laid out right-to-left
        var rightEdge: CGFloat = width - 12

        if section.hasLive {
            let liveWidth: CGFloat = 36
            rightEdge -= liveWidth
            let liveLabel = NSTextField(labelWithString: "LIVE")
            liveLabel.font = Theme.badgeFont
            liveLabel.textColor = .white
            liveLabel.alignment = .center
            liveLabel.frame = NSRect(x: rightEdge, y: 9, width: liveWidth, height: 18)
            liveLabel.wantsLayer = true
            liveLabel.layer?.backgroundColor = Theme.liveBadgeBg.cgColor
            liveLabel.layer?.cornerRadius = 5
            addSubview(liveLabel)

            let pulse = CABasicAnimation(keyPath: "opacity")
            pulse.fromValue = 1.0
            pulse.toValue = 0.4
            pulse.duration = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            liveLabel.layer?.add(pulse, forKey: "pulse")
            rightEdge -= 6
        }

        if section.hasCzech {
            let flagWidth: CGFloat = 20
            rightEdge -= flagWidth
            let flagLabel = NSTextField(labelWithString: "🇨🇿")
            flagLabel.font = Theme.flagSmallFont
            flagLabel.frame = NSRect(x: rightEdge, y: 9, width: flagWidth, height: 18)
            addSubview(flagLabel)
            rightEdge -= 6
        }

        let countWidth: CGFloat = 26
        rightEdge -= countWidth
        let countLabel = NSTextField(labelWithString: "\(section.events.count)")
        countLabel.font = Theme.countFont
        countLabel.textColor = .tertiaryLabelColor
        countLabel.alignment = .center
        countLabel.frame = NSRect(x: rightEdge, y: 9, width: countWidth, height: 18)
        countLabel.wantsLayer = true
        countLabel.layer?.backgroundColor = Theme.countBadgeBg.cgColor
        countLabel.layer?.cornerRadius = 5
        addSubview(countLabel)

        let click = NSClickGestureRecognizer(target: self, action: #selector(handleClick))
        addGestureRecognizer(click)
    }

    @objc func handleClick(_ gesture: NSClickGestureRecognizer) {
        let optionHeld = NSEvent.modifierFlags.contains(.option)
        if optionHeld {
            isExpanded = !isExpanded
            disclosureLabel.stringValue = isExpanded ? "▾" : "▸"
            onToggleAll?(isExpanded)
        } else {
            isExpanded = !isExpanded
            disclosureLabel.stringValue = isExpanded ? "▾" : "▸"
            onToggle?()
        }
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        setupHoverTracking()
    }

    override func mouseEntered(with event: NSEvent) {
        layer?.backgroundColor = Theme.sectionHoverBg.cgColor
    }

    override func mouseExited(with event: NSEvent) {
        layer?.backgroundColor = Theme.sectionBg.cgColor
    }

    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Event Row View (Card-style Accordion)

class EventRowView: NSView {
    var onToggle: (() -> Void)?
    private var defaultBgColor: CGColor = NSColor.clear.cgColor

    static func height(for event: DisplayEvent, expanded: Bool) -> CGFloat {
        if !expanded { return Theme.eventRowCollapsed }
        let base = Theme.eventRowCollapsed
        if event.isH2H && event.competitors.count >= 2 {
            return base + 44
        } else if !event.competitors.isEmpty {
            let rows = min(event.competitors.count, 5)
            return base + CGFloat(rows) * 18 + 8
        } else {
            return base + 26
        }
    }

    init(event: DisplayEvent, width: CGFloat, expanded: Bool, rowIndex: Int = 0) {
        let rowHeight = EventRowView.height(for: event, expanded: expanded)
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: rowHeight))

        wantsLayer = true
        layer?.cornerRadius = 6
        let isCzech = event.hasCzech

        if isCzech {
            defaultBgColor = Theme.czechRowBg.cgColor
            layer?.backgroundColor = defaultBgColor
        }

        let topY = rowHeight - Theme.eventRowCollapsed

        // Disclosure triangle
        let disclosureLabel = NSTextField(labelWithString: expanded ? "▾" : "▸")
        disclosureLabel.font = NSFont.systemFont(ofSize: 8, weight: .medium)
        disclosureLabel.textColor = .tertiaryLabelColor
        disclosureLabel.frame = NSRect(x: 14, y: topY + 11, width: 10, height: 16)
        addSubview(disclosureLabel)

        // Status indicator
        let statusStr: String
        let statusColor: NSColor
        switch event.status {
        case .running:
            statusStr = "●"
            statusColor = .systemRed
        case .finished:
            statusStr = "✓"
            statusColor = .systemGreen
        case .scheduled:
            statusStr = "○"
            statusColor = .tertiaryLabelColor
        }

        let statusLabel = NSTextField(labelWithString: statusStr)
        statusLabel.font = NSFont.systemFont(ofSize: event.status == .running ? 9 : 10, weight: .bold)
        statusLabel.textColor = statusColor
        statusLabel.frame = NSRect(x: 26, y: topY + 11, width: 14, height: 16)
        statusLabel.wantsLayer = true
        addSubview(statusLabel)

        // Pulsing animation for live events
        if event.status == .running {
            let pulse = CABasicAnimation(keyPath: "opacity")
            pulse.fromValue = 1.0
            pulse.toValue = 0.3
            pulse.duration = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            statusLabel.layer?.add(pulse, forKey: "pulse")
        }

        // Time
        let timeLabel = NSTextField(labelWithString: event.time.isEmpty ? "     " : event.time)
        timeLabel.font = Theme.timeFont
        timeLabel.textColor = event.status == .running ? .systemRed : .secondaryLabelColor
        timeLabel.frame = NSRect(x: 40, y: topY + 10, width: 42, height: 18)
        addSubview(timeLabel)

        let medalStr = event.isMedal ? "🥇 " : ""
        let livePrefix = event.isLive ? "LIVE  " : ""
        let detailStartX: CGFloat = 84

        let summaryStr = "\(medalStr)\(livePrefix)\(event.detail)"
        let summaryLabel = NSTextField(labelWithString: summaryStr)
        summaryLabel.font = isCzech ? Theme.eventFontBold : Theme.eventFont
        summaryLabel.textColor = isCzech ? Theme.czechBlue : .labelColor
        summaryLabel.lineBreakMode = .byTruncatingTail
        summaryLabel.frame = NSRect(x: detailStartX, y: topY + 10, width: width - detailStartX - 36, height: 18)
        summaryLabel.toolTip = event.detail
        addSubview(summaryLabel)

        if isCzech {
            let flagLabel = NSTextField(labelWithString: "🇨🇿")
            flagLabel.font = Theme.flagFont
            flagLabel.frame = NSRect(x: width - 30, y: topY + 10, width: 22, height: 18)
            addSubview(flagLabel)
        }

        // Expanded detail area
        if expanded {
            let detailY: CGFloat = 6

            // Subtle top border for expanded content
            let borderLine = NSView(frame: NSRect(x: detailStartX, y: rowHeight - Theme.eventRowCollapsed, width: width - detailStartX - 16, height: 1))
            borderLine.wantsLayer = true
            borderLine.layer?.backgroundColor = NSColor(white: 0.5, alpha: 0.08).cgColor
            addSubview(borderLine)

            if event.isH2H && event.competitors.count >= 2 {
                let c1 = event.competitors[0]
                let c2 = event.competitors[1]
                let score1 = c1.score.isEmpty ? "-" : c1.score
                let score2 = c2.score.isEmpty ? "-" : c2.score
                let w1 = c1.isWinner ? " ✓" : ""
                let w2 = c2.isWinner ? " ✓" : ""

                let scoreStr = "   \(c1.noc)\(w1)   \(score1)  :  \(score2)   \(c2.noc)\(w2)"
                let scoreLabel = NSTextField(labelWithString: scoreStr)
                scoreLabel.font = Theme.scoreFont
                scoreLabel.textColor = .labelColor
                scoreLabel.frame = NSRect(x: detailStartX, y: detailY + 18, width: width - detailStartX - 16, height: 20)
                addSubview(scoreLabel)

                let namesStr = "   \(c1.name)  vs  \(c2.name)"
                let namesLabel = NSTextField(labelWithString: namesStr)
                namesLabel.font = Theme.smallFont
                namesLabel.textColor = .secondaryLabelColor
                namesLabel.lineBreakMode = .byTruncatingTail
                namesLabel.frame = NSRect(x: detailStartX, y: detailY, width: width - detailStartX - 16, height: 16)
                addSubview(namesLabel)

            } else if !event.competitors.isEmpty {
                let topN = event.competitors.prefix(5)
                for (i, c) in topN.enumerated() {
                    let posDisplay = c.position.isEmpty ? "\(i + 1)." : "\(c.position)."
                    let mark = c.score.isEmpty ? "" : "  \(c.score)"
                    let rowStr = "   \(posDisplay) \(c.noc)  \(c.name)\(mark)"

                    let rowLabel = NSTextField(labelWithString: rowStr)
                    rowLabel.font = i == 0 ? Theme.resultFontBold : Theme.resultFont
                    rowLabel.textColor = c.noc == "CZE" ? Theme.czechBlue : .secondaryLabelColor
                    rowLabel.lineBreakMode = .byTruncatingTail
                    let yPos = detailY + CGFloat(topN.count - 1 - i) * 18
                    rowLabel.frame = NSRect(x: detailStartX, y: yPos, width: width - detailStartX - 16, height: 16)
                    addSubview(rowLabel)
                }
            } else {
                let statusText: String
                switch event.status {
                case .scheduled: statusText = "   Naplánováno na \(event.time)"
                case .running: statusText = "   Probíhá"
                case .finished: statusText = "   Dokončeno"
                }
                let infoLabel = NSTextField(labelWithString: statusText)
                infoLabel.font = Theme.statusInfoFont
                infoLabel.textColor = .secondaryLabelColor
                infoLabel.frame = NSRect(x: detailStartX, y: detailY + 2, width: width - detailStartX - 16, height: 16)
                addSubview(infoLabel)
            }
        }

        let click = NSClickGestureRecognizer(target: self, action: #selector(handleClick))
        addGestureRecognizer(click)
    }

    @objc func handleClick() {
        onToggle?()
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        setupHoverTracking()
    }

    override func mouseEntered(with event: NSEvent) {
        layer?.backgroundColor = Theme.eventRowHoverBg.cgColor
    }

    override func mouseExited(with event: NSEvent) {
        layer?.backgroundColor = defaultBgColor
    }

    required init?(coder: NSCoder) { fatalError() }
}
