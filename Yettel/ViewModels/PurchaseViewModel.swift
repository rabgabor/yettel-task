import Foundation
import Observation

@Observable
final class PurchaseViewModel {
    
    struct Row: Identifiable {
        let id = UUID()
        let title: String
        let price: String
    }
    
    var apiService: HighwayAPIService?
    private(set) var vehiclePlateText: String
    private(set) var vignetteTypeText: String
    private let selectedVignettes: [any VignetteOptionProtocol]
    
    var isBusy = false
    var showSuccess = false
    var errorMessage: String?

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

    init(vehiclePlateText: String,
         vignetteTypeText: String,
         selectedVignettes: [VignetteOptionProtocol]) {
        self.vehiclePlateText = vehiclePlateText
        self.vignetteTypeText = vignetteTypeText
        self.selectedVignettes = selectedVignettes
    }

    func purchase() async {
        guard !isBusy, let apiService = apiService else { return }
        
        isBusy = true
        defer { isBusy = false }

        do {
            let order = HighwayOrderRequest(highwayOrders: selectedVignettes.map {
                .init(type: VignetteType(rawValue: $0.vignetteType)!,
                      category: VehicleCategory(rawValue: $0.vehicleCategory)!,
                      cost: $0.sum)})
            
            _ = try await apiService.placeHighwayOrder(order)
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
