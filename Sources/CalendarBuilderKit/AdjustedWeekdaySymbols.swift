import Foundation

/// Weekday symbol types (standalone symbols are excluded)
public enum WeekdaySymbolType {
    /// Full weekday symbols (e.g., "Sunday", "Monday", ...)
    case full
    /// Short weekday symbols (e.g., "Sun", "Mon", ...)
    case short
    /// Very short weekday symbols (e.g., "S", "M", ...)
    case veryShort

    func getSymbols(from calendar: Calendar) -> [String] {
        let offset = calendar.firstWeekday - 1
        return switch self {
        case .full:
            Array(calendar.standaloneWeekdaySymbols[offset...] + calendar.standaloneWeekdaySymbols[..<offset])
        case .short:
            Array(calendar.shortStandaloneWeekdaySymbols[offset...] + calendar.shortStandaloneWeekdaySymbols[..<offset])
        case .veryShort:
            Array(calendar.veryShortStandaloneWeekdaySymbols[offset...] + calendar.veryShortStandaloneWeekdaySymbols[..<offset])
        }
    }
}
