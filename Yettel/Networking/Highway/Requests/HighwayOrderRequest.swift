struct HighwayOrderRequest: Codable {
    struct Order: Codable {
        let type: VignetteType
        let category: VehicleCategory
        let cost: Double
    }
    
    let highwayOrders: [Order]
}
