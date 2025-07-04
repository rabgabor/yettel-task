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
        
        XCTAssertEqual(summary.plateText, "XYZ-987")
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
        let viewModel = VehicleViewModel(apiService: MockHighwayService())
        
        await viewModel.load()
        
        XCTAssertEqual(viewModel.vehicleSummary?.plateText, "ABC-123")
        XCTAssertEqual(viewModel.nationalVignetteOptions.count, 1)
        XCTAssertEqual(viewModel.countyVignetteOptions.first?.countyName, "Bács-Kiskun")
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
            .init(id: "YEAR_11", countyName: "Bács-Kiskun", sum: 9000, trxFee: 0, vehicleCategory: "CAR"),
            .init(id: "YEAR_12", countyName: "Baranya", sum: 9000, trxFee: 0, vehicleCategory: "CAR"),
            .init(id: "YEAR_13", countyName: "Békés", sum: 9000, trxFee: 0, vehicleCategory: "CAR")
        ]

        let viewModel = CountySelectionViewModel(options: options, plate: "ABC-123")

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

extension VehicleViewModel {
    convenience init(apiService: HighwayAPIService) {
        self.init()
        self.apiService = apiService
    }
}
