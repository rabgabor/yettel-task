import SwiftUI

struct CountyRow: View {
    let option: CountyVignetteOption
    let isSelected: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                Text(option.countyName)
                Spacer()
                Text(option.price)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CountyRow(option: .sample, isSelected: true, toggle: {})
    CountyRow(option: .sample, isSelected: false, toggle: {})
}
