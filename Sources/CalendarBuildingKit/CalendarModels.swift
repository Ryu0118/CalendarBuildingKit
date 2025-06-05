import Foundation

/// Represents a single day in the calendar with associated metadata
public struct DayContext: Sendable, Hashable, Identifiable {
    /// Unique identifier based on the date's timestamp
    public var id: TimeInterval {
        date.timeIntervalSince1970
    }

    /// The actual date this context represents
    public let date: Date
    /// Year component of the date
    public let year: Int
    /// Month component of the date (1-12)
    public let month: Int
    /// Day component of the date (1-31)
    public let day: Int

    /// Creates a new day context
    /// - Parameters:
    ///   - date: The date this context represents
    ///   - year: Year component
    ///   - month: Month component
    ///   - day: Day component
    public init(date: Date, year: Int, month: Int, day: Int) {
        self.date = date
        self.year = year
        self.month = month
        self.day = day
    }
}

/// Represents a week in the calendar containing multiple days
public struct WeekContext: CalendarLoadable {
    /// Unique identifier for the week
    public var id: String {
        "\(year)-\(month)-\(weekIndex)"
    }

    /// Year this week belongs to
    public let year: Int
    /// Month this week primarily belongs to
    public let month: Int
    /// Index of the week within the month
    public let weekIndex: Int
    /// Array of day contexts for this week (typically 7 days)
    public let days: [DayContext]

    /// Creates a new week context
    /// - Parameters:
    ///   - year: Year component
    ///   - month: Month component
    ///   - weekIndex: Week index within the month
    ///   - days: Array of day contexts
    public init(year: Int, month: Int, weekIndex: Int, days: [DayContext]) {
        self.year = year
        self.month = month
        self.weekIndex = weekIndex
        self.days = days
    }
}

/// Represents a month in the calendar containing multiple weeks
public struct MonthContext: CalendarLoadable {
    /// Unique identifier for the month
    public var id: String {
        "\(year)-\(month)"
    }

    /// Year this month belongs to
    public let year: Int
    /// Month number (1-12)
    public let month: Int
    /// Array of week contexts for this month
    public let weeks: [WeekContext]

    /// Creates a new month context
    /// - Parameters:
    ///   - year: Year component
    ///   - month: Month component
    ///   - weeks: Array of week contexts
    public init(year: Int, month: Int, weeks: [WeekContext]) {
        self.year = year
        self.month = month
        self.weeks = weeks
    }
}

/// Protocol for calendar components that can be loaded
public protocol CalendarLoadable: Sendable, Identifiable, Hashable {
    /// Unique identifier for the loadable component
    var id: String { get }
}
