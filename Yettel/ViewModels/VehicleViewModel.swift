import Observation

@Observable
final class VehicleViewModel {
    var vehicleSummary: VehicleSummary?
    var nationalVignetteOptions: [NationalVignetteOption] = []
    var countyVignetteOptions: [CountyVignetteOption] = []
    var errorMessage: String?
    var currentlySelectedNationalVignetteOptionID: String?
    
    var defaultOptionID: String? {
        nationalVignetteOptions.first?.id
    }
    
    var currentlySelectedNationalVignetteOption: NationalVignetteOption? {
        nationalVignetteOptions.first(where: { $0.id == currentlySelectedNationalVignetteOptionID })
    }
    
    private let api: HighwayAPIService
    private(set) var initialFetch = true
    
    init(api: HighwayAPIService = HighwayAPIClient()) {
        self.api = api
    }
    
    func initialLoad() async {
        guard initialFetch else { return }
        initialFetch = false
        
        await load()
    }
    
    func load() async {
        do {
            async let vehicleResponse  = api.fetchVehicleInfo()
            async let highwayResponse  = api.fetchHighwayInfo()
            
            let (vehicle, highway) = try await (vehicleResponse, highwayResponse)
            
            vehicleSummary = VehicleSummary(response: vehicle)
            nationalVignetteOptions = Self.makeNational(from: highway)
            countyVignetteOptions = Self.makeCounty(from: highway)
            
            currentlySelectedNationalVignetteOptionID = defaultOptionID
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private static func makeNational(from response: HighwayInfoResponse) -> [NationalVignetteOption] {
        let codeLookup = Dictionary(uniqueKeysWithValues: response.payload.vehicleCategories.map { ($0.category, $0.vignetteCategory.rawValue) })
        
        return response.payload.highwayVignettes
            .filter { !($0.vignetteType.first?.rawValue.hasPrefix("YEAR_") ?? false) }
            .map { vignette in
                NationalVignetteOption.from(vignette, code: codeLookup[vignette.vehicleCategory] ?? "—")
            }
    }
    
    private static func makeCounty(from response: HighwayInfoResponse) -> [CountyVignetteOption] {
        guard let countyVignette = response.payload.highwayVignettes.first(where: { $0.vignetteType.first?.rawValue.hasPrefix("YEAR_") ?? false }) else {
            return []
        }
        
        return countyVignette.vignetteType.compactMap { id in
            guard let countyName = response.payload.counties.first(where: { $0.id.rawValue == id.rawValue })?.name else {
                return nil
            }
            
            return CountyVignetteOption.from(countyVignette,
                                             countyName: countyName,
                                             overrideID: id.rawValue)
        }
        .sorted { $0.countyName < $1.countyName }
    }
}
