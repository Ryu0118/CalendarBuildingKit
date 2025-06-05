import Foundation

/// Weekday symbol types (standalone symbols are excluded)
public enum WeekdaySymbolType {
    /// Full weekday symbols (e.g., "Sunday", "Monday", ...)
    case full
    /// Short weekday symbols (e.g., "Sun", "Mon", ...)
    case short
    /// Very short weekday symbols (e.g., "S", "M", ...)
    case veryShort
}

/// A structure containing all variations of weekday symbols adjusted for firstWeekday
public struct AdjustedWeekdaySymbols {
    /// Standalone weekday symbols adjusted for firstWeekday
    public let standaloneWeekdaySymbols: [String]

    /// Short standalone weekday symbols adjusted for firstWeekday
    public let shortStandaloneWeekdaySymbols: [String]

    /// Very short standalone weekday symbols adjusted for firstWeekday
    public let veryShortStandaloneWeekdaySymbols: [String]

    init(calendar: Calendar) {
        let offset = calendar.firstWeekday - 1

        self.standaloneWeekdaySymbols = Array(calendar.standaloneWeekdaySymbols[offset...] + calendar.standaloneWeekdaySymbols[..<offset])
        self.shortStandaloneWeekdaySymbols = Array(calendar.shortStandaloneWeekdaySymbols[offset...] + calendar.shortStandaloneWeekdaySymbols[..<offset])
        self.veryShortStandaloneWeekdaySymbols = Array(calendar.veryShortStandaloneWeekdaySymbols[offset...] + calendar.veryShortStandaloneWeekdaySymbols[..<offset])
    }

    /// Returns the weekday symbols array for the specified symbol type
    /// - Parameter type: The type of weekday symbols to return
    /// - Returns: Array of weekday symbols adjusted for firstWeekday
    public func getSymbols(for type: WeekdaySymbolType) -> [String] {
        switch type {
        case .full:
            return standaloneWeekdaySymbols
        case .short:
            return shortStandaloneWeekdaySymbols
        case .veryShort:
            return veryShortStandaloneWeekdaySymbols
        }
    }
}
