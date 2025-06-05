import Foundation
import Observation

// Observable model for managing month calendar data loading
@Observable @MainActor
final class MonthCalendarsModel {
    let range: ClosedRange<Date>
    var loadStatus: LoadStatus<MonthContext> = .loading
    private let generator: CalendarGenerator

    var calendar: Calendar {
        generator.calendar
    }

    init(range: ClosedRange<Date>, generator: CalendarGenerator = CalendarGenerator()) {
        self.range = range
        self.generator = generator
    }

    // Loads month contexts for the specified date range
    func loadMonths() async {
        let months = generator.generateMonthContexts(for: range)
        loadStatus = .loaded(months)
    }
}
