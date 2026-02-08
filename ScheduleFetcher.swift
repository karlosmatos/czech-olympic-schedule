import Foundation

class ScheduleFetcher {
    static let shared = ScheduleFetcher()

    private let baseURL = "https://www.olympics.com/wmr-owg2026/schedules/api/ENG/schedule/lite/day/"
    private var cache: [String: [APIUnit]] = [:]
    private var cacheTimestamps: [String: Date] = [:]
    private let cacheLifetime: TimeInterval = 25
    private var activeTasks: [String: URLSessionDataTask] = [:]

    var onDataLoaded: (([APIUnit], String) -> Void)?
    var onError: ((String) -> Void)?

    private let isoFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static let dateKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "Europe/Rome")
        return f
    }()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.timeZone = TimeZone(identifier: "Europe/Prague")
        return f
    }()

    func fetch(for date: Date, forceRefresh: Bool = false) {
        let key = dateKey(date)

        if !forceRefresh, let cached = cache[key],
           let ts = cacheTimestamps[key], Date().timeIntervalSince(ts) < cacheLifetime {
            onDataLoaded?(cached, key)
            return
        }

        activeTasks[key]?.cancel()

        guard let url = URL(string: baseURL + key) else {
            onError?("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("https://www.olympics.com/en/milano-cortina-2026/schedule", forHTTPHeaderField: "Referer")
        request.setValue("no-cache, no-store, must-revalidate", forHTTPHeaderField: "Cache-Control")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error as NSError?, error.code == NSURLErrorCancelled { return }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.onError?(key)
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                let allUnits = decoded.units ?? []
                let units = allUnits.filter { $0.olympicDay == key }
                self.cache[key] = units
                self.cacheTimestamps[key] = Date()
                DispatchQueue.main.async {
                    self.onDataLoaded?(units, key)
                }
            } catch {
                do {
                    let allUnits = try JSONDecoder().decode([APIUnit].self, from: data)
                    let units = allUnits.filter { $0.olympicDay == key }
                    self.cache[key] = units
                    self.cacheTimestamps[key] = Date()
                    DispatchQueue.main.async {
                        self.onDataLoaded?(units, key)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onError?(key)
                    }
                }
            }
        }

        activeTasks[key] = task
        task.resume()
    }

    func dateKey(_ date: Date) -> String {
        return ScheduleFetcher.dateKeyFormatter.string(from: date)
    }

    func parseTime(from isoString: String) -> String {
        if let date = isoFormatter.date(from: isoString) {
            return ScheduleFetcher.timeFormatter.string(from: date)
        }
        if let tIndex = isoString.firstIndex(of: "T") {
            let timeStr = isoString[isoString.index(after: tIndex)...]
            if timeStr.count >= 5 {
                return String(timeStr.prefix(5))
            }
        }
        return ""
    }

    func convertToDisplayEvents(_ units: [APIUnit]) -> [DisplayEvent] {
        return units.enumerated().map { (index, unit) in
            let sportEN = unit.disciplineName ?? "Unknown"
            let detailEN = unit.eventUnitName ?? ""
            let sport = czechSportName(sportEN)
            let detail = czechEventDetail(detailEN)
            let time = unit.startDate.map { parseTime(from: $0) } ?? ""
            let isMedal = (unit.medalFlag ?? 0) >= 1
            let isH2H = unit.scheduleItemType == "H2H_NOC"
            let isLive = unit.liveFlag ?? false

            let status: EventStatus
            switch unit.status {
            case "RUNNING": status = .running
            case "FINISHED": status = .finished
            default: status = .scheduled
            }

            var competitors: [(noc: String, name: String, score: String, position: String, isWinner: Bool)] =
                (unit.competitors ?? []).map { c in
                    (
                        noc: c.noc ?? "",
                        name: c.name ?? "",
                        score: c.results?.mark ?? "",
                        position: c.results?.position ?? "",
                        isWinner: c.results?.winnerLoserTie == "W"
                    )
                }
            if !isH2H {
                competitors.sort { a, b in
                    let posA = Int(a.position) ?? 9999
                    let posB = Int(b.position) ?? 9999
                    return posA < posB
                }
            }

            let hasCzech = competitors.contains { $0.noc == "CZE" }
            let id = "\(sportEN)-\(detailEN)-\(time)-\(index)"

            return DisplayEvent(
                id: id, time: time, sport: sport, detail: detail,
                isMedal: isMedal, hasCzech: hasCzech,
                emoji: emojiForSport(sportEN), status: status,
                isLive: isLive, isH2H: isH2H,
                competitors: competitors
            )
        }
    }

    func groupBySport(_ events: [DisplayEvent]) -> [SportSection] {
        var sectionMap: [(name: String, events: [DisplayEvent])] = []
        var seen: [String: Int] = [:]

        for event in events {
            if let idx = seen[event.sport] {
                sectionMap[idx].events.append(event)
            } else {
                seen[event.sport] = sectionMap.count
                sectionMap.append((name: event.sport, events: [event]))
            }
        }

        return sectionMap.map { entry in
            let hasLive = entry.events.contains { $0.isLive }
            let hasCzech = entry.events.contains { $0.hasCzech }
            return SportSection(
                name: entry.name,
                emoji: entry.events.first?.emoji ?? "🏅",
                events: entry.events,
                isExpanded: hasCzech || hasLive,
                hasLive: hasLive,
                hasCzech: hasCzech
            )
        }
    }
}
