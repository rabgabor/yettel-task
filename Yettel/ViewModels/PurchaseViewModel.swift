import SwiftUI

@MainActor
final class PurchaseViewModel: ObservableObject {
    
    struct Row: Identifiable {
        let id    = UUID()
        let title: String
        let price: String
    }
    
    private let api: HighwayAPIService
    private let vehiclePlate: String
    private let vignetteTypeText: String
    private let selectedVignettes: [any VignetteOptionProtocol]
    
    var plateText: String { vehiclePlate }
    var typeText:  String { vignetteTypeText }

    @Published var isBusy = false
    @Published var showSuccess = false
    @Published var errorMessage: String?

    var rows: [Row] {
        selectedVignettes.enumerated().map { idx, vignette in
            let title = vignette.displayTitle
            return Row(title: title, price: priceString(vignette.sum))
        }
        +
        [Row(title: "Ebből rendszerhasználati díj", price: priceString(totalFee))]
    }

    var totalFee: Double {
        selectedVignettes.map(\.trxFee).reduce(0,+)
    }
    
    var totalSum: Double {
        selectedVignettes.map(\.sum).reduce(0,+)
    }
    
    var totalPayableText: String {
        priceString(totalSum)
    }

    init(plate: String,
         vignetteTypeText: String,
         selectedVignettes: [VignetteOptionProtocol],
         api: HighwayAPIService = HighwayAPIClient()) {
        self.vehiclePlate      = plate
        self.vignetteTypeText  = vignetteTypeText
        self.selectedVignettes = selectedVignettes
        self.api = api
    }

    func purchase() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }

        do {
            let order = HighwayOrderRequest(highwayOrders: selectedVignettes.map {
                .init(type: VignetteType(rawValue: $0.vignetteType)!,
                      category: VehicleCategory(rawValue: $0.vehicleCategory)!,
                      cost: $0.sum)})
            
            _ = try await api.placeHighwayOrder(order)
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
