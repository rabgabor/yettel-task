struct CountyVignetteOption: Identifiable {
    let id: String
    let countyName: String
    let sum: Double
    let trxFee: Double
    let vehicleCategory: String
    
    var price: String { priceString(sum) }
    
    static func from(_ response: HighwayVignette,
                     countyName: String,
                     overrideID: String) -> Self {

        .init(id: overrideID,
              countyName: countyName,
              sum: response.sum,
              trxFee: response.trxFee,
              vehicleCategory: response.vehicleCategory.rawValue)
    }
}

extension CountyVignetteOption: VignetteOptionProtocol {
    var vignetteType: String { id }
    var displayTitle: String { countyName }
}

// For SwiftUI preview

#if DEBUG
extension CountyVignetteOption {
    static let sample = CountyVignetteOption(id: "YEAR_11",
                                             countyName: "Békés",
                                             sum: 6080.0,
                                             trxFee: 0.0,
                                             vehicleCategory: "CAR")
}
#endif
