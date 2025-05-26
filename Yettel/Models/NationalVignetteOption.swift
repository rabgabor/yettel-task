struct NationalVignetteOption: Identifiable {
    let id: String
    let code: String
    let duration: String
    let price: String
}

extension NationalVignetteOption {
    static func from(_ response: HighwayVignette, code: String) -> Self {
        .init(id: "\(response.vehicleCategory.rawValue)-\(response.vignetteType.first!.rawValue)",
              code: code,
              duration: durationText(for: response.vignetteType.first!),
              price: priceString(response.sum))
    }
    
    static func durationText(for type: VignetteType) -> String {
        switch type {
        case .day:
            "Napi"
        case .week:
            "Heti (10 napos)"
        case .month:
            "Havi"
        case .year:
            "Éves"
        default:
            type.rawValue
        }
    }
}

// For SwiftUI preview

#if DEBUG
extension NationalVignetteOption {
    static let sample = NationalVignetteOption(id: "D1-WEEK", code: "D1", duration: "Napi", price: "5000 Ft")
}
#endif
