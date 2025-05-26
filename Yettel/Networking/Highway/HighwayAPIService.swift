protocol HighwayAPIService {
    func fetchHighwayInfo() async throws -> HighwayInfoResponse
    func fetchVehicleInfo() async throws -> VehicleInfoResponse
    func placeHighwayOrder(_ request: HighwayOrderRequest) async throws -> HighwayOrderResponse
}

#if DEBUG
struct MockHighwayService: HighwayAPIService {

    func fetchVehicleInfo() async throws -> VehicleInfoResponse {
        VehicleInfoResponse(
            statusCode: .ok,
            internationalRegistrationCode: "H",
            type: .car,
            name: "Michael Scott",
            plate: "abc-123",
            country: .init(hu: "Magyarország", en: "Hungary"),
            vignetteType: .d1
        )
    }

    func fetchHighwayInfo() async throws -> HighwayInfoResponse {
        HighwayInfoResponse(
            requestId: 123456,
            statusCode: .ok,
            payload: .init(
                highwayVignettes: [
                    .init(
                        vignetteType: [.day, .week, .month, .year],
                        vehicleCategory: .car,
                        cost: 5400, trxFee: 200, sum: 5600
                    ),
                    .init(
                        vignetteType: [.year11],
                        vehicleCategory: .car,
                        cost: 49000, trxFee: 0, sum: 49000
                    )
                ],
                vehicleCategories: [
                    .init(category: .car, vignetteCategory: .d1,
                          name: .init(hu: "Személygépjármű", en: "Car"))
                ],
                counties: [
                    .init(id: .year11, name: "Bács-Kiskun")
                ]
            )
        )
    }

    func placeHighwayOrder(_ order: HighwayOrderRequest) async throws -> HighwayOrderResponse {
        HighwayOrderResponse(statusCode: .ok, receivedOrders: order.highwayOrders)
    }
}
#endif
