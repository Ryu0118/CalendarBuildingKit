import SwiftUI
import CalendarBuildingKit

struct MonthCalendarsView: View {
    @State var selectedDate: Date = Date()
    @State var selectedMonth: MonthContext?
    let calendar: Calendar

    let dateRange: ClosedRange<Date> = {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -365, to: end)!
        return start ... end
    }()

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    var body: some View {
        MonthCalendarsBuilder(
            range: dateRange,
            calendar: calendar,
            symbols: .short,
            onLoaded: { months in
                selectedMonth = months.last
            }
        ) { status, weekdaySymbols in
#if os(macOS)
            ScrollView {
                VStack {
                    calendarsView(for: status, weekdaySymbols: weekdaySymbols)
                }
            }
#else
            TabView(selection: $selectedMonth) {
                calendarsView(for: status, weekdaySymbols: weekdaySymbols)
            }
            .tabViewStyle(.page)
#endif
        }
    }

    @ViewBuilder
    private func calendarsView(for status: LoadStatus<MonthContext>, weekdaySymbols: [String]) ->  some View {
        switch status {
        case .loading:
            ProgressView()
        case .loaded(let months):
            ForEach(months) { month in
                VStack {
                    Text(month.weeks.first!.days.first!.date, format: .dateTime.year().month())
                    MonthCalendarView(monthContext: month, weekdaySymbols: weekdaySymbols)
                }
                .tag(month)
            }
        }
    }
}

private struct MonthCalendarView: View {
    let monthContext: MonthContext
    let weekdaySymbols: [String]

    var body: some View {
        VStack(spacing: 0) {
            WeekdaySymbolsView(weekdaySymbols: weekdaySymbols)
            ForEach(monthContext.weeks) { week in
                HStack(spacing: 0) {
                    ForEach(week.days) { day in
                        Text(day.day.description)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .foregroundStyle(day.month == monthContext.month ? .primary : .secondary)
                    }
                }
            }
        }
    }
}
//
//struct ExampleView: View {
//    var body: some View {
//        MonthCalendarsBuilder(
//            range: start ... end,
//            selection: $selectedDate
//        ) { status, weekdaySymbols in
//            switch status {
//            case .loading:
//                ProgressView()
//            case .loaded(let months):
//                TabView(selection: $selectedMonth) {
//                    ForEach(months) { month in
//                        VStack(spacing: 0) {
//                            HStack {
//                                ForEach(weekdaySymbols, id: \.self) { symbol in
//                                    Text(symbol)
//                                        .frame(maxWidth: .infinity)
//                                        .padding(.vertical)
//                                }
//                            }
//                            ForEach(month.weeks) { week in
//                                HStack(spacing: 0) {
//                                    ForEach(week.days) { day in
//                                        Text(day.day.description)
//                                            .frame(maxWidth: .infinity)
//                                            .padding(.vertical)
//                                            .foregroundStyle(day.month == month.month ? .primary : .secondary)
//                                    }
//                                }
//                            }
//                        }
//                        .tag(month)
//                    }
//                }
//                .tabViewStyle(.page)
//            }
//        }
//    }
//}

/*
 MonthCalendarsBuilder(
     range: start ... end,
     selection: $selectedDate
 ) { status, weekdaySymbols in
 TabView(selection: $selectedMonth) {
     ForEach(status.data) { month in
         VStack {
             HStack {
                 ForEach(weekdaySymbols, id: \.self) { symbol in
                     Text(symbol)
                 }
             }
             ForEach(month.weeks) { week in
                 HStack {
                     ForEach(week.days) { day in
                         Text(day.day.description)
                             .foregroundStyle(day.month == month.month ? .primary : .secondary)
                     }
                 }
             }
         }
         .tag(month)
     }
 }
 .tabViewStyle(.page)
 }
 */
