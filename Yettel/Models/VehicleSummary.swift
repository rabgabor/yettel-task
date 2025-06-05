struct VehicleSummary {
    let plateText: String
    let ownerName: String
    let iconName: String
}

extension VehicleSummary {
    init(response: VehicleInfoResponse) {
        self.plateText = response.plate.uppercased()
        self.ownerName = response.name
        self.iconName = VehicleSummary.icon(for: response.type)
    }
    
    private static func icon(for category: VehicleCategory) -> String {
        switch category {
        case .car:
            "car.fill"
        case .motorcycle:
            "scooter"
        case .truck:
            "box.truck.fill"
        }
    }
}

// For SwiftUI preview

#if DEBUG
extension VehicleSummary {
    static let sample = VehicleSummary(plateText: "ABC-123",
                                       ownerName: "Michael Scott",
                                       iconName: "car.fill")
}
#endif
