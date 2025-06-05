import SwiftUI
import CalendarBuilderKit

func createCustomCalendar(
    firstWeekday: Int,
    locale: String = "en_US",
    timeZone: String = "UTC"
) -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: locale)
    calendar.timeZone = TimeZone(identifier: timeZone) ?? TimeZone.current
    calendar.firstWeekday = firstWeekday
    return calendar
}

struct CustomFirstWeekdayCalendarView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(1...7, id: \.self) { firstWeekday in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Weekday: \(firstWeekday)")
                            .font(.headline)
                            .padding(.horizontal)

                        MonthCalendarsView(calendar: createCustomCalendar(firstWeekday: firstWeekday))
                            .frame(height: 350)
                    }
                }
            }
        }
    }
}
