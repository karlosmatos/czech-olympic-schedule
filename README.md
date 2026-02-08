# Czech Olympic Schedule

A native macOS menu bar app for tracking the **2026 Winter Olympics** (Milano Cortina) schedule — with a focus on Czech athletes.

Click the 🏔️ icon in your menu bar to see today's Olympic events at a glance.

## Features

- **Live schedule from Olympics API** — fetches real-time event data with automatic polling for live events (30s refresh)
- **Offline fallback** — hardcoded schedule for all 19 days (Feb 4–22) when the API is unreachable
- **Czech athlete highlighting** — events with Czech competitors are highlighted in blue with 🇨🇿 flag badges
- **Accordion UI** — events grouped by sport with collapsible sections; Czech and live sections auto-expand
- **Event details** — click any event to see:
  - H2H matchups with live scores (e.g., hockey, curling)
  - Top-3 results for individual events when finished
  - Status indicators (scheduled / running / finished)
- **Filters** — toggle Czech-only or medal-only views
- **Date navigation** — browse any day of the Games with prev/next buttons, date picker, or "Today" shortcut
- **Medal & live counters** — header shows total medals, Czech events, and live event count
- **Czech localization** — all sport names and event details translated to Czech

## Screenshots

*Coming soon — the Games start February 6, 2026!*

## Requirements

- macOS 13.0+
- Swift 5
- No Xcode project required — compiles with `swiftc`

## Build & Run

```bash
# Clone
git clone https://github.com/karlosmatos/czech-olympic-schedule.git
cd czech-olympic-schedule

# Build
bash build.sh

# Run
open CzechOlympicSchedule.app
```

The build script compiles all Swift files into a `.app` bundle with a single `swiftc` command. No dependencies, no CocoaPods, no SPM.

## Architecture

The app is built entirely with **AppKit** (no SwiftUI, no Interface Builder) and runs as a menu bar accessory (`LSUIElement = true` — no Dock icon).

```
├── main.swift                  # Entry point
├── AppDelegate.swift           # NSStatusItem + NSPopover lifecycle
├── PopoverViewController.swift # Main UI: date nav, filters, event list
├── Views.swift                 # SportSectionHeaderView, EventRowView
├── Models.swift                # API data models + display models
├── ScheduleFetcher.swift       # API client with caching & polling
├── FallbackSchedule.swift      # Hardcoded schedule (offline fallback)
├── Localization.swift          # Czech translations & sport emoji mapping
├── Theme.swift                 # Colors, fonts, dimensions
└── build.sh                    # Build script (swiftc → .app bundle)
```

### Key design decisions

- **Single compilation unit** — all `.swift` files compiled together via `swiftc *.swift`, no Xcode project needed
- **Frame-based layout** — manual `NSRect` positioning throughout (no Auto Layout) for a fixed 480×560pt popover
- **API with graceful degradation** — fetches from the official Olympics schedule API; falls back to hardcoded data after 2 seconds if unreachable
- **25-second cache** — prevents excessive API calls while keeping data fresh
- **30-second live polling** — when any event is running/live, auto-refreshes in the background

### API

The app fetches schedule data from the official Olympics API:

```
GET https://www.olympics.com/wmr-owg2026/schedules/api/ENG/schedule/lite/day/{YYYY-MM-DD}
```

Response includes event units with discipline, start time, status, live/medal flags, and competitor details (NOC codes, names, results).

## Olympic Schedule

The 2026 Winter Olympics run from **February 6–22, 2026** (with preliminary events starting February 4). Key sports include:

Alpine Skiing, Biathlon, Bobsled, Cross-Country Skiing, Curling, Figure Skating, Freestyle Skiing, Ice Hockey, Luge, Nordic Combined, Short Track, Skeleton, Ski Jumping, Ski Mountaineering, Snowboard, Speed Skating

## License

MIT
