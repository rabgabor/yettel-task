import XCTest
@testable import Yettel

final class HighwayAPIClientTests: XCTestCase {

    func testFetchHighwayInfo_decodesPayload() async throws {
        let mock = MockHTTPClient(nextData: .highwayInfo)
        let api  = HighwayAPIClient(baseURL: URL(string: "http://test.local")!, http: mock)

        let info = try await api.fetchHighwayInfo()

        XCTAssertEqual(info.payload.highwayVignettes.first?.vignetteType, [VignetteType.day, VignetteType.week, VignetteType.month, VignetteType.year])
        XCTAssertEqual(info.payload.vehicleCategories.map(\.category), [.car, .motorcycle, .truck])
        XCTAssertEqual(info.payload.counties.count, 3)
        XCTAssertEqual(info.payload.counties.first?.id, .year11)
    }

    func testFetchVehicleInfo_decodesVehicle() async throws {
        let mock = MockHTTPClient(nextData: .vehicleInfo)
        let api  = HighwayAPIClient(baseURL: URL(string: "http://test.local")!, http: mock)
        
        let vehicle = try await api.fetchVehicleInfo()

        XCTAssertEqual(vehicle.type, .car)
        XCTAssertEqual(vehicle.plate, "abc-123")
    }

    func testPlaceHighwayOrder_sendsBodyAndReturnsEcho() async throws {
        let mock = MockHTTPClient(nextData: .orderAccepted)
        let api  = HighwayAPIClient(baseURL: URL(string: "http://test.local")!, http: mock)

        let orders = [HighwayOrderRequest.Order(type: .day, category: .car, cost: 5000.0),
                      HighwayOrderRequest.Order(type: .week, category: .car, cost: 900.0)]
        
        let ordered = try await api.placeHighwayOrder(HighwayOrderRequest(highwayOrders: orders))

        XCTAssertEqual(ordered.receivedOrders.count, 2)
        XCTAssertEqual(mock.lastRequest?.httpMethod, "POST")
        XCTAssertNotNil(mock.lastRequest?.httpBody)     // we sent JSON
    }
    
    func test_non2xxStatus_throws() async {
        let mock = MockHTTPClient(nextData: .errorPayload, status: 500)
        let api  = HighwayAPIClient(baseURL: URL(string: "http://test.local")!, http: mock)

        await XCTAssertThrowsErrorAsync {
            _ = try await api.fetchHighwayInfo()
        } verify: { error in
            guard case HighwayAPIError.invalidStatus(let code) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(code, 500)
        }
    }
}

func XCTAssertThrowsErrorAsync(_ expression: @escaping () async throws -> Void,
                               verify: (Error) -> Void,
                               file: StaticString = #filePath,
                               line: UInt = #line) async {
    do {
        try await expression()
        XCTFail("Expected error was not thrown", file: file, line: line)
    } catch {
        verify(error)
    }
}
