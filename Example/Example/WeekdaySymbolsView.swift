import SwiftUI

struct WeekdaySymbolsView: View {
    let weekdaySymbols: [String]

    var body: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
        }
    }
}
