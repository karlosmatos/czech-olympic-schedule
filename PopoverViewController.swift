import Cocoa

// MARK: - Popover Content ViewController

class PopoverViewController: NSViewController {

    private var scrollView: NSScrollView!
    private var stackView: NSStackView!
    private var datePicker: NSDatePicker!
    private var headerLabel: NSTextField!
    private var countLabel: NSTextField!
    private var prevButton: NSButton!
    private var nextButton: NSButton!
    private var statusLabel: NSTextField!
    private var loadingSpinner: NSProgressIndicator!

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

        // Title bar
        let titleBar = NSView(frame: NSRect(x: 0, y: Theme.popoverHeight - 50, width: Theme.popoverWidth, height: 50))

        let olympicRings = NSTextField(labelWithString: "🏔️ ZOH Milano Cortina 2026")
        olympicRings.font = Theme.titleFont
        olympicRings.textColor = .labelColor
        olympicRings.frame = NSRect(x: 14, y: 14, width: 280, height: 22)
        titleBar.addSubview(olympicRings)

        countLabel = NSTextField(labelWithString: "")
        countLabel.font = Theme.countLabelFont
        countLabel.textColor = .secondaryLabelColor
        countLabel.alignment = .right
        countLabel.frame = NSRect(x: Theme.popoverWidth - 200, y: 14, width: 186, height: 18)
        titleBar.addSubview(countLabel)

