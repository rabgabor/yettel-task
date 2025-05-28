struct HighwayOrderResponse: Codable {
    let statusCode: StatusCode
    let receivedOrders: [Order]
}
