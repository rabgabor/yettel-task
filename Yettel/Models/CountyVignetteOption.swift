struct CountyVignetteOption: Identifiable {
    let id: String
    let countyName: String
    let price: String
}

extension CountyVignetteOption {
    static func from(_ response: HighwayVignette,
                     countyName: String,
                     overrideID: String) -> Self {

        .init(id: overrideID,
              countyName: countyName,
              price: priceString(response.sum))
    }
}

// For SwiftUI preview

#if DEBUG
extension CountyVignetteOption {
    static let sample = CountyVignetteOption(id: "YEAR_11", countyName: "Békés", price: "6080 Ft")
}
#endif
