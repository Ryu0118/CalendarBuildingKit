import Foundation
import Observation

// Observable model for managing week calendar data loading
@Observable @MainActor
final class WeekCalendarsModel {
    let range: ClosedRange<Date>
    var loadStatus: LoadStatus<WeekContext> = .loading
    private let generator: CalendarGenerator

    var calendar: Calendar {
        generator.calendar
    }

    init(range: ClosedRange<Date>, generator: CalendarGenerator = CalendarGenerator()) {
        self.range = range
        self.generator = generator
    }

    // Loads week contexts for the specified date range
    func loadWeeks() async {
        let weeks = generator.generateWeekContexts(for: range)
        loadStatus = .loaded(weeks)
    }
}
