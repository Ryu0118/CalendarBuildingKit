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

    @Test("AdjustedWeekdaySymbols returns correct symbol arrays")
    func adjustedWeekdaySymbolsReturnsCorrectArrays() {
        let adjustedSymbols = AdjustedWeekdaySymbols(calendar: calendar)

        let fullSymbols = adjustedSymbols.getSymbols(for: .full)
        let shortSymbols = adjustedSymbols.getSymbols(for: .short)
        let veryShortSymbols = adjustedSymbols.getSymbols(for: .veryShort)

        #expect(fullSymbols.count == 7)
        #expect(shortSymbols.count == 7)
        #expect(veryShortSymbols.count == 7)

        #expect(fullSymbols.first == "Sunday")
        #expect(shortSymbols.first == "Sun")
        #expect(veryShortSymbols.first?.count == 1)
    }

    @Test("AdjustedWeekdaySymbols respects firstWeekday setting")
    func adjustedWeekdaySymbolsRespectsFirstWeekday() {
        var mondayCalendar = Calendar(identifier: .gregorian)
        mondayCalendar.timeZone = TimeZone(identifier: "UTC")!
        mondayCalendar.locale = Locale(identifier: "en_US")
        mondayCalendar.firstWeekday = 2

        let sundaySymbols = AdjustedWeekdaySymbols(calendar: calendar)
        let mondaySymbols = AdjustedWeekdaySymbols(calendar: mondayCalendar)

        let sundayShortSymbols = sundaySymbols.getSymbols(for: .short)
        let mondayShortSymbols = mondaySymbols.getSymbols(for: .short)

        #expect(sundayShortSymbols.first == "Sun")
        #expect(mondayShortSymbols.first == "Mon")

        #expect(sundayShortSymbols.count == 7)
        #expect(mondayShortSymbols.count == 7)
    }

    @Test("AdjustedWeekdaySymbols uses standalone symbols")
    func adjustedWeekdaySymbolsUsesStandaloneSymbols() {
        let adjustedSymbols = AdjustedWeekdaySymbols(calendar: calendar)

        let fullSymbols = adjustedSymbols.getSymbols(for: .full)
        let shortSymbols = adjustedSymbols.getSymbols(for: .short)
        let veryShortSymbols = adjustedSymbols.getSymbols(for: .veryShort)

        let expectedFull = calendar.standaloneWeekdaySymbols
        let expectedShort = calendar.shortStandaloneWeekdaySymbols
        let expectedVeryShort = calendar.veryShortStandaloneWeekdaySymbols

        #expect(fullSymbols == expectedFull)
        #expect(shortSymbols == expectedShort)
        #expect(veryShortSymbols == expectedVeryShort)
    }
}
