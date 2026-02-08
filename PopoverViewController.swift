import Cocoa

// MARK: - Popover Content ViewController

class PopoverViewController: NSViewController {

    private var scrollView: NSScrollView!
    private var stackView: NSStackView!
    private var datePicker: NSDatePicker!
    private var headerLabel: NSTextField!
    private var prevButton: NSButton!
    private var nextButton: NSButton!
    private var statusLabel: NSTextField!
    private var loadingSpinner: NSProgressIndicator!

    // Counter mini-badges
    private var medalBadge: NSView!
    private var czechBadge: NSView!
    private var liveBadge: NSView!
    private var medalBadgeLabel: NSTextField!
    private var czechBadgeLabel: NSTextField!
    private var liveBadgeLabel: NSTextField!

    // Filter pill buttons
    private var czechPill: NSButton!
    private var medalPill: NSButton!
    private var livePill: NSButton!

    private var sections: [SportSection] = []
    private var expandedEvents: Set<String> = []
    private var refreshTimer: Timer?
    private var isUsingAPI = false

    private var currentDate: Date = {
        let today = Date()
        let start = OlympicSchedule.startDate
        let end = OlympicSchedule.endDate
        if today >= start && today <= end { return today }
        if today < start { return start }
        return end
    }()

    override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: Theme.popoverHeight))

        let effectView = NSVisualEffectView(frame: container.bounds)
        effectView.autoresizingMask = [.width, .height]
        effectView.material = .popover
        effectView.blendingMode = .behindWindow
        effectView.state = .active
        container.addSubview(effectView)

        // MARK: Title bar (48pt)
        let titleBarHeight: CGFloat = 48
        let titleBar = NSView(frame: NSRect(x: 0, y: Theme.popoverHeight - titleBarHeight, width: Theme.popoverWidth, height: titleBarHeight))

        let olympicRings = NSTextField(labelWithString: "🏔️ ZOH 2026")
        olympicRings.font = Theme.titleFont
        olympicRings.textColor = .labelColor
        olympicRings.frame = NSRect(x: 16, y: 14, width: 140, height: 20)
        titleBar.addSubview(olympicRings)

        // Mini-badge counters (right-aligned)
        let badgeW: CGFloat = 60
        let badgeH: CGFloat = 24
        let badgeY: CGFloat = 12
        let badgeGap: CGFloat = 6
        var badgeRight: CGFloat = Theme.popoverWidth - 14

        // Live badge (rightmost, only shown when live > 0)
        let liveResult = makeBadgeView(text: "🔴 0", tintColor: Theme.liveRed.withAlphaComponent(0.12))
        liveBadge = liveResult.view
        liveBadgeLabel = liveResult.label
        liveBadge.frame = NSRect(x: badgeRight - badgeW, y: badgeY, width: badgeW, height: badgeH)
        liveBadge.isHidden = true
        titleBar.addSubview(liveBadge)

        // Czech badge
        badgeRight -= (badgeW + badgeGap)
        let czechResult = makeBadgeView(text: "🇨🇿 0", tintColor: Theme.czechBlue.withAlphaComponent(0.10))
        czechBadge = czechResult.view
        czechBadgeLabel = czechResult.label
        czechBadge.frame = NSRect(x: badgeRight - badgeW, y: badgeY, width: badgeW, height: badgeH)
        titleBar.addSubview(czechBadge)

        // Medal badge
        badgeRight -= (badgeW + badgeGap)
        let medalResult = makeBadgeView(text: "🥇 0", tintColor: Theme.medalGold.withAlphaComponent(0.12))
        medalBadge = medalResult.view
        medalBadgeLabel = medalResult.label
        medalBadge.frame = NSRect(x: badgeRight - badgeW, y: badgeY, width: badgeW, height: badgeH)
        titleBar.addSubview(medalBadge)

        let sep1 = NSBox(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 1))
        sep1.boxType = .separator
        titleBar.addSubview(sep1)
        container.addSubview(titleBar)

        // MARK: Date navigation bar (42pt)
        let dateBarHeight: CGFloat = 42
        let dateBarY = Theme.popoverHeight - titleBarHeight - dateBarHeight
        let dateBar = NSView(frame: NSRect(x: 0, y: dateBarY, width: Theme.popoverWidth, height: dateBarHeight))

        prevButton = NSButton(title: "◀", target: self, action: #selector(prevDay))
        prevButton.bezelStyle = .inline
        prevButton.font = Theme.navFont
        prevButton.frame = NSRect(x: 12, y: 7, width: 30, height: 28)
        dateBar.addSubview(prevButton)

        datePicker = NSDatePicker(frame: NSRect(x: 50, y: 7, width: 180, height: 28))
        datePicker.datePickerStyle = .textField
        datePicker.datePickerElements = .yearMonthDay
        datePicker.datePickerMode = .single
        datePicker.minDate = OlympicSchedule.startDate
        datePicker.maxDate = OlympicSchedule.endDate
        datePicker.dateValue = currentDate
        datePicker.font = Theme.datePickerFont
        datePicker.target = self
        datePicker.action = #selector(dateChanged)
        dateBar.addSubview(datePicker)

        nextButton = NSButton(title: "▶", target: self, action: #selector(nextDay))
        nextButton.bezelStyle = .inline
        nextButton.font = Theme.navFont
        nextButton.frame = NSRect(x: 238, y: 7, width: 30, height: 28)
        dateBar.addSubview(nextButton)

        headerLabel = NSTextField(labelWithString: "")
        headerLabel.font = Theme.headerDateFont
        headerLabel.textColor = .secondaryLabelColor
        headerLabel.lineBreakMode = .byTruncatingTail
        headerLabel.frame = NSRect(x: 278, y: 11, width: Theme.popoverWidth - 288, height: 20)
        dateBar.addSubview(headerLabel)

        let sep2 = NSBox(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 1))
        sep2.boxType = .separator
        dateBar.addSubview(sep2)
        container.addSubview(dateBar)

        // MARK: Filter bar (36pt) — pill-style toggle buttons
        let filterBarHeight: CGFloat = 36
        let filterBarY = dateBarY - filterBarHeight
        let filterBar = NSView(frame: NSRect(x: 0, y: filterBarY, width: Theme.popoverWidth, height: filterBarHeight))

        czechPill = makeFilterPill(title: "🇨🇿 České", tag: 100, action: #selector(toggleCzechFilter))
        czechPill.frame = NSRect(x: 14, y: 6, width: 78, height: 24)
        filterBar.addSubview(czechPill)

        medalPill = makeFilterPill(title: "🥇 Medaile", tag: 101, action: #selector(toggleMedalFilter))
        medalPill.frame = NSRect(x: 98, y: 6, width: 86, height: 24)
        filterBar.addSubview(medalPill)

        livePill = makeFilterPill(title: "🔴 Live", tag: 102, action: #selector(toggleLiveFilter))
        livePill.frame = NSRect(x: 190, y: 6, width: 64, height: 24)
        filterBar.addSubview(livePill)

        let helpLabel = NSTextField(labelWithString: "?")
        helpLabel.font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        helpLabel.textColor = .tertiaryLabelColor
        helpLabel.alignment = .center
        helpLabel.frame = NSRect(x: 262, y: 8, width: 20, height: 20)
        helpLabel.wantsLayer = true
        helpLabel.layer?.backgroundColor = NSColor(white: 0.5, alpha: 0.08).cgColor
        helpLabel.layer?.cornerRadius = 10
        helpLabel.toolTip = """
        Filtry:
        🇨🇿 České — zobrazit pouze české události
        🥇 Medaile — zobrazit pouze medailové události
        🔴 Live — zobrazit pouze probíhající události

        Ovládání:
        Klik na sport — rozbalit/sbalit sekci
        ⌥ Option + klik — rozbalit/sbalit vše
        Klik na událost — zobrazit detail a výsledky
        Dnes — přejít na aktuální den

        Stav:
        ● Online — data z olympics.com
        ○ Offline — záložní lokální data
        """
        filterBar.addSubview(helpLabel)

        statusLabel = NSTextField(labelWithString: "")
        statusLabel.font = Theme.statusFont
        statusLabel.textColor = .tertiaryLabelColor
        statusLabel.alignment = .right
        statusLabel.frame = NSRect(x: Theme.popoverWidth - 170, y: 8, width: 90, height: 16)
        filterBar.addSubview(statusLabel)

        let todayBtn = NSButton(title: "Dnes", target: self, action: #selector(goToday))
        todayBtn.bezelStyle = .inline
        todayBtn.font = Theme.todayBtnFont
        todayBtn.frame = NSRect(x: Theme.popoverWidth - 62, y: 6, width: 50, height: 24)
        filterBar.addSubview(todayBtn)

        let sep3 = NSBox(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 1))
        sep3.boxType = .separator
        filterBar.addSubview(sep3)
        container.addSubview(filterBar)

        // MARK: Scrollable event list
        let scrollAreaTop = filterBarY
        scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: scrollAreaTop))
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false

        stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 0))
        stackView.orientation = .vertical
        stackView.spacing = Theme.cardSpacing
        stackView.alignment = .leading
        stackView.edgeInsets = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)

        let clipView = FlippedClipView()
        clipView.documentView = stackView
        clipView.drawsBackground = false
        scrollView.contentView = clipView

        container.addSubview(scrollView)

        // Loading spinner
        loadingSpinner = NSProgressIndicator()
        loadingSpinner.style = .spinning
        loadingSpinner.controlSize = .small
        let spinnerSize: CGFloat = 24
        loadingSpinner.frame = NSRect(
            x: (Theme.popoverWidth - spinnerSize) / 2,
            y: (scrollAreaTop - spinnerSize) / 2,
            width: spinnerSize,
            height: spinnerSize
        )
        loadingSpinner.isHidden = true
        scrollView.addSubview(loadingSpinner)

        self.view = container

        // Set up API callbacks
        ScheduleFetcher.shared.onDataLoaded = { [weak self] units, dateKey in
            guard let self = self else { return }
            let currentKey = ScheduleFetcher.shared.dateKey(self.currentDate)
            guard dateKey == currentKey else { return }
            self.isUsingAPI = true
            let events = ScheduleFetcher.shared.convertToDisplayEvents(units)
            self.applyEvents(events)
            self.startRefreshTimerIfNeeded()
        }

        ScheduleFetcher.shared.onError = { [weak self] dateKey in
            guard let self = self else { return }
            let currentKey = ScheduleFetcher.shared.dateKey(self.currentDate)
            guard dateKey == currentKey else { return }
            self.isUsingAPI = false
            let fallbackEvents = OlympicSchedule.events(for: self.currentDate)
            let displayEvents = OlympicSchedule.toDisplayEvents(fallbackEvents)
            self.applyEvents(displayEvents)
        }

        updateEvents()
    }

    // MARK: - Badge & Pill Helpers

    private func makeBadgeView(text: String, tintColor: NSColor) -> (view: NSView, label: NSTextField) {
        let badgeHeight: CGFloat = 24
        let badge = NSView(frame: NSRect(x: 0, y: 0, width: 60, height: badgeHeight))
        badge.wantsLayer = true
        badge.layer?.backgroundColor = tintColor.cgColor
        badge.layer?.cornerRadius = 8

        let label = NSTextField(labelWithString: text)
        label.font = NSFont.systemFont(ofSize: 11.5, weight: .medium)
        label.textColor = .labelColor
        label.alignment = .center
        label.frame = NSRect(x: 0, y: 0, width: 60, height: 20)
        badge.addSubview(label)

        return (badge, label)
    }

    private func makeFilterPill(title: String, tag: Int, action: Selector) -> NSButton {
        let btn = NSButton(title: title, target: self, action: action)
        btn.bezelStyle = .smallSquare
        btn.isBordered = false
        btn.wantsLayer = true
        btn.font = Theme.filterPillFont
        btn.tag = tag
        btn.layer?.cornerRadius = 12
        btn.layer?.backgroundColor = Theme.filterInactiveBg.cgColor
        btn.contentTintColor = .secondaryLabelColor
        return btn
    }

    private func updatePillState(_ pill: NSButton, active: Bool) {
        if active {
            pill.layer?.backgroundColor = Theme.filterActiveBg.cgColor
            pill.layer?.borderWidth = 1
            pill.layer?.borderColor = Theme.filterActiveBorder.cgColor
            pill.contentTintColor = Theme.czechBlue
        } else {
            pill.layer?.backgroundColor = Theme.filterInactiveBg.cgColor
            pill.layer?.borderWidth = 0
            pill.layer?.borderColor = nil
            pill.contentTintColor = .secondaryLabelColor
        }
    }

    // MARK: - Filter Actions

    private var czechOnly = false
    private var medalOnly = false
    private var liveOnly = false

    @objc func toggleCzechFilter(_ sender: NSButton) {
        czechOnly = !czechOnly
        updatePillState(sender, active: czechOnly)
        rebuildUI()
    }

    @objc func toggleMedalFilter(_ sender: NSButton) {
        medalOnly = !medalOnly
        updatePillState(sender, active: medalOnly)
        rebuildUI()
    }

    @objc func toggleLiveFilter(_ sender: NSButton) {
        liveOnly = !liveOnly
        updatePillState(sender, active: liveOnly)
        rebuildUI()
    }

    // MARK: - Date Navigation

    @objc func dateChanged(_ sender: NSDatePicker) {
        currentDate = sender.dateValue
        updateEvents()
    }

    @objc func prevDay() {
        guard let prev = Calendar.current.date(byAdding: .day, value: -1, to: currentDate),
              prev >= OlympicSchedule.startDate else { return }
        currentDate = prev
        datePicker.dateValue = currentDate
        updateEvents()
    }

    @objc func nextDay() {
        guard let next = Calendar.current.date(byAdding: .day, value: 1, to: currentDate),
              next <= OlympicSchedule.endDate else { return }
        currentDate = next
        datePicker.dateValue = currentDate
        updateEvents()
    }

    @objc func goToday() {
        let today = Date()
        if today >= OlympicSchedule.startDate && today <= OlympicSchedule.endDate {
            currentDate = today
        } else if today < OlympicSchedule.startDate {
            currentDate = OlympicSchedule.startDate
        } else {
            currentDate = OlympicSchedule.endDate
        }
        datePicker.dateValue = currentDate
        updateEvents()
    }

    // MARK: - Data Loading

    private static let czechDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "cs_CZ")
        f.dateFormat = "EEEE d. MMMM"
        return f
    }()

    func updateEvents() {
        isUsingAPI = false
        let dayStr = Self.czechDateFormatter.string(from: currentDate)

        let cal = Calendar.current
        let dayOfMonth = cal.component(.day, from: currentDate)
        let monthOfYear = cal.component(.month, from: currentDate)
        let dayLabel: String
        if monthOfYear == 2 {
            if dayOfMonth < 6 {
                dayLabel = "Příprava"
            } else if dayOfMonth == 6 {
                dayLabel = "Zahájení"
            } else {
                dayLabel = "Den \(dayOfMonth - 6)"
            }
        } else {
            dayLabel = ""
        }
        headerLabel.stringValue = "\(dayStr) (\(dayLabel))"

        statusLabel.stringValue = "Načítání..."
        statusLabel.textColor = .tertiaryLabelColor
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(nil)

        ScheduleFetcher.shared.fetch(for: currentDate)

        let fallbackEvents = OlympicSchedule.events(for: currentDate)
        if fallbackEvents.isEmpty {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            if !self.isUsingAPI && self.sections.isEmpty {
                let displayEvents = OlympicSchedule.toDisplayEvents(fallbackEvents)
                self.applyEvents(displayEvents)
            }
        }

        prevButton.isEnabled = currentDate > OlympicSchedule.startDate
        nextButton.isEnabled = currentDate < OlympicSchedule.endDate
    }

    private var allDisplayEvents: [DisplayEvent] = []

    func applyEvents(_ events: [DisplayEvent]) {
        allDisplayEvents = events
        statusLabel.stringValue = isUsingAPI ? "● Online" : "○ Offline"
        statusLabel.textColor = isUsingAPI ? .systemGreen : .secondaryLabelColor
        loadingSpinner.stopAnimation(nil)
        loadingSpinner.isHidden = true
        rebuildUI(resetScroll: true)
    }

    // MARK: - UI Rebuild

    func rebuildUI(resetScroll: Bool = false) {
        var events = allDisplayEvents

        if czechOnly {
            events = events.filter { $0.hasCzech }
        }
        if medalOnly {
            events = events.filter { $0.isMedal }
        }
        if liveOnly {
            events = events.filter { $0.isLive }
        }

        // Update counter badges
        let medalCount = allDisplayEvents.filter { $0.isMedal }.count
        let czechCount = allDisplayEvents.filter { $0.hasCzech }.count
        let liveCount = allDisplayEvents.filter { $0.isLive }.count

        medalBadgeLabel.stringValue = "🥇 \(medalCount)"
        czechBadgeLabel.stringValue = "🇨🇿 \(czechCount)"
        liveBadgeLabel.stringValue = "🔴 \(liveCount)"
        liveBadge.isHidden = liveCount == 0

        // Reposition badges based on live visibility
        let rbBadgeW: CGFloat = 60
        let rbBadgeGap: CGFloat = 6
        let rbBadgeY: CGFloat = 12
        var rbRight: CGFloat = Theme.popoverWidth - 14

        if liveCount > 0 {
            liveBadge.frame.origin = NSPoint(x: rbRight - rbBadgeW, y: rbBadgeY)
            rbRight -= (rbBadgeW + rbBadgeGap)
        }
        czechBadge.frame.origin = NSPoint(x: rbRight - rbBadgeW, y: rbBadgeY)
        rbRight -= (rbBadgeW + rbBadgeGap)
        medalBadge.frame.origin = NSPoint(x: rbRight - rbBadgeW, y: rbBadgeY)

        // Remember expanded state
        var expandedState: [String: Bool] = [:]
        for s in sections {
            expandedState[s.name] = s.isExpanded
        }

        let savedScroll = scrollView.contentView.bounds.origin

        sections = ScheduleFetcher.shared.groupBySport(events)

        for i in 0..<sections.count {
            if let wasExpanded = expandedState[sections[i].name] {
                sections[i].isExpanded = wasExpanded
            }
        }

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let contentWidth = Theme.popoverWidth - 12  // account for edge insets

        if events.isEmpty {
            let emptyLabel = NSTextField(labelWithString: czechOnly || medalOnly || liveOnly ? "Žádné odpovídající události" : "Žádné události tento den")
            emptyLabel.font = Theme.emptyFont
            emptyLabel.textColor = .tertiaryLabelColor
            emptyLabel.alignment = .center
            emptyLabel.frame = NSRect(x: 0, y: 0, width: contentWidth, height: 40)
            stackView.addArrangedSubview(emptyLabel)
        } else {
            var totalHeight: CGFloat = 12  // top padding
            for (sectionIndex, section) in sections.enumerated() {
                // Section spacing between groups
                if sectionIndex > 0 {
                    let spacer = NSView(frame: NSRect(x: 0, y: 0, width: contentWidth, height: Theme.sectionSpacing))
                    spacer.translatesAutoresizingMaskIntoConstraints = false
                    spacer.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
                    spacer.heightAnchor.constraint(equalToConstant: Theme.sectionSpacing).isActive = true
                    stackView.addArrangedSubview(spacer)
                    totalHeight += Theme.sectionSpacing + Theme.cardSpacing
                }

                let header = SportSectionHeaderView(section: section, width: contentWidth)
                header.translatesAutoresizingMaskIntoConstraints = false
                header.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
                header.heightAnchor.constraint(equalToConstant: Theme.sectionHeaderHeight).isActive = true
                let idx = sectionIndex
                header.onToggle = { [weak self] in
                    guard let self = self else { return }
                    self.sections[idx].isExpanded = !self.sections[idx].isExpanded
                    self.rebuildUI()
                }
                header.onToggleAll = { [weak self] expand in
                    guard let self = self else { return }
                    for i in 0..<self.sections.count {
                        self.sections[i].isExpanded = expand
                    }
                    if !expand { self.expandedEvents.removeAll() }
                    self.rebuildUI()
                }
                stackView.addArrangedSubview(header)
                totalHeight += Theme.sectionHeaderHeight + Theme.cardSpacing

                if section.isExpanded {
                    for (eventIndex, event) in section.events.enumerated() {
                        let isEventExpanded = expandedEvents.contains(event.id)
                        let rowHeight = EventRowView.height(for: event, expanded: isEventExpanded)
                        let row = EventRowView(event: event, width: contentWidth, expanded: isEventExpanded, rowIndex: eventIndex)
                        row.translatesAutoresizingMaskIntoConstraints = false
                        row.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
                        row.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
                        let eventId = event.id
                        row.onToggle = { [weak self] in
                            guard let self = self else { return }
                            if self.expandedEvents.contains(eventId) {
                                self.expandedEvents.remove(eventId)
                            } else {
                                self.expandedEvents.insert(eventId)
                            }
                            self.rebuildUI()
                        }
                        stackView.addArrangedSubview(row)
                        totalHeight += rowHeight + Theme.cardSpacing
                    }
                }
            }
            totalHeight += 12  // bottom padding

            stackView.frame = NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: totalHeight)
        }

        if resetScroll {
            scrollView.contentView.scroll(to: NSPoint(x: 0, y: 0))
            scrollView.reflectScrolledClipView(scrollView.contentView)
        } else {
            scrollView.contentView.scroll(to: savedScroll)
            scrollView.reflectScrolledClipView(scrollView.contentView)
        }
    }

    // MARK: - Refresh Timer

    func startRefreshTimerIfNeeded() {
        refreshTimer?.invalidate()
        let hasLive = allDisplayEvents.contains { $0.isLive || $0.status == .running }
        if hasLive {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                ScheduleFetcher.shared.fetch(for: self.currentDate, forceRefresh: true)
            }
        }
    }

    func stopRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    deinit {
        stopRefreshTimer()
    }
}
