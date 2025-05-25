struct HighwayInfoResponse: Codable {
    let requestId: Int
    let statusCode: StatusCode
    let payload: HighwayInfoPayload
}
