struct HighwayInfoPayload: Codable {
    let highwayVignettes: [HighwayVignette]
    let vehicleCategories: [VehicleCategoryInfo]
    let counties: [County]
}