        let sep1 = NSBox(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 1))
        sep1.boxType = .separator
        titleBar.addSubview(sep1)
        container.addSubview(titleBar)

        // Date navigation bar
        let dateBar = NSView(frame: NSRect(x: 0, y: Theme.popoverHeight - 96, width: Theme.popoverWidth, height: 46))

        prevButton = NSButton(title: "◀", target: self, action: #selector(prevDay))
        prevButton.bezelStyle = .inline
        prevButton.font = Theme.navFont
        prevButton.frame = NSRect(x: 10, y: 8, width: 30, height: 28)
        dateBar.addSubview(prevButton)

        datePicker = NSDatePicker(frame: NSRect(x: 48, y: 8, width: 180, height: 28))
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
        nextButton.frame = NSRect(x: 234, y: 8, width: 30, height: 28)
        dateBar.addSubview(nextButton)

        headerLabel = NSTextField(labelWithString: "")
        headerLabel.font = Theme.headerDateFont
        headerLabel.textColor = .secondaryLabelColor
        headerLabel.frame = NSRect(x: 274, y: 12, width: Theme.popoverWidth - 284, height: 20)
        dateBar.addSubview(headerLabel)

        let sep2 = NSBox(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 1))
        sep2.boxType = .separator
        dateBar.addSubview(sep2)
        container.addSubview(dateBar)

        // Filter buttons + status
        let filterBar = NSView(frame: NSRect(x: 0, y: Theme.popoverHeight - 130, width: Theme.popoverWidth, height: 34))

        let czechFilter = NSButton(checkboxWithTitle: "🇨🇿 Jen české", target: self, action: #selector(toggleCzechFilter))
        czechFilter.font = Theme.filterFont
        czechFilter.frame = NSRect(x: 14, y: 6, width: 110, height: 20)
        czechFilter.tag = 100
        filterBar.addSubview(czechFilter)

        let medalFilter = NSButton(checkboxWithTitle: "🥇 Jen medaile", target: self, action: #selector(toggleMedalFilter))
        medalFilter.font = Theme.filterFont
        medalFilter.frame = NSRect(x: 130, y: 6, width: 120, height: 20)
        medalFilter.tag = 101
        filterBar.addSubview(medalFilter)

        statusLabel = NSTextField(labelWithString: "")
        statusLabel.font = Theme.statusFont
        statusLabel.textColor = .tertiaryLabelColor
        statusLabel.alignment = .right
        statusLabel.frame = NSRect(x: Theme.popoverWidth - 160, y: 8, width: 90, height: 14)
        filterBar.addSubview(statusLabel)

        let todayBtn = NSButton(title: "Dnes", target: self, action: #selector(goToday))
        todayBtn.bezelStyle = .inline
        todayBtn.font = Theme.todayBtnFont
        todayBtn.frame = NSRect(x: Theme.popoverWidth - 60, y: 5, width: 48, height: 22)
        filterBar.addSubview(todayBtn)

        let sep3 = NSBox(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 1))
        sep3.boxType = .separator
        filterBar.addSubview(sep3)
        container.addSubview(filterBar)

        // Scrollable event list
        let scrollAreaHeight = Theme.popoverHeight - 130
        scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: scrollAreaHeight))
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false

        stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 0))
        stackView.orientation = .vertical
        stackView.spacing = 1
        stackView.alignment = .leading

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
            y: (scrollAreaHeight - spinnerSize) / 2,
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

    private var czechOnly = false
    private var medalOnly = false

    @objc func toggleCzechFilter(_ sender: NSButton) {
        czechOnly = sender.state == .on
        rebuildUI()
    }

    @objc func toggleMedalFilter(_ sender: NSButton) {
        medalOnly = sender.state == .on
        rebuildUI()
    }

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

    func updateEvents() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "cs_CZ")
        formatter.dateFormat = "EEEE d. MMMM"
        let dayStr = formatter.string(from: currentDate)

        // Olympic Day numbering: Feb 6 = Opening, Feb 7 = Day 1
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

        // Show loading state
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

    func rebuildUI(resetScroll: Bool = false) {
        var events = allDisplayEvents

        if czechOnly {
            events = events.filter { $0.hasCzech }
        }
        if medalOnly {
            events = events.filter { $0.isMedal }
        }

        let medalCount = allDisplayEvents.filter { $0.isMedal }.count
        let czechCount = allDisplayEvents.filter { $0.hasCzech }.count
        let liveCount = allDisplayEvents.filter { $0.isLive }.count
        var countStr = "🥇 \(medalCount) medailí  🇨🇿 \(czechCount) českých"
        if liveCount > 0 {
            countStr += "  🔴 \(liveCount) live"
        }
        countLabel.stringValue = countStr

        // Remember expanded state
        var expandedState: [String: Bool] = [:]
        for s in sections {
            expandedState[s.name] = s.isExpanded
        }

        // Save scroll position before rebuild
        let savedScroll = scrollView.contentView.bounds.origin

        sections = ScheduleFetcher.shared.groupBySport(events)

        for i in 0..<sections.count {
            if let wasExpanded = expandedState[sections[i].name] {
                sections[i].isExpanded = wasExpanded
            }
        }

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if events.isEmpty {
            let emptyLabel = NSTextField(labelWithString: czechOnly || medalOnly ? "Žádné odpovídající události" : "Žádné události tento den")
            emptyLabel.font = Theme.emptyFont
            emptyLabel.textColor = .tertiaryLabelColor
            emptyLabel.alignment = .center
            emptyLabel.frame = NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: 40)
            stackView.addArrangedSubview(emptyLabel)
        } else {
            var totalHeight: CGFloat = 0
            for (sectionIndex, section) in sections.enumerated() {
                let header = SportSectionHeaderView(section: section, width: Theme.popoverWidth - 8)
                header.translatesAutoresizingMaskIntoConstraints = false
                header.widthAnchor.constraint(equalToConstant: Theme.popoverWidth - 8).isActive = true
                header.heightAnchor.constraint(equalToConstant: Theme.sectionHeaderHeight).isActive = true
                let idx = sectionIndex
                header.onToggle = { [weak self] in
                    guard let self = self else { return }
                    self.sections[idx].isExpanded = !self.sections[idx].isExpanded
                    self.rebuildUI()
                }
                stackView.addArrangedSubview(header)
                totalHeight += Theme.sectionHeaderHeight + 1

                if section.isExpanded {
                    for (eventIndex, event) in section.events.enumerated() {
                        let isEventExpanded = expandedEvents.contains(event.id)
                        let rowHeight = EventRowView.height(for: event, expanded: isEventExpanded)
                        let row = EventRowView(event: event, width: Theme.popoverWidth, expanded: isEventExpanded, rowIndex: eventIndex)
                        row.translatesAutoresizingMaskIntoConstraints = false
                        row.widthAnchor.constraint(equalToConstant: Theme.popoverWidth).isActive = true
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
                        totalHeight += rowHeight + 1
                    }
                }
            }

            stackView.frame = NSRect(x: 0, y: 0, width: Theme.popoverWidth, height: totalHeight)
        }

        // Restore scroll position
        if resetScroll {
            scrollView.contentView.scroll(to: NSPoint(x: 0, y: 0))
            scrollView.reflectScrolledClipView(scrollView.contentView)
        } else {
            scrollView.contentView.scroll(to: savedScroll)
            scrollView.reflectScrolledClipView(scrollView.contentView)
        }
    }

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
