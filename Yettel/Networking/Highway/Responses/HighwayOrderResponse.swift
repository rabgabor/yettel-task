struct HighwayOrderResponse: Codable {
    let statusCode: StatusCode
    let receivedOrders: [HighwayOrderRequest.Order]
}
