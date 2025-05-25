protocol HighwayAPIService {
    func fetchHighwayInfo() async throws -> HighwayInfoResponse
    func fetchVehicleInfo() async throws -> VehicleInfoResponse
    func placeHighwayOrder(_ request: HighwayOrderRequest) async throws -> HighwayOrderResponse
}
