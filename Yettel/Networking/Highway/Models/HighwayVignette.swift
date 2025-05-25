struct HighwayVignette: Codable {
    let vignetteType: [VignetteType]
    let vehicleCategory: VehicleCategory
    let cost: Double
    let trxFee: Double
    let sum: Double
}
