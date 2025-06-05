import Foundation

/// Represents the loading state of calendar data
@dynamicMemberLookup
public enum LoadStatus<Context: CalendarLoadable>: Sendable {
    /// Data is currently being loaded
    case loading
    /// Data has been loaded successfully
    case loaded([Context])

    /// Dynamic member lookup to access loaded data directly
    public subscript(dynamicMember keyPath: KeyPath<Self, [Context]>) -> [Context] {
        get {
            switch self {
            case .loading:
                []
            case .loaded(let contexts):
                contexts
            }
        }
        set {
            self = .loaded(newValue)
        }
    }

    /// Returns the loaded data or empty array if still loading
    public var data: [Context] {
        switch self {
        case .loading:
            []
        case .loaded(let array):
            array
        }
    }
}
