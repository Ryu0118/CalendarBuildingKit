import SwiftUI

/// SwiftUI view builder for month-based calendar layouts
public struct MonthCalendarsBuilder<Content: View>: View {
    let model: MonthCalendarsModel
    let symbolType: WeekdaySymbolType
    let content: (LoadStatus<MonthContext>, [String]) -> Content
    let onLoaded: (([MonthContext]) -> Void)?

    /// Creates a month calendar builder
    /// - Parameters:
    ///   - range: Date range to display months for
    ///   - calendar: Calendar to use for date calculations (defaults to current calendar)
    ///   - symbols: Type of weekday symbols to use
    ///   - onLoaded: Optional callback called when months are loaded with the loaded month contexts
    ///   - content: View builder that receives load status, month contexts, and weekday symbols array
    public init(
        range: ClosedRange<Date>,
        calendar: Calendar = .current,
        symbols: WeekdaySymbolType = .short,
        onLoaded: (([MonthContext]) -> Void)? = nil,
        @ViewBuilder content: @escaping (LoadStatus<MonthContext>, [String]) -> Content
    ) {
        let generator = CalendarGenerator(calendar: calendar)
        self.model = MonthCalendarsModel(range: range, generator: generator)
        self.symbolType = symbols
        self.onLoaded = onLoaded
        self.content = content
    }

    public var body: some View {
        Group {
            content(model.loadStatus, symbolType.getSymbols(from: model.calendar))
        }
        .task(id: model.range) {
            await model.loadMonths()
            if case .loaded(let contexts) = model.loadStatus {
                onLoaded?(contexts)
            }
        }
    }
}

/// SwiftUI view builder for week-based calendar layouts
public struct WeekCalendarsBuilder<Content: View>: View {
    let model: WeekCalendarsModel
    let symbolType: WeekdaySymbolType
    let content: (LoadStatus<WeekContext>, [String]) -> Content
    let onLoaded: (([WeekContext]) -> Void)?

    /// Creates a week calendar builder
    /// - Parameters:
    ///   - range: Date range to display weeks for
    ///   - calendar: Calendar to use for date calculations (defaults to current calendar)
    ///   - symbols: Type of weekday symbols to use
    ///   - onLoaded: Optional callback called when weeks are loaded with the loaded week contexts
    ///   - content: View builder that receives load status, week contexts, and weekday symbols array
    public init(
        range: ClosedRange<Date>,
        calendar: Calendar = .current,
        symbols: WeekdaySymbolType = .short,
        onLoaded: (([WeekContext]) -> Void)? = nil,
        @ViewBuilder content: @escaping (LoadStatus<WeekContext>, [String]) -> Content
    ) {
        let generator = CalendarGenerator(calendar: calendar)
        self.model = WeekCalendarsModel(range: range, generator: generator)
        self.symbolType = symbols
        self.onLoaded = onLoaded
        self.content = content
    }

    public var body: some View {
        Group {
            content(model.loadStatus, symbolType.getSymbols(from: model.calendar))
        }
        .task(id: model.range) {
            await model.loadWeeks()
            if case .loaded(let contexts) = model.loadStatus {
                onLoaded?(contexts)
            }
        }
    }
}
