import XCTest
@testable import Yettel

final class HighwayTests: XCTestCase {
    func testVehicleSummaryInit() {
        let response = VehicleInfoResponse(statusCode: .ok,
                                           internationalRegistrationCode: "H",
                                           type: .car,
                                           name: "Pam Beesly",
                                           plate: "xyz-987",
                                           country: .init(hu: "Magyarország", en: "Hungary"),
                                           vignetteType: .d1)
        
        let summary = VehicleSummary(response: response)
        
        XCTAssertEqual(summary.plate, "XYZ-987")
        XCTAssertEqual(summary.ownerName, "Pam Beesly")
        XCTAssertEqual(summary.iconName, "car.fill")
    }
    
    func testNationalVignetteMapping() {
        let carVignette = HighwayVignette(vignetteType: [.day],
                                          vehicleCategory: .car,
                                          cost: 5400,
                                          trxFee: 0,
                                          sum: 5400)
        
        let option = NationalVignetteOption.from(carVignette, code: "D1")
        
        XCTAssertEqual(option.id, "CAR-DAY")
        XCTAssertEqual(option.code, "D1")
        XCTAssertEqual(option.duration, "Napi")
        XCTAssertEqual(option.price.filter { !$0.isWhitespace }, "5400Ft")
    }
    
    @MainActor
    func testLoadPopulatesState() async throws {
        let vm = VehicleViewModel(api: MockHighwayService())
        
        await vm.load()
        
        XCTAssertEqual(vm.vehicleSummary?.plate, "ABC-123")
        XCTAssertEqual(vm.nationalVignetteOptions.count, 1)
        XCTAssertEqual(vm.countyVignetteOptions.first?.countyName, "Bács-Kiskun")
    }
}
