# CalendarBuildingKit

**📅 A Swift library providing minimal components for building calendar views**

CalendarBuildingKit provides essential logic for constructing calendar views. It generates structured calendar data (months, weeks, days), allowing you to focus on designing your calendar UI.

## 🚀 Quick Start

### Installation

Add CalendarBuildingKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/CalendarBuildingKit", from: "0.1.0")
]
```

### Basic Usage

> [!NOTE]
> These are minimal examples. You can style them any way you want - add backgrounds, spacing, animations, and custom layouts.

#### Month Calendar

```swift
MonthCalendarsBuilder(range: start...end) { status, weekdaySymbols in
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
```

#### Week Calendar

```swift
WeekCalendarsBuilder(range: start...end) { status, weekdaySymbols in
    TabView(selection: $selectedWeek) {
        ForEach(status.data) { week in
            VStack {
                HStack {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                    }
                }
                HStack {
                    ForEach(week.days) { day in
                        Text(day.day.description)
                            .foregroundStyle(day.month == week.month ? .primary : .secondary)
                    }
                }
            }
            .tag(week)
        }
    }
    .tabViewStyle(.page)
}
```

## 📖 API Reference

### MonthCalendarsBuilder

Creates month-based calendar layouts with the following parameters:

```swift
MonthCalendarsBuilder(
    range: ClosedRange<Date>,          // Required: Date range to display
    calendar: Calendar = .current,     // Optional: Calendar configuration
    symbols: WeekdaySymbolType = .short, // Optional: Weekday symbol style
    onLoaded: (([MonthContext]) -> Void)? = nil // Optional: Load completion callback
) { loadStatus, weekdaySymbols in
    // Your calendar UI implementation
}
```

### WeekCalendarsBuilder

Creates week-based calendar layouts with the same parameter structure as `MonthCalendarsBuilder`, but returns `WeekContext` objects.

### WeekdaySymbolType

The `symbols` parameter in both builders accepts a `WeekdaySymbolType` enum to control weekday display format:

```swift
MonthCalendarsBuilder(
    range: dateRange,
    symbols: .short
) { status, weekdaySymbols in
    // weekdaySymbols array contains localized symbols
}
```

**Available options:**
- `.full` - Full standalone weekday names: "Sunday", "Monday", "Tuesday"...
- `.short` - Short standalone weekday names: "Sun", "Mon", "Tue"... (default)
- `.veryShort` - Minimal standalone weekday names: "S", "M", "T"...

The symbols are retrieved from Foundation's `Calendar.standaloneWeekdaySymbols`, automatically reordered based on `firstWeekday` setting, and fully localized according to the calendar's locale.

## 💡 Example Project

See the [Example project](./Example)
