import Testing
import Foundation
@testable import CalendarBuilderKit

@Suite
struct AdjustedWeekdaySymbolsTests {
    let calendar: Calendar

    init() {
        var testCalendar = Calendar(identifier: .gregorian)
        testCalendar.timeZone = TimeZone(identifier: "UTC")!
        testCalendar.locale = Locale(identifier: "en_US")
        testCalendar.firstWeekday = 1
        self.calendar = testCalendar
    }

    @Test("WeekdaySymbolType enum has correct cases")
    func weekdaySymbolTypeEnumCases() {
        let fullType: WeekdaySymbolType = .full
        let shortType: WeekdaySymbolType = .short
        let veryShortType: WeekdaySymbolType = .veryShort

        #expect(fullType == .full)
        #expect(shortType == .short)
        #expect(veryShortType == .veryShort)
    }

    @Test("WeekdaySymbolType returns correct symbol arrays")
    func weekdaySymbolTypeReturnsCorrectArrays() {
        let fullSymbols = WeekdaySymbolType.full.getSymbols(from: calendar)
        let shortSymbols = WeekdaySymbolType.short.getSymbols(from: calendar)
        let veryShortSymbols = WeekdaySymbolType.veryShort.getSymbols(from: calendar)

        #expect(fullSymbols.count == 7)
        #expect(shortSymbols.count == 7)
        #expect(veryShortSymbols.count == 7)

        #expect(fullSymbols.first == "Sunday")
        #expect(shortSymbols.first == "Sun")
        #expect(veryShortSymbols.first?.count == 1)
    }

    @Test("WeekdaySymbolType respects firstWeekday setting")
    func weekdaySymbolTypeRespectsFirstWeekday() {
        var mondayCalendar = Calendar(identifier: .gregorian)
        mondayCalendar.timeZone = TimeZone(identifier: "UTC")!
        mondayCalendar.locale = Locale(identifier: "en_US")
        mondayCalendar.firstWeekday = 2

        let sundayShortSymbols = WeekdaySymbolType.short.getSymbols(from: calendar)
        let mondayShortSymbols = WeekdaySymbolType.short.getSymbols(from: mondayCalendar)

        #expect(sundayShortSymbols.first == "Sun")
        #expect(mondayShortSymbols.first == "Mon")

        #expect(sundayShortSymbols.count == 7)
        #expect(mondayShortSymbols.count == 7)
    }

    @Test("WeekdaySymbolType uses standalone symbols")
    func weekdaySymbolTypeUsesStandaloneSymbols() {
        let fullSymbols = WeekdaySymbolType.full.getSymbols(from: calendar)
        let shortSymbols = WeekdaySymbolType.short.getSymbols(from: calendar)
        let veryShortSymbols = WeekdaySymbolType.veryShort.getSymbols(from: calendar)

        let expectedFull = calendar.standaloneWeekdaySymbols
        let expectedShort = calendar.shortStandaloneWeekdaySymbols
        let expectedVeryShort = calendar.veryShortStandaloneWeekdaySymbols

        #expect(fullSymbols == expectedFull)
        #expect(shortSymbols == expectedShort)
        #expect(veryShortSymbols == expectedVeryShort)
    }
}
