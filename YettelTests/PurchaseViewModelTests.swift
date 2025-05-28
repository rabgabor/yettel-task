import XCTest
@testable import Yettel

@MainActor
final class PurchaseViewModelTests: XCTestCase {

    private struct SuccessMockService: HighwayAPIService {
        func fetchVehicleInfo() async throws -> VehicleInfoResponse { fatalError() }
        func fetchHighwayInfo() async throws -> HighwayInfoResponse { fatalError() }
        func placeHighwayOrder(_ request: HighwayOrderRequest) async throws -> HighwayOrderResponse {
            HighwayOrderResponse(statusCode: .ok, receivedOrders: request.highwayOrders)
        }
    }

    private struct FailingMockService: HighwayAPIService {
        enum Dummy: Error { case fail }
        func fetchVehicleInfo() async throws -> VehicleInfoResponse { fatalError() }
        func fetchHighwayInfo() async throws -> HighwayInfoResponse { fatalError() }
        func placeHighwayOrder(_ request: HighwayOrderRequest) async throws -> HighwayOrderResponse {
            throw Dummy.fail
        }
    }

    private let nationalVignette = NationalVignetteOption(
        id: "CAR-DAY",
        code: "D1",
        duration: "Napi",
        sum: 5_000,
        trxFee: 150,
        vehicleCategory: "CAR",
        vignetteType: "DAY"
    )
    
    private let countyVignette = CountyVignetteOption(
        id: "YEAR_11",
        countyName: "Bács-Kiskun",
        sum: 49_000,
        trxFee: 200,
        vehicleCategory: "CAR"
    )

    func testCalculations_areCorrect() {
        let viewModel = PurchaseViewModel(plate: "ABC-123",
                                          vignetteTypeText: "Vegyes",
                                          selectedVignettes: [nationalVignette, countyVignette],
                                          api: SuccessMockService()
        )
        
        XCTAssertEqual(viewModel.totalFee, 350)
        XCTAssertEqual(viewModel.totalSum, 54_000)
        XCTAssertEqual(viewModel.rows.count, 3)
        XCTAssertEqual(viewModel.rows[0].title, nationalVignette.displayTitle)
        XCTAssertEqual(viewModel.rows[1].title, countyVignette.displayTitle)
    }
    
    func testPurchase_setsShowSuccess() async {
        let viewModel = PurchaseViewModel(plate: "ABC-123",
                                          vignetteTypeText: "Országos",
                                          selectedVignettes: [nationalVignette],
                                          api: SuccessMockService()
        )
        
        await viewModel.purchase()
        XCTAssertTrue(viewModel.showSuccess)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testPurchase_setsErrorOnFailure() async {
        let viewModel = PurchaseViewModel(plate: "ABC-123",
                                          vignetteTypeText: "Országos",
                                          selectedVignettes: [nationalVignette],
                                          api: FailingMockService()
        )
        
        await viewModel.purchase()
        XCTAssertFalse(viewModel.showSuccess)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
