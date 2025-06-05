import SwiftUI
import CalendarBuildingKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Month Calendar") {
                    MonthCalendarsView()
                }
                NavigationLink("Week Calendar") {
                    WeekCalendarsView()
                }
                NavigationLink("First Weekday Test") {
                    CustomFirstWeekdayCalendarView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
