
# 📅 CalendarBuildingKit

**A Swift library providing minimal components for building calendar views**

CalendarBuildingKit provides a lightweight and structured foundation to build custom calendar views. It focuses on generating and managing calendar data such as **months**, **weeks**, and **days**, allowing you to focus entirely on the UI.

## 🚀 Basic Usage

> [!NOTE]
> These are minimal examples. You can style them any way you want - add backgrounds, spacing, animations, and custom layouts.

### 📆 Month-Based Calendar

```swift
MonthCalendarsBuilder(range: start...end) { status, weekdaySymbols in
    TabView {
        ForEach(status.data) { month in
            VStack {
                // Display weekday symbols (Mon, Tue, Wed, etc.) as header
                HStack {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                    }
                }
                ForEach(month.weeks) { week in
                    HStack {
                        ForEach(week.days) { day in
                            Text(day.day.description)
                                // Show current month days in primary color, other months in secondary
                                .foregroundStyle(day.month == month.month ? .primary : .secondary)
                        }
                    }
                }
            }
        }
    }
}
````

### 📅 Week-Based Calendar

```swift
WeekCalendarsBuilder(range: start...end) { status, weekdaySymbols in
    TabView {
        ForEach(status.data) { week in
            VStack {
                // Display weekday symbols (Mon, Tue, Wed, etc.) as header
                HStack {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                    }
                }
                HStack {
                    ForEach(week.days) { day in
                        Text(day.day.description)
                            // Show current month days in primary color, other months in secondary
                            .foregroundStyle(day.month == week.month ? .primary : .secondary)
                    }
                }
            }
        }
    }
}
```

## 🧩 Core APIs

### `MonthCalendarsBuilder`

A SwiftUI view builder that renders calendar UIs based on full months.

```swift
MonthCalendarsBuilder(
    range: ClosedRange<Date>,                // The date range to display
    calendar: Calendar = .current,           // (Optional) Custom calendar configuration
    symbols: WeekdaySymbolType = .short,     // (Optional) Symbol format
    onLoaded: (([MonthContext]) -> Void)?    // (Optional) Callback after loading
) { loadStatus, weekdaySymbols in
    // Your calendar layout here
}
```

### `WeekCalendarsBuilder`

Same as above, but for week-based layouts.

```swift
WeekCalendarsBuilder(
    range: ClosedRange<Date>,
    calendar: Calendar = .current,
    symbols: WeekdaySymbolType = .short,
    onLoaded: (([WeekContext]) -> Void)? = nil
) { loadStatus, weekdaySymbols in
    // Your week calendar layout here
}
```

#### `WeekdaySymbolType`

The `symbols` parameter in both builders controls how weekday headers are displayed:

```swift
enum WeekdaySymbolType {
    case full        // "Sunday", "Monday", ...
    case short       // "Sun", "Mon", ...   (default)
    case veryShort   // "S", "M", ...
}
```

Symbols are fully localized and automatically reordered based on the calendar's `firstWeekday`.

## ⚙️ CalendarGenerator

`CalendarGenerator` is a standalone utility that produces structured calendar data (`MonthContext`, `WeekContext`, etc.). This is ideal when building calendar UIs in **UIKit** or using the calendar logic outside of SwiftUI.

```swift
// Initialize the calendar generator
let generator = CalendarGenerator()

// Generate multiple months of calendar data for a date range
let months = generator.generateMonthContexts(for: startDate...endDate)

// Generate multiple weeks of calendar data for a date range
let weeks = generator.generateWeekContexts(for: startDate...endDate)

// Generate calendar data for a single specific month
let singleMonth = generator.generateMonthContext(for: someDate)

// Generate calendar data for a single specific week
let singleWeek = generator.generateWeekContext(for: someDate)
```

## 📁 Example
See the [Example project](./Example)
