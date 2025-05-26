import SwiftUI

struct VehicleSummaryRow: View {
    let vehicleSummary: VehicleSummary

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: vehicleSummary.iconName)
                .font(.system(size: 28))
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 4) {
                Text(vehicleSummary.plate)
                    .font(.headline)
                Text(vehicleSummary.ownerName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VehicleSummaryRow(vehicleSummary: .sample)
}
