import Foundation

/// Generator for creating calendar contexts from dates
public struct CalendarGenerator {
    // Calendar instance used for date calculations
    public var calendar: Calendar

    /// Creates a new calendar generator
    /// - Parameter calendar: Calendar to use for date calculations (defaults to current)
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    // MARK: - Public Methods

    /// Generates month context from the specified date
    /// - Parameter date: Base date
    /// - Returns: Generated month context
    public func generateMonthContext(for date: Date) -> MonthContext {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else {
            fatalError("Failed to extract year and month from date")
        }

        let monthInterval = calendar.dateInterval(of: .month, for: date)!
        let startOfWeek = calculateStartOfWeek(for: monthInterval.start)
        let weeks = generateWeeksForMonth(
            startOfWeek: startOfWeek,
            monthEnd: monthInterval.end,
            year: year,
            month: month
        )

        return MonthContext(year: year, month: month, weeks: weeks)
    }

    /// Generates week context from the specified date
    /// - Parameter date: Base date
    /// - Returns: Generated week context
    public func generateWeekContext(for date: Date) -> WeekContext {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else {
            fatalError("Failed to extract year and month from date")
        }

        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date)!
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let days = generateDaysForWeek(weekStart: weekInterval.start)

        return WeekContext(
            year: year,
            month: month,
            weekIndex: weekOfYear,
            days: days
        )
    }

    /// Generates month contexts for a date range
    /// - Parameter range: Date range to generate months for
    /// - Returns: Array of month contexts
    public func generateMonthContexts(for range: ClosedRange<Date>) -> [MonthContext] {
        let startDate = range.lowerBound
        let endDate = range.upperBound

        var months: [MonthContext] = []
        var currentDate = calendar.dateInterval(of: .month, for: startDate)?.start ?? startDate

        while currentDate <= endDate {
            let monthContext = generateMonthContext(for: currentDate)
            months.append(monthContext)

            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextMonth
        }

        return months
    }

    /// Generates week contexts for a date range
    /// - Parameter range: Date range to generate weeks for
    /// - Returns: Array of week contexts
    public func generateWeekContexts(for range: ClosedRange<Date>) -> [WeekContext] {
        let startDate = range.lowerBound
        let endDate = range.upperBound

        var weeks: [WeekContext] = []
        var currentDate = calendar.dateInterval(of: .weekOfYear, for: startDate)?.start ?? startDate

        while currentDate <= endDate {
            let weekContext = generateWeekContext(for: currentDate)
            weeks.append(weekContext)

            guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextWeek
        }

        return weeks
    }
}

// MARK: - Private Methods

private extension CalendarGenerator {
    // Calculates week start from month's first day respecting firstWeekday setting
    func calculateStartOfWeek(for monthStart: Date) -> Date {
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let calendarFirstWeekday = calendar.firstWeekday

        // Calculate days to subtract to get to the start of the week
        let daysToSubtract = (firstWeekday - calendarFirstWeekday + 7) % 7

        return calendar.date(byAdding: .day, value: -daysToSubtract, to: monthStart)!
    }

    // Generates all weeks for a given month
    func generateWeeksForMonth(
        startOfWeek: Date,
        monthEnd: Date,
        year: Int,
        month: Int
    ) -> [WeekContext] {
        var weeks: [WeekContext] = []
        var weekIndex = 0
        var currentWeekStart = startOfWeek

        while currentWeekStart < monthEnd {
            let days = generateDaysForWeek(weekStart: currentWeekStart)
            let weekContext = WeekContext(
                year: year,
                month: month,
                weekIndex: weekIndex,
                days: days
            )
            weeks.append(weekContext)

            guard let nextWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) else {
                break
            }

            currentWeekStart = nextWeekStart
            weekIndex += 1

            // Stop if next week exceeds the month boundary
            if isDateBeyondMonth(nextWeekStart, month: month) {
                break
            }
        }

        return weeks
    }

    // Generates 7 days for a week starting from given date
    func generateDaysForWeek(weekStart: Date) -> [DayContext] {
        var days: [DayContext] = []

        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart)!
            let dayContext = createDayContext(for: date)
            days.append(dayContext)
        }

        return days
    }

    // Creates day context from date
    func createDayContext(for date: Date) -> DayContext {
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        return DayContext(
            date: date,
            year: components.year!,
            month: components.month!,
            day: components.day!
        )
    }

    // Checks if date is beyond given month
    func isDateBeyondMonth(_ date: Date, month: Int) -> Bool {
        calendar.component(.month, from: date) != month
    }
}
