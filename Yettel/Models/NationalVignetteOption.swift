struct NationalVignetteOption: Identifiable {
    let id: String
    let code: String
    let duration: String
    let sum: Double
    let trxFee: Double
    let vehicleCategory: String
    let vignetteType: String
    
    var price: String { priceString(sum) }
    
    static func from(_ response: HighwayVignette, code: String) -> Self {
        .init(id: "\(response.vehicleCategory.rawValue)-\(response.vignetteType.first!.rawValue)",
              code: code,
              duration: durationText(for: response.vignetteType.first!),
              sum: response.sum,
              trxFee: response.trxFee,
              vehicleCategory: response.vehicleCategory.rawValue,
              vignetteType: response.vignetteType.first!.rawValue)
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

extension NationalVignetteOption: VignetteOptionProtocol {
    var displayTitle: String { "\(code) – \(duration)" }
}

// For SwiftUI preview

#if DEBUG
extension NationalVignetteOption {
    static let sample = NationalVignetteOption(id: "D1-WEEK",
                                               code: "D1",
                                               duration: "Napi",
                                               sum: 5000.0,
                                               trxFee: 0.0,
                                               vehicleCategory: "CAR",
                                               vignetteType: "WEEK")
}
#endif
