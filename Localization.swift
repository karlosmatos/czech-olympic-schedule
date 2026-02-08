import Foundation

// MARK: - Sport Emoji Mapping

let sportEmojiMap: [String: String] = [
    "Curling": "🥌",
    "Alpine Skiing": "⛷️",
    "Cross-Country Skiing": "🎿",
    "Cross-Country": "🎿",
    "Biathlon": "🎯",
    "Short Track Speed Skating": "⛸️",
    "Short Track": "⛸️",
    "Speed Skating": "⛸️",
    "Figure Skating": "⛸️",
    "Freestyle Skiing": "🎿",
    "Snowboard": "🏂",
    "Ski Jumping": "🎿",
    "Luge": "🛷",
    "Bobsleigh": "🛷",
    "Bobsled": "🛷",
    "Skeleton": "💀",
    "Nordic Combined": "🎿",
    "Ice Hockey": "🏒",
    "Ski Mountaineering": "🏔️",
    "Ceremony": "🎭",
]

func emojiForSport(_ name: String) -> String {
    if let emoji = sportEmojiMap[name] { return emoji }
    for (key, emoji) in sportEmojiMap {
        if name.localizedCaseInsensitiveContains(key) { return emoji }
    }
    return "🏅"
}

// MARK: - Czech Localization

let sportNamesCZ: [String: String] = [
    "Alpine Skiing": "Alpské lyžování",
    "Biathlon": "Biatlon",
    "Bobsleigh": "Boby",
    "Bobsled": "Boby",
    "Ceremony": "Ceremoniál",
    "Cross-Country": "Běžecké lyžování",
    "Cross-Country Skiing": "Běžecké lyžování",
    "Curling": "Curling",
    "Figure Skating": "Krasobruslení",
    "Freestyle Skiing": "Akrobatické lyžování",
    "Ice Hockey": "Lední hokej",
    "Luge": "Saně",
    "Nordic Combined": "Severská kombinace",
    "Short Track": "Short track",
    "Short Track Speed Skating": "Short track",
    "Skeleton": "Skeleton",
    "Ski Jumping": "Skoky na lyžích",
    "Ski Mountaineering": "Skialpinismus",
    "Snowboard": "Snowboard",
    "Speed Skating": "Rychlobruslení",
]

private let eventTermsCZ: [(String, String)] = [
    // Gender prefixes
    ("Women's", "Ženy –"),
    ("Men's", "Muži –"),
    ("Mixed", "Mix"),
    // Round types
    ("Round Robin", "Základní skupina"),
    ("Semifinal", "Semifinále"),
    ("Quarterfinal", "Čtvrtfinále"),
    ("Bronze Medal Game", "Zápas o bronz"),
    ("Gold Medal Game", "Finále"),
    ("Bronze/Gold", "Bronz/Zlato"),
    ("Qualification", "Kvalifikace"),
    ("Qual.", "Kvalifikace"),
    ("Final", "Finále"),
    ("Finals", "Finále"),
    // Event types
    ("Training", "Trénink"),
    ("Official Training", "Oficiální trénink"),
    ("Heats", "Rozjížďky"),
    ("Relay", "Štafeta"),
    ("Team Event", "Týmová soutěž"),
    ("Team Sprint", "Týmový sprint"),
    ("Sprint", "Sprint"),
    ("Individual", "Jednotlivci"),
    ("Mass Start", "Hromadný start"),
    ("Pursuit", "Stíhací závod"),
    ("Downhill", "Sjezd"),
    ("Super-G", "Super-G"),
    ("Giant Slalom", "Obří slalom"),
    ("Slalom", "Slalom"),
    ("Combined", "Kombinace"),
    ("Slopestyle", "Slopestyle"),
    ("Halfpipe", "Halfpipe"),
    ("Big Air", "Big Air"),
    ("Snowboardcross", "Snowboardcross"),
    ("Parallel Giant Slalom", "Paralelní obří slalom"),
    ("Moguls", "Moguly"),
    ("Aerials", "Akrobacie"),
    ("Ski Cross", "Skikros"),
    ("Normal Hill", "Malý můstek"),
    ("Large Hill", "Velký můstek"),
    ("Skiathlon", "Skiathlon"),
    ("Singles", "Jednotlivci"),
    ("Doubles", "Dvojice"),
    ("Monobob", "Monobob"),
    ("Two-Man", "Dvojbob"),
    ("Four-Man", "Čtyřbob"),
    ("Team Relay", "Týmová štafeta"),
    ("Pairs", "Sportovní dvojice"),
    ("Ice Dance", "Taneční páry"),
    ("Free Skate", "Volné jízdy"),
    ("Free Dance", "Volný tanec"),
    ("Short Program", "Krátký program"),
    ("Rhythm Dance", "Rytmický tanec"),
    ("Exhibition Gala", "Exhibiční gala"),
    ("Run 1", "1. jízda"),
    ("Run 2", "2. jízda"),
    ("Run 3", "3. jízda"),
    ("Run 4", "4. jízda"),
    ("Run 1 & 2", "1. a 2. jízda"),
    ("Run 3 & 4", "3. a 4. jízda"),
    ("Opening Ceremony", "Zahajovací ceremoniál"),
    ("Closing Ceremony", "Závěrečný ceremoniál"),
    ("Elimination Run", "Vyřazovací jízda"),
    ("Qualification Playoffs", "Kvalifikační play-off"),
    ("Qualification Run", "Kvalifikační jízda"),
    ("Preliminary", "Předkolo"),
    ("Rescheduled", "Přeloženo"),
    ("Seeding Run", "Nasazovací jízda"),
]

private let wordFallbacksCZ: [(String, String)] = [
    ("Official", "Oficiální"),
    ("PGS", "PGS"),
]

func czechSportName(_ english: String) -> String {
    if let cz = sportNamesCZ[english] { return cz }
    for (key, cz) in sportNamesCZ {
        if english.localizedCaseInsensitiveContains(key) { return cz }
    }
    return english
}

func czechEventDetail(_ english: String) -> String {
    var result = english
    for (eng, cz) in eventTermsCZ {
        result = result.replacingOccurrences(of: eng, with: cz)
    }
    // Word-level fallback for standalone terms not caught by phrase replacements
    for (eng, cz) in wordFallbacksCZ {
        result = result.replacingOccurrences(of: eng, with: cz)
    }
    return result
}
