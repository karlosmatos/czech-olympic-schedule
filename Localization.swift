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

// IMPORTANT: Longer compound phrases MUST appear before shorter substrings
// to prevent partial matching (e.g. "Official Training" before "Training").
private let eventTermsCZ: [(String, String)] = [
    // Gender prefixes
    ("Women's", "Ženy –"),
    ("Men's", "Muži –"),
    ("Mixed", "Mix"),
    // Ceremonies (before generic terms)
    ("Opening Ceremony", "Zahajovací ceremoniál"),
    ("Closing Ceremony", "Závěrečný ceremoniál"),
    // Compound round types (before "Qualification", "Final")
    ("Bronze Medal Game", "Zápas o bronz"),
    ("Gold Medal Game", "Finále"),
    ("Bronze/Gold", "Bronz/Zlato"),
    ("Round Robin", "Základní skupina"),
    ("Qualification Playoffs", "Kvalifikační play-off"),
    ("Qualification Run", "Kvalifikační jízda"),
    ("Semifinal", "Semifinále"),
    ("Quarterfinal", "Čtvrtfinále"),
    ("Qualification", "Kvalifikace"),
    ("Qual.", "Kvalifikace"),
    ("Preliminary", "Předkolo"),
    ("Finals", "Finále"),
    ("Final", "Finále"),
    // Compound event types (before shorter substrings)
    ("Official Training", "Oficiální trénink"),
    ("Training", "Trénink"),
    ("Mass Start", "Hromadný start"),
    ("Team Relay", "Týmová štafeta"),
    ("Team Event", "Týmová soutěž"),
    ("Team Sprint", "Týmový sprint"),
    ("Parallel Giant Slalom", "Paralelní obří slalom"),
    ("Giant Slalom", "Obří slalom"),
    ("Ski Cross", "Skikros"),
    ("Normal Hill", "Malý můstek"),
    ("Large Hill", "Velký můstek"),
    ("Big Air", "Big Air"),
    ("Free Skate", "Volné jízdy"),
    ("Free Dance", "Volný tanec"),
    ("Ice Dance", "Taneční páry"),
    ("Short Program", "Krátký program"),
    ("Rhythm Dance", "Rytmický tanec"),
    ("Exhibition Gala", "Exhibiční gala"),
    // Run combinations (before single runs)
    ("Run 1 & 2", "1. a 2. jízda"),
    ("Run 3 & 4", "3. a 4. jízda"),
    ("Elimination Run", "Vyřazovací jízda"),
    ("Seeding Run", "Nasazovací jízda"),
    ("Run 1", "1. jízda"),
    ("Run 2", "2. jízda"),
    ("Run 3", "3. jízda"),
    ("Run 4", "4. jízda"),
    // Simple terms (safe to match last)
    ("Heats", "Rozjížďky"),
    ("Relay", "Štafeta"),
    ("Sprint", "Sprint"),
    ("Individual", "Jednotlivci"),
    ("Pursuit", "Stíhací závod"),
    ("Downhill", "Sjezd"),
    ("Super-G", "Super-G"),
    ("Slalom", "Slalom"),
    ("Combined", "Kombinace"),
    ("Slopestyle", "Slopestyle"),
    ("Halfpipe", "Halfpipe"),
    ("Snowboardcross", "Snowboardcross"),
    ("Moguls", "Moguly"),
    ("Aerials", "Akrobacie"),
    ("Skiathlon", "Skiathlon"),
    ("Singles", "Jednotlivci"),
    ("Doubles", "Dvojice"),
    ("Monobob", "Monobob"),
    ("Two-Man", "Dvojbob"),
    ("Four-Man", "Čtyřbob"),
    ("Pairs", "Sportovní dvojice"),
    ("Rescheduled", "Přeloženo"),
]

private let wordFallbacksCZ: [(String, String)] = [
    ("Official", "Oficiální"),
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
