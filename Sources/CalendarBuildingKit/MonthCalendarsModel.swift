import Foundation
import Observation

// Observable model for managing month calendar data loading
@Observable @MainActor
final class MonthCalendarsModel {
    var loadStatus: LoadStatus<MonthContext> = .loading
    private let generator: CalendarGenerator

    var calendar: Calendar {
        generator.calendar
    }

    init(generator: CalendarGenerator = CalendarGenerator()) {
        self.generator = generator
    }

    // Loads month contexts for the specified date range
    func loadMonths(range: ClosedRange<Date>) async {
        let months = generator.generateMonthContexts(for: range)
        loadStatus = .loaded(months)
    }
}
