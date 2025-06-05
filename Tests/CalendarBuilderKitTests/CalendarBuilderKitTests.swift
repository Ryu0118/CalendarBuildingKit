import Testing
import Foundation
@testable import CalendarBuilderKit

@Suite
struct CalendarGeneratorTests {
    let calendar: Calendar
    let generator: CalendarGenerator

    init() {
        var testCalendar = Calendar(identifier: .gregorian)
        testCalendar.timeZone = TimeZone(identifier: "UTC")!
        self.calendar = testCalendar
        self.generator = CalendarGenerator(calendar: testCalendar)
    }

    @Test("Generate month context for single date")
    func generateMonthContext() {
        let components = DateComponents(year: 2025, month: 1, day: 15)
        let date = calendar.date(from: components)!

        let monthContext = generator.generateMonthContext(for: date)

        #expect(monthContext.year == 2025)
        #expect(monthContext.month == 1)
        #expect(monthContext.id == "2025-1")
        #expect(monthContext.weeks.count > 0)

        for week in monthContext.weeks {
            #expect(week.days.count == 7)
            #expect(week.year == 2025)
            #expect(week.month == 1)
        }
    }

    @Test("Generate week context for single date")
    func generateWeekContext() {
        let components = DateComponents(year: 2025, month: 1, day: 15)
        let date = calendar.date(from: components)!

        let weekContext = generator.generateWeekContext(for: date)

        #expect(weekContext.year == 2025)
        #expect(weekContext.month == 1)
        #expect(weekContext.days.count == 7)

        for day in weekContext.days {
            #expect(day.year > 0)
            #expect(day.month > 0)
            #expect(day.day > 0)
        }
    }

    @Test("Generate month contexts for date range")
    func generateMonthContextsForRange() {
        let startComponents = DateComponents(year: 2025, month: 1, day: 1)
        let endComponents = DateComponents(year: 2025, month: 3, day: 31)
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        let range = startDate...endDate

        let months = generator.generateMonthContexts(for: range)

        #expect(months.count == 3)

        #expect(months[0].year == 2025 && months[0].month == 1)
        #expect(months[1].year == 2025 && months[1].month == 2)
        #expect(months[2].year == 2025 && months[2].month == 3)

        for month in months {
            #expect(month.weeks.count > 0)
            for week in month.weeks {
                #expect(week.days.count == 7)
            }
        }
    }

    @Test("Generate week contexts for date range")
    func generateWeekContextsForRange() {
        let startComponents = DateComponents(year: 2025, month: 1, day: 6)
        let endComponents = DateComponents(year: 2025, month: 1, day: 19)
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        let range = startDate...endDate

        let weeks = generator.generateWeekContexts(for: range)

        #expect(weeks.count >= 2)

        for week in weeks {
            #expect(week.days.count == 7)
            #expect(week.year > 0)
        }
    }

    @Test("Month context includes previous/next month days")
    func monthContextIncludesAdjacentMonthDays() {
        let components = DateComponents(year: 2025, month: 2, day: 1)
        let date = calendar.date(from: components)!

        let monthContext = generator.generateMonthContext(for: date)

        let firstWeek = monthContext.weeks.first!
        let firstDay = firstWeek.days.first!

        #expect(firstDay.month == 1)
        #expect(firstDay.year == 2025)
    }

    @Test("Day context properties are correctly set")
    func dayContextProperties() {
        let components = DateComponents(year: 2025, month: 6, day: 15)
        let date = calendar.date(from: components)!

        let monthContext = generator.generateMonthContext(for: date)
        let targetDay = monthContext.weeks.flatMap(\.days)
            .first { $0.year == 2025 && $0.month == 6 && $0.day == 15 }

        #expect(targetDay != nil)
        #expect(targetDay!.date == date)
        #expect(targetDay!.year == 2025)
        #expect(targetDay!.month == 6)
        #expect(targetDay!.day == 15)
        #expect(targetDay!.id == date.timeIntervalSince1970)
    }

    @Test("Single day range works correctly")
    func singleDayRange() {
        let components = DateComponents(year: 2025, month: 1, day: 15)
        let date = calendar.date(from: components)!
        let range = date...date

        let months = generator.generateMonthContexts(for: range)
        let weeks = generator.generateWeekContexts(for: range)

        #expect(months.count == 1)
        #expect(weeks.count == 1)
        #expect(months[0].year == 2025)
        #expect(months[0].month == 1)
    }

