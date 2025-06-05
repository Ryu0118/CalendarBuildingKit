import SwiftUI
import CalendarBuildingKit

struct WeekCalendarsView: View {
    @State var selectedDate: Date = Date()
    @State var selectedWeek: WeekContext?

    let dateRange: ClosedRange<Date> = {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -365, to: end)!
        return start ... end
    }()

    var body: some View {
        WeekCalendarsBuilder(range: dateRange, calendar: .current, symbols: .short) { weeks in
            selectedWeek = weeks.last
        } content: { status, weekdaySymbols in
            switch status {
            case .loading:
                ProgressView()
            case .loaded(let weeks):
                #if os(macOS)
                ScrollView {
                    VStack {
                        ForEach(weeks) { week in
                            WeekCalendarView(week: week, weekdaySymbols: weekdaySymbols)
                                .tag(week)
                        }
                    }
                }
                #else
                TabView(selection: $selectedWeek) {
                    ForEach(weeks) { week in
                        WeekCalendarView(week: week, weekdaySymbols: weekdaySymbols)
                            .tag(week)
                    }
                }
                .tabViewStyle(.page)
                #endif
            }
        }
    }
}

struct WeekCalendarView: View {
    let week: WeekContext
    let weekdaySymbols: [String]

    var body: some View {
        VStack(spacing: 0) {
            WeekdaySymbolsView(weekdaySymbols: weekdaySymbols)
            HStack(spacing: 0) {
                ForEach(week.days) { day in
                    Text(day.day.description)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
            }
        }
    }
}

