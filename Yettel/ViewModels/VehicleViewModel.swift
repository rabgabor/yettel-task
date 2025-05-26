import SwiftUI

@MainActor
final class VehicleViewModel: ObservableObject {
    @Published var vehicleSummary: VehicleSummary?
    @Published var nationalVignetteOptions: [NationalVignetteOption] = []
    @Published var countyVignetteOptions: [CountyVignetteOption] = []
    @Published var errorMessage: String?
    
    var defaultOptionID: String? {
        nationalVignetteOptions.first?.id
    }
    
    private let api: HighwayAPIService
    private(set) var hasLoaded = false
    
    init(api: HighwayAPIService = HighwayAPIClient()) {
        self.api = api
    }
    
    func load() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        
        do {
            async let vehicleResponse  = api.fetchVehicleInfo()
            async let highwayResponse  = api.fetchHighwayInfo()
            
            let (vehicle, highway) = try await (vehicleResponse, highwayResponse)
            
            vehicleSummary = VehicleSummary(response: vehicle)
            nationalVignetteOptions = Self.makeNational(from: highway)
            countyVignetteOptions = Self.makeCounty(from: highway)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

extension VehicleViewModel {
    private static func makeNational(from response: HighwayInfoResponse) -> [NationalVignetteOption] {
        let codeLookup = Dictionary(uniqueKeysWithValues: response.payload.vehicleCategories.map { ($0.category, $0.vignetteCategory.rawValue) })
        
        return response.payload.highwayVignettes
            .filter { !($0.vignetteType.first?.rawValue.hasPrefix("YEAR_") ?? false) }
            .map { vignette in
                NationalVignetteOption.from(vignette, code: codeLookup[vignette.vehicleCategory] ?? "—")
            }
    }
    
    private static func makeCounty(from response: HighwayInfoResponse) -> [CountyVignetteOption] {
        response.payload.highwayVignettes
            .filter { $0.vignetteType.first?.rawValue.hasPrefix("YEAR_") ?? false }
            .compactMap { v -> CountyVignetteOption? in
                guard let countyID = v.vignetteType.first,
                      let countyName = response.payload.counties.first(where: { $0.id.rawValue == countyID.rawValue })?.name else {
                    return nil
                }
                
                return CountyVignetteOption.from(v, countyName: countyName)
            }
    }
}
