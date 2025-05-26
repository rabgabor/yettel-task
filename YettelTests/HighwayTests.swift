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
    
    func testCountyVignetteMapping() {
        let response = HighwayVignette(vignetteType: [.year11],
                                       vehicleCategory: .car,
                                       cost: 9_000,
                                       trxFee: 0,
                                       sum: 9_000)

        let option = CountyVignetteOption.from(response,
                                            countyName: "Bács-Kiskun",
                                            overrideID: "YEAR_11")

        XCTAssertEqual(option.id, "YEAR_11")
        XCTAssertEqual(option.countyName, "Bács-Kiskun")
        XCTAssertEqual(option.price.filter { !$0.isWhitespace }, "9000Ft")
    }
    
    @MainActor
    func testCountySelectionViewModel() {
        let options: [CountyVignetteOption] = [
            .init(id: "YEAR_11", countyName: "Bács-Kiskun", price: "9 000 Ft"),
            .init(id: "YEAR_12", countyName: "Baranya", price: "9 000 Ft"),
            .init(id: "YEAR_13", countyName: "Békés", price: "9 000 Ft")
        ]

        let viewModel = CountySelectionViewModel(options: options)

        XCTAssertFalse(viewModel.hasIsolatedSelection)
        XCTAssertEqual(viewModel.totalPrice, 0)

        viewModel.toggle("YEAR_11")
        XCTAssertFalse(viewModel.hasIsolatedSelection)
        XCTAssertEqual(viewModel.totalPrice, 9_000)

        viewModel.toggle("YEAR_12")
        XCTAssertFalse(viewModel.hasIsolatedSelection)
        XCTAssertEqual(viewModel.totalPrice, 18_000)

        viewModel.toggle("YEAR_13")
        XCTAssertTrue(viewModel.hasIsolatedSelection)
        XCTAssertEqual(viewModel.totalPrice, 27_000)

        viewModel.toggle("YEAR_13")
        XCTAssertFalse(viewModel.hasIsolatedSelection)
        XCTAssertEqual(viewModel.totalPrice, 18_000)
    }
}