    @Test("Cross-year range works correctly")
    func crossYearRange() {
        let startComponents = DateComponents(year: 2024, month: 12, day: 15)
        let endComponents = DateComponents(year: 2025, month: 1, day: 15)
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        let range = startDate...endDate

        let months = generator.generateMonthContexts(for: range)

        #expect(months.count == 2)
        #expect(months[0].year == 2024 && months[0].month == 12)
        #expect(months[1].year == 2025 && months[1].month == 1)
    }

    @Test("Different first weekday produces different month layouts")
    func differentFirstWeekdayProducesDifferentLayouts() {
        let components = DateComponents(year: 2025, month: 1, day: 1)

        var usCalendar = Calendar(identifier: .gregorian)
        usCalendar.timeZone = TimeZone(identifier: "UTC")!
        usCalendar.firstWeekday = 1
        let usGenerator = CalendarGenerator(calendar: usCalendar)

        var europeanCalendar = Calendar(identifier: .gregorian)
        europeanCalendar.timeZone = TimeZone(identifier: "UTC")!
        europeanCalendar.firstWeekday = 2
        let europeanGenerator = CalendarGenerator(calendar: europeanCalendar)

        let date = usCalendar.date(from: components)!

        let usMonthContext = usGenerator.generateMonthContext(for: date)
        let europeanMonthContext = europeanGenerator.generateMonthContext(for: date)

        let usFirstWeek = usMonthContext.weeks.first!
        let europeanFirstWeek = europeanMonthContext.weeks.first!

        let usFirstDay = usFirstWeek.days.first!
        #expect(usFirstDay.month == 12)
        #expect(usFirstDay.day == 29)

        let europeanFirstDay = europeanFirstWeek.days.first!
        #expect(europeanFirstDay.month == 12)
        #expect(europeanFirstDay.day == 30)

        let jan1InUS = usFirstWeek.days.firstIndex { $0.month == 1 && $0.day == 1 }!
        let jan1InEuropean = europeanFirstWeek.days.firstIndex { $0.month == 1 && $0.day == 1 }!

        #expect(jan1InUS == 3)
        #expect(jan1InEuropean == 2)
    }

    @Test("Different timezones affect date boundaries")
    func differentTimezonesAffectDateBoundaries() {
        let timestamp: TimeInterval = 1735689600

        var utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!
        let utcGenerator = CalendarGenerator(calendar: utcCalendar)

        var tokyoCalendar = Calendar(identifier: .gregorian)
        tokyoCalendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let tokyoGenerator = CalendarGenerator(calendar: tokyoCalendar)

        let date = Date(timeIntervalSince1970: timestamp)

        let utcMonthContext = utcGenerator.generateMonthContext(for: date)
        let tokyoMonthContext = tokyoGenerator.generateMonthContext(for: date)

        #expect(utcMonthContext.year == 2025)
        #expect(utcMonthContext.month == 1)
        #expect(tokyoMonthContext.year == 2025)
        #expect(tokyoMonthContext.month == 1)

        let utcDate = utcCalendar.dateComponents([.year, .month, .day, .hour], from: date)
        let tokyoDate = tokyoCalendar.dateComponents([.year, .month, .day, .hour], from: date)

        #expect(utcDate.hour == 0)
        #expect(tokyoDate.hour == 9)
    }

    @Test("Middle East calendar with Saturday start")
    func middleEastCalendarWithSaturdayStart() {
        var middleEastCalendar = Calendar(identifier: .gregorian)
        middleEastCalendar.timeZone = TimeZone(identifier: "UTC")!
        middleEastCalendar.firstWeekday = 7
        let middleEastGenerator = CalendarGenerator(calendar: middleEastCalendar)

        let components = DateComponents(year: 2025, month: 1, day: 1)
        let date = middleEastCalendar.date(from: components)!

        let monthContext = middleEastGenerator.generateMonthContext(for: date)

        let firstWeek = monthContext.weeks.first!
        let firstDay = firstWeek.days.first!

        #expect(firstDay.month == 12)
        #expect(firstDay.day == 28)

        let jan1Index = firstWeek.days.firstIndex { $0.month == 1 && $0.day == 1 }!
        #expect(jan1Index == 4)
    }
}
