import Foundation

// MARK: - API Data Models

struct APIResponse: Codable {
    let units: [APIUnit]?
}

struct APIUnit: Codable {
    let disciplineName: String?
    let eventUnitName: String?
    let startDate: String?
    let olympicDay: String?
    let status: String?
    let liveFlag: Bool?
    let medalFlag: Int?
    let scheduleItemType: String?
    let competitors: [APICompetitor]?
}

struct APICompetitor: Codable {
    let noc: String?
    let name: String?
    let results: APIResults?
}

struct APIResults: Codable {
    let mark: String?
    let winnerLoserTie: String?
    let position: String?
}

// MARK: - Display Models

enum EventStatus {
    case scheduled, running, finished
}

struct DisplayEvent {
    let id: String
    let time: String
    let sport: String
    let detail: String
    let isMedal: Bool
    let hasCzech: Bool
    let emoji: String
    let status: EventStatus
    let isLive: Bool
    let isH2H: Bool
    let competitors: [(noc: String, name: String, score: String, position: String, isWinner: Bool)]
}

struct SportSection {
    let name: String
    let emoji: String
    var events: [DisplayEvent]
    var isExpanded: Bool
    var hasLive: Bool
    var hasCzech: Bool
}
