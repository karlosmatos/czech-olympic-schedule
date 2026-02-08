import Cocoa

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var eventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.title = "🏔️"
            button.font = Theme.emojiFont
            button.action = #selector(togglePopover)
            button.target = self
            button.toolTip = "Czech Olympic Schedule – Milano Cortina 2026"
        }

        popover = NSPopover()
        popover.contentSize = NSSize(width: Theme.popoverWidth, height: Theme.popoverHeight)
        popover.behavior = .transient
        popover.animates = true
        popover.delegate = self
        popover.contentViewController = PopoverViewController()

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(nil)
            }
        }
    }

    @objc func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
            if let vc = popover.contentViewController as? PopoverViewController {
                vc.stopRefreshTimer()
            }
        } else if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            if let vc = popover.contentViewController as? PopoverViewController {
                vc.updateEvents()
            }
        }
    }

    func popoverDidClose(_ notification: Notification) {
        if let vc = popover.contentViewController as? PopoverViewController {
            vc.stopRefreshTimer()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
