import Foundation

// MARK: - Hardcoded Schedule Data (Offline Fallback)

struct OlympicEvent {
    let time: String
    let sport: String
    let detail: String
    let isMedal: Bool
    let hasCzech: Bool
    let emoji: String
}

struct OlympicSchedule {
    static let startDate = Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 4))!
    static let endDate = Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 22))!

    static func events(for date: Date) -> [OlympicEvent] {
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        let month = cal.component(.month, from: date)
        guard month == 2, day >= 4, day <= 22 else { return [] }

        switch day {
        case 4: return [
            OlympicEvent(time: "09:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "20:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
        ]
        case 5: return [
            OlympicEvent(time: "09:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Men's Downhill Training", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "12:10", sport: "Ice Hockey", detail: "Women's: SWE vs GER", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "14:40", sport: "Ice Hockey", detail: "Women's: ITA vs FRA", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "16:40", sport: "Ice Hockey", detail: "Women's: USA vs CZE 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Men's Singles Training", isMedal: false, hasCzech: true, emoji: "🛷"),
            OlympicEvent(time: "20:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ski Jumping", detail: "Men's Normal Hill Qualification", isMedal: false, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "21:10", sport: "Ice Hockey", detail: "Women's: CAN vs FIN", isMedal: false, hasCzech: false, emoji: "🏒"),
        ]
        case 6: return [
            OlympicEvent(time: "09:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "10:00", sport: "Figure Skating", detail: "Team Event - Ice Dance RD", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "12:10", sport: "Ice Hockey", detail: "Women's: FRA vs JPN", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "14:30", sport: "Figure Skating", detail: "Team Event - Women's SP", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:40", sport: "Ice Hockey", detail: "Women's: CZE vs SUI 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Men's Singles Training", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "20:00", sport: "Ceremony", detail: "🏟️ Opening Ceremony – San Siro, Milan", isMedal: false, hasCzech: true, emoji: "🎭"),
        ]
        case 7: return [
            OlympicEvent(time: "09:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "10:00", sport: "Freestyle Skiing", detail: "Moguls Qualification (W)", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "10:30", sport: "Ski Jumping", detail: "Men's Normal Hill Final", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "11:00", sport: "Alpine Skiing", detail: "Men's Downhill", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's Skiathlon 7.5+7.5km", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "11:30", sport: "Speed Skating", detail: "Women's 3000m", isMedal: true, hasCzech: true, emoji: "⛸️"),
            OlympicEvent(time: "12:10", sport: "Ice Hockey", detail: "Women's: GER vs JPN", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "12:10", sport: "Ice Hockey", detail: "Women's: SWE vs ITA", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "13:00", sport: "Short Track", detail: "Mixed Team Relay Heats", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:00", sport: "Figure Skating", detail: "Team Event - Men's SP", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "14:45", sport: "Biathlon", detail: "Mixed Relay 4×6km", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "16:40", sport: "Ice Hockey", detail: "Women's: USA vs FIN", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "17:30", sport: "Snowboard", detail: "Mixed Team Snowboardcross", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Men's Singles Run 1 & 2", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "18:30", sport: "Short Track", detail: "Mixed Team Relay Final", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:00", sport: "Freestyle Skiing", detail: "Moguls Final (W)", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "20:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "21:10", sport: "Ice Hockey", detail: "Women's: SUI vs CAN", isMedal: false, hasCzech: false, emoji: "🏒"),
        ]
        case 8: return [
            OlympicEvent(time: "09:05", sport: "Curling", detail: "Mixed Doubles Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Parallel Giant Slalom Qual.", isMedal: false, hasCzech: true, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 7.5km Sprint", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Alpine Skiing", detail: "Women's Downhill", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's Skiathlon 15+15km", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "11:00", sport: "Figure Skating", detail: "Team Event - Free Dance", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "11:30", sport: "Speed Skating", detail: "Men's 5000m", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:00", sport: "Figure Skating", detail: "Team Event - Pairs FS / Women's FS", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Mixed Doubles Semifinal", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "14:30", sport: "Snowboard", detail: "Parallel Giant Slalom Finals", isMedal: true, hasCzech: true, emoji: "🏂"),
            OlympicEvent(time: "15:00", sport: "Ski Jumping", detail: "Women's Normal Hill Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "16:40", sport: "Ice Hockey", detail: "Women's: FRA vs SWE", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "17:30", sport: "Freestyle Skiing", detail: "Moguls Final (M)", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Men's Singles Run 3 & 4", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "20:05", sport: "Curling", detail: "Mixed Doubles Bronze/Gold", isMedal: true, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "21:10", sport: "Ice Hockey", detail: "Women's: CZE vs FIN 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 9: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Men's Super-G", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Women's Slopestyle Qual.", isMedal: false, hasCzech: true, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Men's 10km Sprint", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's 10km Classic", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:10", sport: "Ice Hockey", detail: "Women's: JPN vs ITA", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "13:00", sport: "Figure Skating", detail: "Ice Dance Rhythm Dance", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:00", sport: "Freestyle Skiing", detail: "Women's Slopestyle Qual.", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Men's 1500m", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "16:40", sport: "Ice Hockey", detail: "Women's: GER vs FRA", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "17:30", sport: "Snowboard", detail: "Women's Big Air Qual.", isMedal: false, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Women's Singles Run 1 & 2", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "18:30", sport: "Skeleton", detail: "Men's Training", isMedal: false, hasCzech: true, emoji: "💀"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:40", sport: "Ice Hockey", detail: "Women's: SUI vs USA", isMedal: false, hasCzech: false, emoji: "🏒"),
            OlympicEvent(time: "21:10", sport: "Ice Hockey", detail: "Women's: CAN vs CZE 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 10: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Women's Giant Slalom Run 1", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 10km Pursuit", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's 20km Classic", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:30", sport: "Figure Skating", detail: "Men's Short Program", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "13:00", sport: "Nordic Combined", detail: "Individual Gundersen NH/10km Ski Jumping", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Women's Giant Slalom Run 2", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's 5000m", isMedal: true, hasCzech: true, emoji: "⛸️"),
            OlympicEvent(time: "15:30", sport: "Nordic Combined", detail: "Individual Gundersen NH/10km XC", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "16:00", sport: "Freestyle Skiing", detail: "Women's Slopestyle Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "17:00", sport: "Snowboard", detail: "Women's Big Air Final", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Women's Singles Run 3 & 4", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "18:30", sport: "Figure Skating", detail: "Ice Dance Free Dance", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:00", sport: "Ice Hockey", detail: "Women's: CZE vs SWE 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "20:30", sport: "Ski Jumping", detail: "Men's Large Hill Qualification", isMedal: false, hasCzech: true, emoji: "🎿"),
        ]
        case 11: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Men's Giant Slalom Run 1", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Men's Slopestyle Qual.", isMedal: false, hasCzech: true, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Men's 12.5km Pursuit", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's 4×5km Relay", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Ski Jumping", detail: "Men's Large Hill Final", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "13:00", sport: "Short Track", detail: "Women's 500m / Men's 1000m Heats", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Men's Giant Slalom Run 2", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's 1500m", isMedal: true, hasCzech: true, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Snowboard", detail: "Men's Big Air Qual.", isMedal: false, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "17:00", sport: "Freestyle Skiing", detail: "Men's Slopestyle Qual.", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Doubles Run 1 & 2", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "18:30", sport: "Short Track", detail: "Women's 500m Final / Men's 1000m Final", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's: CZE vs SUI 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 12: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Women's Super-G", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Women's Halfpipe Qual.", isMedal: false, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 15km Individual", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's 4×10km Relay", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "13:00", sport: "Figure Skating", detail: "Men's Free Skate", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Men's 1000m", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "15:30", sport: "Skeleton", detail: "Men's Run 1 & 2", isMedal: false, hasCzech: true, emoji: "💀"),
            OlympicEvent(time: "16:00", sport: "Snowboard", detail: "Men's Big Air Final", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "17:00", sport: "Freestyle Skiing", detail: "Men's Slopestyle Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "18:00", sport: "Luge", detail: "Team Relay", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's: CZE vs CAN 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 13: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Women's Slalom Run 1", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Men's 20km Individual", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's Sprint Free Qual. & Finals", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "13:00", sport: "Short Track", detail: "Women's 1500m / Men's 500m Heats", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Women's Slalom Run 2", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:00", sport: "Skeleton", detail: "Men's Run 3 & 4", isMedal: true, hasCzech: true, emoji: "💀"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's 1000m", isMedal: true, hasCzech: true, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Snowboard", detail: "Women's Halfpipe Final", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "17:00", sport: "Ski Jumping", detail: "Women's Large Hill Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "18:30", sport: "Short Track", detail: "Women's 1500m Final / Men's 500m Final", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's: FIN vs CZE 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "21:00", sport: "Skeleton", detail: "Women's Run 1 & 2", isMedal: false, hasCzech: false, emoji: "💀"),
        ]
        case 14: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Men's Slalom Run 1", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Men's Halfpipe Qual.", isMedal: false, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 4×6km Relay", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's Sprint Free Qual. & Finals", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Skeleton", detail: "Women's Run 3 & 4", isMedal: true, hasCzech: false, emoji: "💀"),
            OlympicEvent(time: "13:00", sport: "Nordic Combined", detail: "Individual Gundersen LH/10km Jump", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Men's Slalom Run 2", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's 500m", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "15:30", sport: "Freestyle Skiing", detail: "Women's Aerials Qual.", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "16:00", sport: "Nordic Combined", detail: "Individual Gundersen LH/10km XC", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "17:00", sport: "Skeleton", detail: "Mixed Team Event", isMedal: true, hasCzech: true, emoji: "💀"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's: SWE vs CZE 🇨🇿", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "21:00", sport: "Ski Mountaineering", detail: "Men's Sprint Qual.", isMedal: false, hasCzech: false, emoji: "🏔️"),
        ]
        case 15: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Women's Downhill Training", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Women's Snowboardcross", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Men's 4×7.5km Relay", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's 20km Free Mass Start", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Women's Monobob Run 1 & 2", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "13:00", sport: "Short Track", detail: "Women's 1000m / Men's 1500m Heats", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "13:45", sport: "Figure Skating", detail: "Pairs Short Program", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Men's 500m", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Freestyle Skiing", detail: "Women's Aerials Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "17:00", sport: "Snowboard", detail: "Men's Halfpipe Final", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "18:00", sport: "Ski Mountaineering", detail: "Men's Sprint Final", isMedal: true, hasCzech: false, emoji: "🏔️"),
            OlympicEvent(time: "18:30", sport: "Short Track", detail: "Women's 1000m / Men's 1500m Finals", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Qualification Playoffs", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 16: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Men's Combined Downhill", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 12.5km Mass Start", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's 50km Free Mass Start", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Women's Monobob Run 3 & 4", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Men's Combined Slalom", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:00", sport: "Figure Skating", detail: "Pairs Free Skate", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Round Robin", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's Team Pursuit", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Snowboard", detail: "Men's Snowboardcross", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "17:00", sport: "Freestyle Skiing", detail: "Men's Aerials Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "17:30", sport: "Ski Jumping", detail: "Team Large Hill Final", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "18:00", sport: "Ski Mountaineering", detail: "Women's Sprint Final", isMedal: true, hasCzech: false, emoji: "🏔️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Round Robin", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Quarterfinal", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 17: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Women's Combined Downhill", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Women's Slopestyle Final", isMedal: true, hasCzech: true, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Men's 15km Mass Start", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's Team Sprint Free", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Two-Man Run 1 & 2", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "12:45", sport: "Figure Skating", detail: "Women's Short Program", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Women's Combined Slalom", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Semifinal", isMedal: false, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Men's Team Pursuit", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Freestyle Skiing", detail: "Women's Halfpipe Qual.", isMedal: false, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "18:00", sport: "Short Track", detail: "Women's 3000m Relay / Men's 500m Final", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Semifinal", isMedal: false, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Quarterfinal", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "21:00", sport: "Ice Hockey", detail: "Women's Semifinal", isMedal: false, hasCzech: true, emoji: "🏒"),
        ]
        case 18: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Men's Team Event Qual.", isMedal: false, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Men's Slopestyle Final", isMedal: true, hasCzech: true, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Single Mixed Relay", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's Team Sprint Free", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Two-Man Run 3 & 4", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "13:30", sport: "Alpine Skiing", detail: "Men's Team Event Finals", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "14:05", sport: "Curling", detail: "Men's Bronze/Gold", isMedal: true, hasCzech: true, emoji: "🥌"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's 10000m", isMedal: true, hasCzech: true, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Freestyle Skiing", detail: "Women's Halfpipe Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "17:00", sport: "Ski Mountaineering", detail: "Individual (M)", isMedal: true, hasCzech: false, emoji: "🏔️"),
            OlympicEvent(time: "18:30", sport: "Short Track", detail: "Men's 5000m Relay Final", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "19:05", sport: "Curling", detail: "Women's Bronze/Gold", isMedal: true, hasCzech: false, emoji: "🥌"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Semifinal", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "21:00", sport: "Ice Hockey", detail: "Women's Bronze Medal Game", isMedal: true, hasCzech: true, emoji: "🏒"),
        ]
        case 19: return [
            OlympicEvent(time: "10:00", sport: "Alpine Skiing", detail: "Women's Team Event", isMedal: true, hasCzech: true, emoji: "⛷️"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 4×6km Relay", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Women's Bobsled Run 1 & 2", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "13:00", sport: "Figure Skating", detail: "Women's Free Skate", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "14:00", sport: "Freestyle Skiing", detail: "Men's Halfpipe Final", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Men's 10000m", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Snowboard", detail: "Women's Snowboardcross Team", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "17:00", sport: "Ski Mountaineering", detail: "Individual (W)", isMedal: true, hasCzech: false, emoji: "🏔️"),
            OlympicEvent(time: "18:00", sport: "Short Track", detail: "Women's 1000m / Men's 1500m Finals", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Semifinal", isMedal: false, hasCzech: true, emoji: "🏒"),
            OlympicEvent(time: "21:00", sport: "Ice Hockey", detail: "Women's Gold Medal Game", isMedal: true, hasCzech: true, emoji: "🏒"),
        ]
        case 20: return [
            OlympicEvent(time: "10:00", sport: "Snowboard", detail: "Men's Snowboardcross Team", isMedal: true, hasCzech: false, emoji: "🏂"),
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Men's 12.5km Mass Start", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Women's 30km Classic Mass Start", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Women's Bobsled Run 3 & 4", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "14:00", sport: "Freestyle Skiing", detail: "Mixed Team Aerials", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Women's Mass Start", isMedal: true, hasCzech: true, emoji: "⛸️"),
            OlympicEvent(time: "16:00", sport: "Ski Mountaineering", detail: "Sprint Relay Mixed", isMedal: true, hasCzech: false, emoji: "🏔️"),
            OlympicEvent(time: "17:00", sport: "Ski Jumping", detail: "Mixed Team Normal Hill", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "18:00", sport: "Bobsled", detail: "Four-Man Run 1 & 2", isMedal: false, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Bronze Medal Game", isMedal: true, hasCzech: true, emoji: "🏒"),
        ]
        case 21: return [
            OlympicEvent(time: "10:30", sport: "Biathlon", detail: "Women's 12.5km Mass Start", isMedal: true, hasCzech: true, emoji: "🎯"),
            OlympicEvent(time: "11:00", sport: "Cross-Country", detail: "Men's 50km Classic Mass Start", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "12:00", sport: "Bobsled", detail: "Four-Man Run 3 & 4", isMedal: true, hasCzech: false, emoji: "🛷"),
            OlympicEvent(time: "14:00", sport: "Freestyle Skiing", detail: "Ski Cross (M) & (W)", isMedal: true, hasCzech: false, emoji: "🎿"),
            OlympicEvent(time: "15:00", sport: "Speed Skating", detail: "Men's Mass Start", isMedal: true, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "17:00", sport: "Figure Skating", detail: "Exhibition Gala", isMedal: false, hasCzech: false, emoji: "⛸️"),
            OlympicEvent(time: "20:30", sport: "Ice Hockey", detail: "Men's Gold Medal Game", isMedal: true, hasCzech: true, emoji: "🏒"),
        ]
        case 22: return [
            OlympicEvent(time: "10:00", sport: "Cross-Country", detail: "Women's/Men's Sprint Finals", isMedal: true, hasCzech: true, emoji: "🎿"),
            OlympicEvent(time: "20:00", sport: "Ceremony", detail: "Closing Ceremony – Verona Arena", isMedal: false, hasCzech: true, emoji: "🎭"),
        ]
        default: return []
        }
    }

    static func toDisplayEvents(_ events: [OlympicEvent]) -> [DisplayEvent] {
        return events.enumerated().map { (index, e) in
            DisplayEvent(
                id: "\(e.sport)-\(e.detail)-\(e.time)-\(index)",
                time: e.time, sport: czechSportName(e.sport), detail: czechEventDetail(e.detail),
                isMedal: e.isMedal, hasCzech: e.hasCzech,
                emoji: e.emoji, status: .scheduled,
                isLive: false, isH2H: false,
                competitors: []
            )
        }
    }
}
