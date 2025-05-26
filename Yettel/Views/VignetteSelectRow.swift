import SwiftUI

struct VignetteSelectRow: View {
    let nationalVignetteOption: NationalVignetteOption
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .frame(width: 20)
                .foregroundColor(isSelected ? .accentColor : .secondary)

            Text("\(nationalVignetteOption.code) - \(nationalVignetteOption.duration)")
            Spacer(minLength: 12)
            Text(nationalVignetteOption.price)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    VignetteSelectRow(nationalVignetteOption: .sample, isSelected: true)
    VignetteSelectRow(nationalVignetteOption: .sample, isSelected: false)
}
