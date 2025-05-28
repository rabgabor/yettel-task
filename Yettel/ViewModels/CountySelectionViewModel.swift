import SwiftUI

@MainActor
final class CountySelectionViewModel: ObservableObject {
    @Published private(set) var options: [CountyVignetteOption]
    @Published var selectedIDs: Set<String> = []
    
    let plate: String
    
    var hasIsolatedSelection = false
    var totalPrice = 0
    var totalPriceText = priceString(0.0)
    
    init(options: [CountyVignetteOption], plate: String) {
        self.options = options
        self.plate = plate
    }

    func toggle(_ id: String) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
        
        calculateTotalPrice()
        calculateTotalPriceText()
        calculateIsolatedSelection()
    }

    func isSelected(_ id: String) -> Bool {
        selectedIDs.contains(id)
    }
    
    private func calculateIsolatedSelection() {
        hasIsolatedSelection = false

        guard selectedIDs.count > 1 else { return }

        for id in selectedIDs {
            let neighbours = CountyAdjacency.map[id] ?? []
            if neighbours.intersection(selectedIDs.subtracting([id])).isEmpty {
                hasIsolatedSelection = true
                break
            }
        }
    }
    
    private func calculateTotalPrice() {
        totalPrice = options.filter { selectedIDs.contains($0.id) }
            .compactMap { Int($0.price.filter(\.isNumber)) }
            .reduce(0, +)
    }
    
    private func calculateTotalPriceText() {
        totalPriceText = priceString(Double(totalPrice))
    }
}
