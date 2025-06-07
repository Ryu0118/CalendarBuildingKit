import Foundation
import Observation

// Observable model for managing week calendar data loading
@Observable @MainActor
final class WeekCalendarsModel {
    var loadStatus: LoadStatus<WeekContext> = .loading
    private let generator: CalendarGenerator

    var calendar: Calendar {
        generator.calendar
    }

    init(generator: CalendarGenerator = CalendarGenerator()) {
        self.generator = generator
    }

    // Loads week contexts for the specified date range
    func loadWeeks(range: ClosedRange<Date>) async {
        let weeks = generator.generateWeekContexts(for: range)
        loadStatus = .loaded(weeks)
    }
}
