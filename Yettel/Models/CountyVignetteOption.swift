struct CountyVignetteOption: Identifiable {
    let id: String
    let countyName: String
    let price: String
}

extension CountyVignetteOption {
    static func from(_ response: HighwayVignette, countyName: String) -> Self {
        .init(id: response.vignetteType.first!.rawValue,
              countyName: countyName,
              price: priceString(response.sum))
    }
}
