import SwiftUI

@main
struct YettelApp: App {
    private let apiService = HighwayAPIClient()
    
    var body: some Scene {
        WindowGroup {
            VehicleView()
                .environment(\.apiService, apiService)
        }
    }
}
